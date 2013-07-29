//
//  XLQMainControllerViewController.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQDayButton.h"
#import "XLQLeftMenuViewController.h"
#import "IIViewDeckController.h"

@interface XLQMainController : UITableViewController<DayButtonClickDelegate,LeftMenuSelectedDelegate,IIViewDeckControllerDelegate>

@property (strong,nonatomic) UIButton *share;

@property (strong,nonatomic) UITextView *descText;

@end
