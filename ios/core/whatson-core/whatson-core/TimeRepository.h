//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/TimeRepository.java
//

#ifndef _TimeRepository_H_
#define _TimeRepository_H_

#include "J2ObjC_header.h"

@protocol SCTime;

@protocol SCTimeRepository < NSObject, JavaObject >

- (jint)endOfBorderTimeInMinutes;

- (jint)startOfBorderTimeInMinutes;

- (id<SCTime>)startOfToday;

@end

J2OBJC_EMPTY_STATIC_INIT(SCTimeRepository)

J2OBJC_TYPE_LITERAL_HEADER(SCTimeRepository)

#define UkCoAmlcurranSocialTimeRepository SCTimeRepository

#endif // _TimeRepository_H_