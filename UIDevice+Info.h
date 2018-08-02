//
//  UIDevice+Info.h
//  homework
//
//  Created by gaofeng on 15/1/16.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Info)
#define DeviceIsPad          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DeviceIsIphone       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

+ (NSString *)deviceString;
+ (BOOL)isIPhone6Plus;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone5;
+ (BOOL)isLowThanIPhone5;///<
+ (BOOL)isBigThanIPhone6;//>=
+ (BOOL)isIPhone4;
@end
