//
//  XLQMenuCell.m
//  AngryGirl
//
//  Created by Penuel on 13-7-24.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQMenuContent.h"
#import "XLQDateUtil.h"

@implementation XLQMenuContent


+(NSArray *)usableYears{
    //计算用户可查看的年份
    NSDateComponents *comps = [XLQDateUtil compsFromDate:[NSDate date]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=2013;i <= comps.year;i++) {
        [arr addObject:[NSNumber numberWithInt:i]];
    }
    return arr;
}

+(NSArray *)usableMonthsFromYear:(int)year{
    //计算这一年用户可用的月份
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today=[NSDate date];
    NSDateComponents *comps=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:today];
    if (year<comps.year) {
        return @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    }else if(year==comps.year){
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        for (NSInteger i=comps.month; i>=1; i--) {
            [arr addObject:[NSNumber numberWithInt:i]];
        }
        return arr;
    }else{
        return nil;
    }
}

@end
