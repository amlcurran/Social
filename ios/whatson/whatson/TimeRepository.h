//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/TimeRepository.java
//

#include "J2ObjC_header.h"

#pragma push_macro("TimeRepository_INCLUDE_ALL")
#ifdef TimeRepository_RESTRICT
#define TimeRepository_INCLUDE_ALL 0
#else
#define TimeRepository_INCLUDE_ALL 1
#endif
#undef TimeRepository_RESTRICT

#if !defined (SCTimeRepository_) && (TimeRepository_INCLUDE_ALL || defined(SCTimeRepository_INCLUDE))
#define SCTimeRepository_

@class SCTimeOfDay;
@class SCTimestamp;

@protocol SCTimeRepository < NSObject, JavaObject >

- (SCTimeOfDay *)borderTimeEnd;

- (SCTimeOfDay *)borderTimeStart;

- (SCTimestamp *)startOfToday;

@end

J2OBJC_EMPTY_STATIC_INIT(SCTimeRepository)

J2OBJC_TYPE_LITERAL_HEADER(SCTimeRepository)

#define UkCoAmlcurranSocialTimeRepository SCTimeRepository

#endif

#pragma pop_macro("TimeRepository_INCLUDE_ALL")