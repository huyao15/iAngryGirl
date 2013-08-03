//
//  XLQDateUtil.m
//  AngryGirl
//
//  Created by Penuel on 13-8-2.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQDateUtil.h"

#define days @[@4,@6,@9,@11]

@implementation XLQDateUtil

+(NSInteger) columnFromYear:(NSInteger) year month:(NSInteger) month{
    int weekday = [self weekdayOfFirstDayAtYear:year month:month];
    if (month == 2) {
        if (weekday==1) {
            return 4;
        }
    }else if([days containsObject:[NSNumber numberWithInteger:month]]){//30days
        if (weekday>6) {
            return 6;
        }
    }else{//31days
        if (weekday>=6) {
            return 6;
        }
    }
    return 5;
}
//返回星期1/2/3/4/5/6/7
+(NSInteger) weekdayOfFirstDayAtYear:(NSInteger) year month:(NSInteger) month{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekdayCalendarUnit fromDate:[NSDate date]];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:1];
    NSDate *theMonthFirstDay = [cal dateFromComponents:comps];
    NSDateComponents *compsDest = [cal components:NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekdayCalendarUnit fromDate:theMonthFirstDay];
    NSInteger weedayI = compsDest.weekday;
    if (weedayI==1) {
        return 7;
    }
    return weedayI-1;
}

+(NSDateComponents *) compsFromDate:(NSDate *)date{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    return comps;
}

@end
