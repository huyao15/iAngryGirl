//
//  XLQLeftMenuCell.h
//  AngryGirl
//
//  Created by Penuel on 13-7-28.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQHeadView.h"
#import "XLQMenuContent.h"
#import "XLQMoodDAO.h"
#import "XLQMood.h"

@interface XLQLeftMenuCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *monthMoods;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowAtIndexPath:(NSIndexPath *)indexPath withHeadView:(XLQHeadView *)headView;

@end
