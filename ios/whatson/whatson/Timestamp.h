//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/Timestamp.java
//

#include "J2ObjC_header.h"

#pragma push_macro("Timestamp_INCLUDE_ALL")
#ifdef Timestamp_RESTRICT
#define Timestamp_INCLUDE_ALL 0
#else
#define Timestamp_INCLUDE_ALL 1
#endif
#undef Timestamp_RESTRICT

#if !defined (SCTimestamp_) && (Timestamp_INCLUDE_ALL || defined(SCTimestamp_INCLUDE))
#define SCTimestamp_

@protocol SCTimeCalculator;

@interface SCTimestamp : NSObject

#pragma mark Public

- (instancetype)initWithLong:(jlong)millis
        withSCTimeCalculator:(id<SCTimeCalculator>)timeCalculator;

- (jint)daysSinceEpoch;

- (jlong)getMillis;

- (SCTimestamp *)plusDaysWithInt:(jint)days;

- (SCTimestamp *)plusHoursWithInt:(jint)hours;

@end

J2OBJC_EMPTY_STATIC_INIT(SCTimestamp)

FOUNDATION_EXPORT void SCTimestamp_initWithLong_withSCTimeCalculator_(SCTimestamp *self, jlong millis, id<SCTimeCalculator> timeCalculator);

FOUNDATION_EXPORT SCTimestamp *new_SCTimestamp_initWithLong_withSCTimeCalculator_(jlong millis, id<SCTimeCalculator> timeCalculator) NS_RETURNS_RETAINED;

FOUNDATION_EXPORT SCTimestamp *create_SCTimestamp_initWithLong_withSCTimeCalculator_(jlong millis, id<SCTimeCalculator> timeCalculator);

J2OBJC_TYPE_LITERAL_HEADER(SCTimestamp)

@compatibility_alias UkCoAmlcurranSocialTimestamp SCTimestamp;

#endif

#pragma pop_macro("Timestamp_INCLUDE_ALL")