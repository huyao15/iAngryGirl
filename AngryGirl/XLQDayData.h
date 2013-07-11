//
//  XLQDayData.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLQMood.h"

@interface XLQDayData : NSObject

@property (nonatomic) int year;
@property (nonatomic) int month;
@property (nonatomic) int day;
@property (strong, nonatomic) NSDate *updatedTime;
@property (strong, nonatomic) NSString *text;
@property (nonatomic) BOOL canChange;
@property (nonatomic) BOOL isToday;
@property (strong, nonatomic) XLQMood *mood;

@end
