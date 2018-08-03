//
//  UIDevice+Info.m
//  homework
//
//  Created by gaofeng on 15/1/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "UIDevice+Info.h"
#import "sys/utsname.h"
#import "ZYBBaseLibHeader.h"
#import "UIDevice+Hardware.h"
/**
 @"i386"      on 32-bit Simulator
 @"x86_64"    on 64-bit Simulator
 @"iPod1,1"   on iPod Touch
 @"iPod2,1"   on iPod Touch Second Generation
 @"iPod3,1"   on iPod Touch Third Generation
 @"iPod4,1"   on iPod Touch Fourth Generation
 @"iPhone1,1" on iPhone
 @"iPhone1,2" on iPhone 3G
 @"iPhone2,1" on iPhone 3GS
 @"iPad1,1"   on iPad
 @"iPad2,1"   on iPad 2
 @"iPad3,1"   on 3rd Generation iPad
 @"iPhone3,1" on iPhone 4 (GSM)
 @"iPhone3,3" on iPhone 4 (CDMA/Verizon/Sprint)
 @"iPhone4,1" on iPhone 4S
 @"iPhone5,1" on iPhone 5 (model A1428, AT&T/Canada)
 @"iPhone5,2" on iPhone 5 (model A1429, everything else)
 @"iPad3,4" on 4th Generation iPad
 @"iPad2,5" on iPad Mini
 @"iPhone5,3" on iPhone 5c (model A1456, A1532 | GSM)
 @"iPhone5,4" on iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
 @"iPhone6,1" on iPhone 5s (model A1433, A1533 | GSM)
 @"iPhone6,2" on iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
 @"iPad4,1" on 5th Generation iPad (iPad Air) - Wifi
 @"iPad4,2" on 5th Generation iPad (iPad Air) - Cellular
 @"iPad4,4" on 2nd Generation iPad Mini - Wifi
 @"iPad4,5" on 2nd Generation iPad Mini - Cellular
 @"iPhone7,1" on iPhone 6 Plus
 @"iPhone7,2" on iPhone 6
 */
@implementation UIDevice (Info)
+ (NSString *)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (BOOL)isLowThanIPhone5
{
    return (int)[[ UIScreen mainScreen] bounds].size.height < 568;
}

+ (BOOL)isIPhone5
{
    return (int)[[ UIScreen mainScreen] bounds].size.height == 568;
    /*兼容iphone SE
    [[self deviceString] rangeOfStringSafely:@"iPhone6"].location != NSNotFound ||//5s
    [[self deviceString] rangeOfStringSafely:@"iPhone5"].location != NSNotFound;//5
     */
}

+ (BOOL)isBigThanIPhone6
{
//    兼容iphone SE
//    NSString *number = [[self deviceString] substringWithRangeSafely:NSMakeRange(6, 1)];
//    if ([number integerValue] >= 7) {
//        return YES;
//    }
    if (DeviceIsIphone) {
        return (int)[[ UIScreen mainScreen] bounds].size.height > 568;
    }
    
    if ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Simulator"]) {
        return [UIScreen mainScreen].bounds.size.width > 320;
    }
    return NO;
}


+ (BOOL)isIPhone6
{
    if ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Simulator"]) {
        return [UIScreen mainScreen].bounds.size.width == 375;
    }
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO);
}

+ (BOOL)isIPhone6Plus
{
    if ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Simulator"]) {
        return [UIScreen mainScreen].bounds.size.width == 414;
    }
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO);
}

+ (BOOL)isIPhone4
{
    NSString *platform = [[UIDevice currentDevice] platform];
    if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] || [platform isEqualToString:@"iPhone3,3"])
        return YES;
    return NO;
}
@end
