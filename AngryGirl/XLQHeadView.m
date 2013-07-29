//
//  XLQHeadView.m
//  AngryGirl
//
//  Created by Penuel on 13-7-23.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQHeadView.h"
#import <QuartzCore/QuartzCore.h>

@implementation XLQHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.open = NO;

        self.backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_close.png"]];
        self.backImage.frame = CGRectMake(10, 0, frame.size.height, frame.size.height);

        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.backBtn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10 + frame.size.height, 0, 0);
        [self.backBtn addSubview:self.backImage];

        UILabel *backBtnBorder = [[UILabel alloc]initWithFrame:CGRectMake(0, _backBtn.frame.origin.y + _backBtn.frame.size.height, deviceWidth - leftMenuWidth, 1)];
        backBtnBorder.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:backBtnBorder];
        [self addSubview:self.backBtn];
    }

    return self;
}

- (void)doSelected
{
    if (self.open) {
        self.backImage.image = [UIImage imageNamed:@"icon_close.png"];
    } else {
        self.backImage.image = [UIImage imageNamed:@"icon_open.png"];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]) {
        [_delegate selectedWith:self];
    }
}

@end