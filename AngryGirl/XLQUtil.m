//
//  XLQUtil.m
//  AngryGirl
//
//  Created by Penuel on 13-7-16.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQUtil.h"

@implementation XLQUtil

+(BOOL)isEmptyStr:(NSString *)str{
    if (str==nil||[@"" isEqualToString:str]) {
        return YES;
    }
    return NO;
}

+(NSString *)stringFromDayData:(XLQDayData *)dayData{
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [comps setYear:dayData.year];
    [comps setMonth:dayData.month];
    [comps setDay:dayData.day];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy年MM月dd日";
    return [formatter stringFromDate:[calendar dateFromComponents:comps]];
}

@end
