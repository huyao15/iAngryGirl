//
//  XLQDayButton.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQDayData.h"

@interface XLQDayButton : UIButton

@property (strong, nonatomic) XLQDayData *data;
- (id)initWithFrame:(CGRect)frame withData : (XLQDayData *)data;

@end
