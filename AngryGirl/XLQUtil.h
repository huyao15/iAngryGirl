//
//  XLQUtil.h
//  AngryGirl
//
//  Created by Penuel on 13-7-16.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLQDayData.h"
#define KEY_BGIMG @"backgroud_image"

@interface XLQUtil : NSObject

+(BOOL)isEmptyStr:(NSString *)str;

+(NSString *)stringFromDayData:(XLQDayData *)dayData;

+(UIImage *) getBackGroudImage;

@end
