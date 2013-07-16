//
//  XLQUtil.h
//  AngryGirl
//
//  Created by Penuel on 13-7-16.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLQDayData.h"

@interface XLQUtil : NSObject

+(BOOL)isEmptyStr:(NSString *)str;

+(NSString *)stringFromDayData:(XLQDayData *)dayData;

@end
