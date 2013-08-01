//
//  XLQHeadView.h
//  AngryGirl
//
//  Created by Penuel on 13-7-23.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewDelegate;

@interface XLQHeadView : UIView

@property (nonatomic, weak) id <HeadViewDelegate>    delegate;
@property (nonatomic, assign) NSInteger              section;
@property (nonatomic, assign) BOOL                   open;
@property (nonatomic, strong) UIButton               *backBtn;
@property (nonatomic, assign) int                   year;
@property (nonatomic, strong) UIImageView           *backImage;

@end

@protocol HeadViewDelegate <NSObject>
- (void)selectedWith:(XLQHeadView *)view;
@end