//
//  XLQCalendarCell.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQCalendarCell.h"
#import "XLQWeekButton.h"
#import "XLQCalendarData.h"
#import <QuartzCore/QuartzCore.h>

@implementation XLQCalendarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(int)section withBtnDelegate:(id /*<DayButtonClickDelegate>*/)delegate
{
    //    NSArray *week = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日", nil];

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.days = [[NSMutableArray alloc] init];
        UIButton *day;

        for (int i = 0; i <= 6; i++) {
            int         x = 3 + 45 * i;
            int         y = 1;
            XLQDayData  *data = [[XLQCalendarData instance] getDayOfMonth:section * 7 + i + 1 with:i];
            //NSLog(@"<<<%d,%d,%d,%d,%d>>>",i,x,y,data.day,data.month);
            day = [[XLQDayButton alloc] initWithFrame:CGRectMake(x, y, 44, calCellHeight) withData:data];
            if (delegate) {
                XLQDayButton *db = ((XLQDayButton *)day);
                db.delegate = delegate;
            }

            [self.days addObject:day];
            [self addSubview:day];
        }
    }

    return self;
}

@end