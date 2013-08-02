//
//  XLQDateUtil.h
//  AngryGirl
//
//  Created by Penuel on 13-8-2.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLQDateUtil : NSObject

+(NSInteger) columnFromYear:(NSInteger) year month:(NSInteger) month;

+(NSInteger) weekdayOfFirstDayAtYear:(NSInteger) year month:(NSInteger) month;

+(NSDateComponents *) compsFromDate:(NSDate *)date;

@end
