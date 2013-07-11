//
//  XLQMood.h
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLQMood : NSObject

@property (nonatomic) int index;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *resource;

- (id)init : (int)index withCode : (NSString *)code withResource : (NSString *)resource;

+ (XLQMood *) UNKNOWN;
+ (XLQMood *) HAPPY;
+ (XLQMood *) SAD;
+ (XLQMood *) ANGRY;
+ (XLQMood *) getMoodByCode : (NSString *)code;
+ (XLQMood *) getMoodByIndex : (int)index;
+ (int) getMoodCount;

@end
