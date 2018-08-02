//
//  ZDTimeFormatterUtil.h
//  Zhidao
//
//  Created by liu_yang on 4/23/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Utilities.h"

@interface TimeFormatterUtil : NSObject
+ (NSString *)getTimeStringFromDate:(int64_t)date;
/**
 *  短期的时间用xxx之前等描述,长时间的直接显示原时间.
 *
 *  @param date   int64_t 时间
 *  @param format @"MM-dd HH:mm"
 *
 *  @return 时间字符串
 */

+ (NSInteger)getTimeSinceDate:(int64_t)date;

+ (NSString *)getTimeStringFromDate:(int64_t)date withTimeFromat:(NSString *)format;

+ (NSString *)getTodayOrYesterdayTimeStringFromDate:(int64_t)aDate withTimeFromat:(NSString *)format;

+ (NSString *)getStandardTimestringFromSeconds:(NSTimeInterval)seconds;

+ (NSString *)getStandardTimestringFromSeconds:(NSTimeInterval)seconds withFormat:(NSString *)format;

+ (NSString *)getDateStringFromDate:(NSDate *)date withTimeFromat:(NSString *)format;

+ (NSString *)getSceneListTimestringFromSeconds:(int64_t)aDate;

+ (NSString *)getSceneTimestringFromSeconds:(int64_t)aDate;

+ (NSString *)getSystemMsgTimeStringFromSeconds:(NSTimeInterval)time serverTime:(NSTimeInterval)serverTime;
/**
 01:55:55
 55:55
 00:55
 */
+ (NSString *)HMSTimeStringFromSeconds:(NSInteger)seconds;

@end

