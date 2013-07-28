//
//  XLQMenuCell.h
//  AngryGirl
//
//  Created by Penuel on 13-7-24.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLQMenuContent : NSObject

@property (nonatomic, assign) int           year;
@property (nonatomic, assign) int           month;
@property (nonatomic, strong) NSDictionary  *monthMoods;

+(NSArray *)usableYears;

+(NSArray *)usableMonthsFromYear:(int)year;

@end