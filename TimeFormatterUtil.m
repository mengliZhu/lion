//
//  ZDTimeFormatterUtil.m
//  Zhidao
//
//  Created by liu_yang on 4/23/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "TimeFormatterUtil.h"

@implementation TimeFormatterUtil

+ (NSInteger)getTimeSinceDate:(int64_t)date {
    NSString *temp = [NSString stringWithFormat:@"%lld", date];
    NSTimeInterval interval = date;
    if (temp.length >= 13) {
        interval = date / 1000.0;
    }
    NSInteger newSeconds = [[NSDate date] timeIntervalSince1970] - interval;
    return newSeconds;
}

+ (NSString *)getTimeStringFromDate:(int64_t)aDate withTimeFromat:(NSString *)format
{
    NSString *temp = [NSString stringWithFormat:@"%lld",aDate];
    NSTimeInterval interval = aDate;
    if (temp.length >= 13) {
        interval = aDate / 1000.0;
    }
    NSDate *desDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString *timeString = nil;
    if ([desDate isToday]) {//如果是今天
        timeString = @"今天";
    }else if ([desDate isYesterday]) {//如果是昨天
        timeString = @"昨天";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:format];
        timeString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:desDate]];
        
    }
    if ([timeString isKindOfClass:[NSString class]]) {
        return timeString;
    }
    return nil;
}

+ (NSString *)getTodayOrYesterdayTimeStringFromDate:(int64_t)aDate withTimeFromat:(NSString *)format
{
    NSString *temp = [NSString stringWithFormat:@"%lld",aDate];
    NSTimeInterval interval = aDate;
    if (temp.length >= 13) {
        interval = aDate / 1000.0;
    }
    NSDate *desDate = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString *timeString = nil;
    if ([desDate isToday]) {//如果是今天
        timeString = @"今天";
    }else if ([desDate isYesterday]) {//如果是昨天
        timeString = @"昨天";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:format];
        timeString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:desDate]];
        
    }
    if ([timeString isKindOfClass:[NSString class]]) {
        return timeString;
    }
    return nil;
}

+ (NSString *)getTimeStringFromDate:(int64_t)date
{
    return [self getTimeStringFromDate:date withTimeFromat:@"MM-dd"];
}

+ (NSString *)getStandardTimestringFromSeconds:(NSTimeInterval)seconds
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *_date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_date]];
}

+ (NSString *)getStandardTimestringFromSeconds:(NSTimeInterval)seconds withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    NSDate *_date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_date]];
}

+ (NSString *)getDateStringFromDate:(NSDate *)date withTimeFromat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *timeString = [dateFormatter stringFromDate:date];
    if ([timeString isKindOfClass:[NSString class]]) {
        return timeString;
    }
    return nil;
}

+ (NSString *)getSceneListTimestringFromSeconds:(int64_t)aDate {
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *dateFormatter2;
    //https://stackoverflow.com/questions/11062280/nsdateformatter-in-12-hour-mode
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = twelveHourLocale;
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone: [NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"KK:mm"];
        
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH"];
    });
    
    NSString *temp = [NSString stringWithFormat:@"%lld",aDate];
    NSTimeInterval interval = aDate;
    if (temp.length >= 13) interval = aDate / 1000.0;
    NSDate *_date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString *strHour = [dateFormatter2 stringFromDate:_date];
    NSInteger hour = [strHour integerValue];
    if ([_date isToday])
    {
        [dateFormatter setDateFormat:@"KK:mm"];
        if (hour>=0 && hour<6)
        {
            return [NSString stringWithFormat:@"凌晨%@", [dateFormatter stringFromDate:_date]];
        }else if (hour>=6 && hour<12){
            return [NSString stringWithFormat:@"上午%@", [dateFormatter stringFromDate:_date]];
        }
        else if (hour>=12 && hour<18)
        {
            return [NSString stringWithFormat:@"下午%@", [dateFormatter stringFromDate:_date]];
        }else if (hour>=18 && hour<24)
        {
            return [NSString stringWithFormat:@"晚上%@", [dateFormatter stringFromDate:_date]];
        }
    }
    else if ([_date isYesterday])
    {
        return [NSString stringWithFormat:@"昨天"];
    }
    else if ([_date isThisYear])
    {
        [dateFormatter setDateFormat:@"MM月dd日"];
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_date]];
    }
    [dateFormatter setDateFormat:@"yy年MM月dd日"];
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_date]];
}

