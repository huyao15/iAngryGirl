//
//  XLQDayButton.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQDayData.h"

const static XLQDayData *lastData;

@protocol DayButtonClickDelegate <NSObject>

-(void)clickedDayButton:(XLQDayData *) dayData;

@end

@interface XLQDayButton : UIButton

@property (strong, nonatomic) XLQDayData *data;

@property (strong, nonatomic) UIImageView *moodImg;

@property (assign,nonatomic) BOOL selected;

@property (weak,nonatomic) id<DayButtonClickDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withData : (XLQDayData *)data;

@end
