//
//  XLQMood.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQMood.h"

@implementation XLQMood

- (id)init : (int)index withCode : (NSString *)code withResource : (NSString *)resource
{
    self = [super init];
    if (self) {
        self.index = index;
        self.code = code;
        self.resource = resource;
    }
    return self;
}

+ (XLQMood *) UNKNOWN;
{
    static XLQMood *mood;
    if (mood == nil) {
        mood = [[XLQMood alloc] init:-1 withCode:@"0000" withResource:@""];
    }
    return mood;
}

+ (XLQMood *) HAPPY
{
    static XLQMood *mood;
    if (mood == nil) {
        mood = [[XLQMood alloc] init:0 withCode:@"0001" withResource:@"happy.gif"];
    }
    return mood;
}

+ (XLQMood *) SAD
{
    static XLQMood *mood;
    if (mood == nil) {
        mood = [[XLQMood alloc] init:1 withCode:@"0002" withResource:@"sad.gif"];
    }
    return mood;
}

+ (XLQMood *) ANGRY
{
    static XLQMood *mood;
    if (mood == nil) {
        mood = [[XLQMood alloc] init:2 withCode:@"0003" withResource:@"angry.gif"];
    }
    return mood;
}

+ (XLQMood *) getMoodByCode : (NSString *)code
{
    if ([@"0001" isEqual:code]) {
        return [XLQMood HAPPY];
    }
    if ([@"0002" isEqual:code]) {
        return [XLQMood SAD];
    }
    if ([@"0003" isEqual:code]) {
        return [XLQMood ANGRY];
    }
    return [XLQMood UNKNOWN];
}

+ (XLQMood *) getMoodByIndex : (int)index
{
    if (0 == index) {
        return [XLQMood HAPPY];
    }
    if (1 == index) {
        return [XLQMood SAD];
    }
    if (2 == index) {
        return [XLQMood ANGRY];
    }
    return [XLQMood UNKNOWN];
}

+ (int) getMoodCount
{
    return 3;
}

@end
