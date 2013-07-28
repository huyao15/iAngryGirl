//
//  XLQCalendarCell.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLQDayButton.h"

@interface XLQCalendarCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *days;

@property (weak,nonatomic) id<DayButtonClickDelegate> dayBtnDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection : (int)section withBtnDelegate:(id /*<DayButtonClickDelegate>*/)delegate withComps:(NSDateComponents *)comp;

@end
