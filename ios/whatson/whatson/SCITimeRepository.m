//
//  SCITimeRepository.m
//  whatson
//
//  Created by Alex on 19/09/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

#import "SCITimeRepository.h"
#import "SCNSDateBasedTime.h"

@implementation SCITimeRepository

- (jint)endOfBorderTimeInMinutes
{
    return 23 * 60;
}

- (jint)startOfBorderTimeInMinutes
{
    return 17 * 60;
}

- (id<SCTime>)startOfToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *date = [calendar dateFromComponents:components];
    return [[SCNSDateBasedTime alloc] initWithNSDate:date];
}

@end
