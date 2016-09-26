//
//  SCIEventStoreRepository.m
//  whatson
//
//  Created by Alex on 20/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCIEventStoreRepository.h"
#import <EventKit/EventKit.h>
#import "EventRepositoryAccessor.h"
#import "TimeCalculator.h"
#import "Whatson-Swift.h"

@interface SCIEKEventAccessor : NSObject<SCEventRepositoryAccessor>

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, assign) NSInteger currentPosition;
@property (nonatomic, strong) NSDateCalculator *timeCalculator;

- (instancetype)initWithEventItems:(NSArray *)items;

@end

@implementation SCIEKEventAccessor

- (instancetype)initWithEventItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _events = items;
        _currentPosition = -1;
        _timeCalculator = [[NSDateCalculator alloc] init];
    }
    return self;
}

- (NSString *)getTitle
{
    return [self currentEvent].title;
}

- (NSString *)getEventIdentifier
{
    return [self currentEvent].eventIdentifier;
}

- (jboolean)nextItem
{
    if ([self.events count] == 0) {
        return false;
    }
    if (self.currentPosition < (int) [self.events count] - 1) {
        self.currentPosition++;
        return true;
    }
    return false;
}

- (void)endAccess
{
    self.currentPosition = -1;
}

- (SCTimestamp *)getStartTime
{
    NSDate *date = [self currentEvent].startDate;
    return [self.timeCalculator time:date];
}

- (SCTimestamp *)getEndTime
{
    NSDate *date = [self currentEvent].endDate;
    return [self.timeCalculator time:date];
}

- (EKEvent *)currentEvent
{
    return ((EKEvent *) [[self events] objectAtIndex:self.currentPosition]);
}

@end

@interface SCIEventStoreRepository()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateCalculator *calculator;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation SCIEventStoreRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _calculator = [[NSDateCalculator alloc] init];
        _predicate = [EventPredicates standardPredicates];
    }
    return self;
}

- (id<SCEventRepositoryAccessor>)queryEventsWithSCTimeOfDay:(SCTimeOfDay *)fivePm
                                            withSCTimeOfDay:(SCTimeOfDay *)elevenPm
                                            withSCTimestamp:(SCTimestamp *)searchStartTime
                                            withSCTimestamp:(SCTimestamp *)searchEndTime {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSDate *startTime =  [self.calculator date:searchStartTime];
    NSDate *endTime = [self.calculator date:searchEndTime];
    NSPredicate *search = [eventStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:nil];
    NSArray *array = [eventStore eventsMatchingPredicate:search];
    NSArray *filtered = [array filteredArrayUsingPredicate:self.predicate];
    return [[SCIEKEventAccessor alloc] initWithEventItems:filtered];
}


@end
