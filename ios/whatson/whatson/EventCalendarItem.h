//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EventCalendarItem.java
//

#ifndef _EventCalendarItem_H_
#define _EventCalendarItem_H_

#include "CalendarItem.h"
#include "J2ObjC_header.h"

@protocol SCTime;

@interface SCEventCalendarItem : NSObject < SCCalendarItem >

#pragma mark Public

- (instancetype)initWithNSString:(NSString *)eventId
                    withNSString:(NSString *)title
                      withSCTime:(id<SCTime>)time;

- (NSString *)id__;

- (jboolean)isEmpty;

- (id<SCTime>)startTime;

- (NSString *)title;

@end

J2OBJC_EMPTY_STATIC_INIT(SCEventCalendarItem)

FOUNDATION_EXPORT void SCEventCalendarItem_initWithNSString_withNSString_withSCTime_(SCEventCalendarItem *self, NSString *eventId, NSString *title, id<SCTime> time);

FOUNDATION_EXPORT SCEventCalendarItem *new_SCEventCalendarItem_initWithNSString_withNSString_withSCTime_(NSString *eventId, NSString *title, id<SCTime> time) NS_RETURNS_RETAINED;

J2OBJC_TYPE_LITERAL_HEADER(SCEventCalendarItem)

@compatibility_alias UkCoAmlcurranSocialEventCalendarItem SCEventCalendarItem;

#endif // _EventCalendarItem_H_