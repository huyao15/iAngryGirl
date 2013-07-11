//
//  XLQCalendarData.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLQDayData.h"

@interface XLQCalendarData : NSObject

@property (strong, nonatomic) NSDateComponents *components;
@property (strong, nonatomic) NSDictionary *datas;

+ (XLQCalendarData *)instance;

- (XLQDayData *)getDayOfMonth : (int)index with : (int)dayOfWeek;
- (void)preMonth;
- (void)postMonth;

@end
