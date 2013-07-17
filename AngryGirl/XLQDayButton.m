//
//  XLQDayButton.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQDayButton.h"
#import "XLQMoodDAO.h"
#import "XLQMobClickUtil.h"

@implementation XLQDayButton

- (id)initWithFrame:(CGRect)frame withData : (XLQDayData *)data;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        if (self.data.mood == [XLQMood UNKNOWN]) {
            if (self.data.isToday) {
                [self setBackgroundImage:[UIImage imageNamed:@"bg_click_here.png"] forState:UIControlStateNormal];
                [self setTitle:@"" forState:UIControlStateNormal];
            } else {
                [self setBackgroundColor:[UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1]];
                [self setTitle:[NSString stringWithFormat:@"%@", data.text] forState:UIControlStateNormal];
            }
        } else {
            [self setBackgroundColor:nil];
            [self setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:self.data.mood.resource] forState:UIControlStateNormal];
        }
        if (self.data.day <= 0) {
            [self setHidden:YES];
        }
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)onClick
{
    if([self isFuture:self.data]){
        return;
    }
    XLQDayData *sqlData=[XLQMoodDAO queryWithYear:self.data.year withMonth:self.data.month withDay:self.data.day];
    self.data.description=sqlData.description;
    if (self.delegate) {
        [self.delegate clickedDayButton:self.data];
    }
    if (!self.data.canChange) {
        return;
    }
    [XLQMobClickUtil click:@"set_mood_click"];
    XLQMood *mood = [XLQMood getMoodByIndex:(self.data.mood.index+1)%[XLQMood getMoodCount]];
    self.data.mood = mood;
    self.data.updatedTime = [NSDate date];
    [self setBackgroundColor:nil];
    [self setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:mood.resource] forState:UIControlStateNormal];
    
    [XLQMoodDAO saveDB:self.data];
}

-(BOOL)isFuture:(XLQDayData *)data{
    NSDate *today=[NSDate date];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today];
    [comps setYear:data.year];
    [comps setMonth:data.month];
    [comps setDay:data.day];
    NSDate *theDay=[cal dateFromComponents:comps];
    if ([today compare:theDay]<0) {
        return YES;
    }
    return NO;
}

@end
