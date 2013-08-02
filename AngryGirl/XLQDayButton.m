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
#import <QuartzCore/QuartzCore.h>

@implementation XLQDayButton

- (id)initWithFrame:(CGRect)frame withData : (XLQDayData *)data;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.6];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        titleLable.textColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        titleLable.font = [UIFont systemFontOfSize:10];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = data.text;
        titleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLable];
        
        _moodImg = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-35)/2, (frame.size.height-20-35)/2+20, 35, 35)];
        [self addSubview:_moodImg];
        if (self.data.mood == [XLQMood UNKNOWN]) {
            if (self.data.isToday) {
                _moodImg.image = [UIImage imageNamed:@"bg_click_here.png"];
            }
        } else {
            _moodImg.image = [UIImage imageNamed:self.data.mood.resource];
        }
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)onClick
{
    if([self isFuture:self.data]||self.data.day<=0){
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
    
    if (self.data != lastData && self.data.mood != [XLQMood UNKNOWN]) {
        
        
    } else {
    
        [XLQMobClickUtil click:@"set_mood_click"];
        XLQMood *mood = [XLQMood getMoodByIndex:(self.data.mood.index+1)%[XLQMood getMoodCount]];
        self.data.mood = mood;
        self.data.updatedTime = [NSDate date];
        _moodImg.image=[UIImage imageNamed:mood.resource];
    
        [XLQMoodDAO saveDB:self.data];
    }
    lastData = self.data;
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
