//
//  XLQCalendarCell.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQCalendarCell.h"
#import "XLQWeekButton.h"
#import "XLQDayButton.h"
#import "XLQCalendarData.h"

@implementation XLQCalendarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection : (int)section;
{
    NSArray *week = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"日", nil];

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.days = [[NSMutableArray alloc] init];
        UIButton *day;
        for (int i=0; i<7; i++) {
            int x = 3 + 45 * i;
            int y = 1;
            if (section == 0) {
                NSString *title = [week objectAtIndex:i];
                day = [[XLQWeekButton alloc] initWithFrame:CGRectMake(x, y+2, 44, 30) withTitle:title];
            } else {
                XLQDayData *data = [[XLQCalendarData instance] getDayOfMonth:(section-1)*7+i+1 with:i];
                day = [[XLQDayButton alloc] initWithFrame:CGRectMake(x, y, 44, 44) withData:data];
            }
            
            [self.days addObject:day];
            [self addSubview:day];
        }
    }
    return self;
}

@end