+ (NSString *)getSceneTimestringFromSeconds:(int64_t)aDate {
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *dateFormatter2;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = twelveHourLocale;
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone: [NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"KK:mm"];
        
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH"];
    });
    NSString *temp = [NSString stringWithFormat:@"%lld",aDate];
    NSTimeInterval interval = aDate;
    if (temp.length >= 13) interval = aDate / 1000.0;
    NSDate *_date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString *strHour = [dateFormatter2 stringFromDate:_date];
    NSInteger hour = [strHour integerValue];
    
    if ([_date isToday])
    {
        [dateFormatter setDateFormat:@"KK:mm"];
        if (hour>=0 && hour<6)
        {
            return [NSString stringWithFormat:@"凌晨%@", [dateFormatter stringFromDate:_date]];
        }else if (hour>=6 && hour<12){
            return [NSString stringWithFormat:@"上午%@", [dateFormatter stringFromDate:_date]];
        }
        else if (hour>=12 && hour<18)
        {
            return [NSString stringWithFormat:@"下午%@", [dateFormatter stringFromDate:_date]];
        }else if (hour>=18 && hour<24)
        {
            return [NSString stringWithFormat:@"晚上%@", [dateFormatter stringFromDate:_date]];
        }
    }
    else if ([_date isYesterday])
    {
        [dateFormatter setDateFormat:@"KK:mm"];
        if (hour>=0 && hour<6)
        {
            return [NSString stringWithFormat:@"昨天 凌晨%@", [dateFormatter stringFromDate:_date]];
        }else if (hour>=6 && hour<12){
            return [NSString stringWithFormat:@"昨天 上午%@", [dateFormatter stringFromDate:_date]];
        }
        else if (hour>=12 && hour<18)
        {
            return [NSString stringWithFormat:@"昨天 下午%@", [dateFormatter stringFromDate:_date]];
        }else if (hour>=18 && hour<24)
        {
            return [NSString stringWithFormat:@"昨天 晚上%@", [dateFormatter stringFromDate:_date]];
        }
    }
    else if ([_date isThisYear])
    {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_date]];
    }
    
    [dateFormatter setDateFormat:@"yy年MM月dd日 HH:mm"];
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_date]];
}

+ (NSString *)getSystemMsgTimeStringFromSeconds:(NSTimeInterval)time serverTime:(NSTimeInterval)serverTime{
    
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = twelveHourLocale;
        [dateFormatter setTimeZone: [NSTimeZone localTimeZone]];
    });
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:serverTime];
    
    long diffSecond = serverTime-time;
    if (diffSecond <= 60) {
        return @"刚刚";
    }else if(diffSecond <= 60*60){
        return [NSString stringWithFormat:@"%ld分钟前",diffSecond/60];
    }else if((diffSecond <= 24*60*60) && (date.day == serverDate.day)){
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
    }else if((diffSecond <= 48*60*60) && ([date dateByAddingDays:1].day == serverDate.day)){
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
    }else if([date isSameYearAsDate:serverDate]){
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }else{
        [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
}

+ (NSString *)HMSTimeStringFromSeconds:(NSInteger)seconds {
    NSInteger H = seconds / (60 * 60);
    NSInteger M = seconds / 60 % 60;
    NSInteger S = seconds % 60;
    if (H) {
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd", H, M, S];
    }
    return [NSString stringWithFormat:@"%02zd:%02zd", M, S];
}

@end

