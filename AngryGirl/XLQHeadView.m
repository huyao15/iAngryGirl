//
//  XLQHeadView.m
//  AngryGirl
//
//  Created by Penuel on 13-7-23.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQHeadView.h"

@implementation XLQHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.open = NO;
        
        self.backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_year.png" ]];
        self.backImage.frame = CGRectMake(10, 0, frame.size.height, frame.size.height);
        [self addSubview:self.backImage];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(self.backImage.frame.size.width +20, 0, frame.size.width-(self.backImage.frame.size.width +20), frame.size.height);
        [self.backBtn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.backBtn];
        
    }
    return self;
}

-(void)doSelected{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}


@end
