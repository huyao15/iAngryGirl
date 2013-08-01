//
//  XLQDayDescViewController.h
//  AngryGirl
//
//  Created by Penuel on 13-7-15.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQDayData.h"
#import "IIViewDeckController.h"

@interface XLQDayDescViewController : UIViewController<UITextViewDelegate,IIViewDeckControllerDelegate>

@property (nonatomic,strong) XLQDayData *dayData;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UILabel *placeHolderLabel;

@property (nonatomic,assign) BOOL noShowLeftView;

@end
