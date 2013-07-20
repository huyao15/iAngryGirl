//
//  XLQMainControllerViewController.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQDayButton.h"

@interface XLQMainController : UITableViewController<DayButtonClickDelegate>

@property (strong,nonatomic) UIButton *share;

@property (strong,nonatomic) UITextView *descText;

@end
