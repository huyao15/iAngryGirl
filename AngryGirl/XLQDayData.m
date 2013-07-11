//
//  XLQDayData.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQDayData.h"

@implementation XLQDayData

- (id)init
{
    self = [super init];
    if (self) {
        self.mood = [XLQMood UNKNOWN];
        self.canChange = NO;
        self.isToday = NO;
    }
    return self;
}

@end
