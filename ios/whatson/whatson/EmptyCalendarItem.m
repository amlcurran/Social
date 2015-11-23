//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/EmptyCalendarItem.java
//

#include "EmptyCalendarItem.h"
#include "J2ObjC_source.h"
#include "SCTime.h"

@interface SCEmptyCalendarItem () {
 @public
  SCTime *startTime_;
  SCTime *endTime_;
}

@end

J2OBJC_FIELD_SETTER(SCEmptyCalendarItem, startTime_, SCTime *)
J2OBJC_FIELD_SETTER(SCEmptyCalendarItem, endTime_, SCTime *)

@implementation SCEmptyCalendarItem

- (instancetype)initWithSCTime:(SCTime *)startTime
                    withSCTime:(SCTime *)endTime {
  SCEmptyCalendarItem_initWithSCTime_withSCTime_(self, startTime, endTime);
  return self;
}

- (NSString *)title {
  return @"Empty";
}

- (SCTime *)startTime {
  return startTime_;
}

- (SCTime *)endTime {
  return endTime_;
}

- (jboolean)isEmpty {
  return true;
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "initWithSCTime:withSCTime:", "EmptyCalendarItem", NULL, 0x1, NULL, NULL },
    { "title", NULL, "Ljava.lang.String;", 0x1, NULL, NULL },
    { "startTime", NULL, "Luk.co.amlcurran.social.Time;", 0x1, NULL, NULL },
    { "endTime", NULL, "Luk.co.amlcurran.social.Time;", 0x1, NULL, NULL },
    { "isEmpty", NULL, "Z", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "startTime_", NULL, 0x12, "Luk.co.amlcurran.social.Time;", NULL, NULL, .constantValue.asLong = 0 },
    { "endTime_", NULL, 0x12, "Luk.co.amlcurran.social.Time;", NULL, NULL, .constantValue.asLong = 0 },
  };
  static const J2ObjcClassInfo _SCEmptyCalendarItem = { 2, "EmptyCalendarItem", "uk.co.amlcurran.social", NULL, 0x1, 5, methods, 2, fields, 0, NULL, 0, NULL, NULL, NULL };
  return &_SCEmptyCalendarItem;
}

@end

void SCEmptyCalendarItem_initWithSCTime_withSCTime_(SCEmptyCalendarItem *self, SCTime *startTime, SCTime *endTime) {
  (void) NSObject_init(self);
  self->startTime_ = startTime;
  self->endTime_ = endTime;
}

SCEmptyCalendarItem *new_SCEmptyCalendarItem_initWithSCTime_withSCTime_(SCTime *startTime, SCTime *endTime) {
  SCEmptyCalendarItem *self = [SCEmptyCalendarItem alloc];
  SCEmptyCalendarItem_initWithSCTime_withSCTime_(self, startTime, endTime);
  return self;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(SCEmptyCalendarItem)
