//
//  XLQLeftMenuViewController.h
//  AngryGirl
//
//  Created by Penuel on 13-7-23.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQHeadView.h"

@protocol LeftMenuSelectedDelegate <NSObject>

@optional

- (void)didSelectedYear:(NSInteger)year month:(NSInteger)month;

-(void)didChangeBgImg:(UIImage *)image;

@end

@interface XLQLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HeadViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *headViewArray;

@property (nonatomic, weak) id <LeftMenuSelectedDelegate> delegate;

@end