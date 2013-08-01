//
//  XLQLeftMenuCell.m
//  AngryGirl
//
//  Created by Penuel on 13-7-28.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQLeftMenuCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation XLQLeftMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowAtIndexPath:(NSIndexPath *)indexPath withHeadView:(XLQHeadView *)headView{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 30, self.frame.size.height-5)];
        NSArray *months=[XLQMenuContent usableMonthsFromYear:headView.year];
        int month=[[months objectAtIndex:indexPath.row] intValue];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.text = [NSString stringWithFormat:@"%d月",month];
        monthLabel.textColor = [UIColor whiteColor];
        [self addSubview:monthLabel];
        
        UIView *moodView = [[UIView alloc]initWithFrame:CGRectMake(monthLabel.frame.size.width+monthLabel.frame.origin.x+10, 0, self.frame.size.width-(monthLabel.frame.size.width+monthLabel.frame.origin.x+10), self.frame.size.height-5)];
        [self loadMoodsByYear:headView.year month:month];
        NSArray *moods = [self.monthMoods allKeys];
        for (int i=0;i<moods.count;i++) {
            NSString *mood_code = [moods objectAtIndex:i];
            XLQMood *mood = [XLQMood getMoodByCode:mood_code];
            UIImageView *moodImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:mood.resource]];
            moodImage.frame = CGRectMake(57*i, (moodView.frame.size.height-25)/2, 25, 25);
            [moodView addSubview:moodImage];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(57*i+25, 0, 32, moodView.frame.size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor lightTextColor];
            label.font = [UIFont systemFontOfSize:12];
            label.text = [NSString stringWithFormat:@"X%d", [[self.monthMoods valueForKey:mood_code ]intValue]];
            [moodView addSubview:label];
        }
        
        UILabel *monthMoodBorder = [[UILabel alloc]initWithFrame:CGRectMake(0, monthLabel.frame.origin.y+monthLabel.frame.size.height, deviceWidth - leftMenuWidth, 1)];
        monthMoodBorder.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:monthMoodBorder];
        
        [self addSubview:moodView];
    }
    return self;
}

-(void)loadMoodsByYear:(NSInteger) year month:(NSInteger) month{
    self.monthMoods = [XLQMoodDAO groupByMoodCodeWithYear:year withMonth:month];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
