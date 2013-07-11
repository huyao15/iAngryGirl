//
//  XLQCalendarData.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQCalendarData.h"
#import "XLQMoodDAO.h"

@implementation XLQCalendarData
{
    int xxx;
}
- (id)init
{
    self = [super init];
    if (self) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        self.components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:[NSDate date]];
        [self loadData];
    }
    return self;
}

+ (XLQCalendarData *)instance
{
    static XLQCalendarData *instance;
    if (instance == nil) {
        instance = [[XLQCalendarData alloc] init];
    }
    return instance;
}

- (XLQDayData *)getDayOfMonth : (int)index with : (int)dayOfWeek
{
    XLQDayData *data;
    data.year = self.components.year;
    data.month = self.components.month;
    
    int weekday = (dayOfWeek + 2)%7;
    if (weekday == 0) {
        weekday = 7;
    }
    index = index - xxx;
    [self.components setDay:index];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:self.components];
    NSDateComponents *com = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    if (com.weekday == weekday && self.components.month == com.month) {
        data = [self.datas objectForKey:[NSString stringWithFormat:@"%d_%d_%d", self.components.year, self.components.month, index]];
        if (data == nil) {
            data = [[XLQDayData alloc] init];
        }
        data.year = self.components.year;
        data.month = self.components.month;
        data.day = index;
        data.text = [NSString stringWithFormat:@"%d", index];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if (com.year == today.year && com.month == today.month && index == today.day) {
            [data setIsToday:YES];
            [data setCanChange:YES];
        } else if (com.year == today.year && com.month == today.month && index == today.day - 1 && data.mood == [XLQMood UNKNOWN]) {
            [data setCanChange:YES];
        }
        
    } else {
        xxx ++;
        data = [[XLQDayData alloc] init];
        data.day = 0;
    }
    return data;
}

- (void)preMonth
{
    xxx = 0;
    NSDateComponents *com = [[NSDateComponents alloc] init];
    com.year = self.components.year;
    com.month = self.components.month - 1;
    com.day = 1;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:com];
    self.components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    [self loadData];
}

- (void)postMonth
{
    xxx = 0;
    NSDateComponents *com = [[NSDateComponents alloc] init];
    com.year = self.components.year;
    com.month = self.components.month + 1;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:com];
    self.components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    [self loadData];
}

- (void)loadData
{
    self.datas = [XLQMoodDAO queryWithYear:self.components.year withMonth:self.components.month];
}

@end
