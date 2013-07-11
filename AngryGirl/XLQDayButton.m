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
        } else if (data.canChange) {
            [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return self;
}

-(void)onClick
{
    [XLQMobClickUtil click:@"set_mood_click"];
    XLQMood *mood = [XLQMood getMoodByIndex:(self.data.mood.index+1)%[XLQMood getMoodCount]];
    self.data.mood = mood;
    self.data.updatedTime = [NSDate date];
    [self setBackgroundColor:nil];
    [self setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:mood.resource] forState:UIControlStateNormal];
    
    [XLQMoodDAO saveDB:self.data];
}

@end
