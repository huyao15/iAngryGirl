//
//  XLQMobClickUtil.m
//  AngryGirl
//
//  Created by huyao on 13-7-11.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQMobClickUtil.h"
#import "MobClick.h"

@implementation XLQMobClickUtil

+ (void)start
{
    [MobClick startWithAppkey:@"51dd7ad856240bd69d00ae5f" reportPolicy:SEND_INTERVAL channelId:nil];
}

+ (void)click : (NSString *)event
{
    [MobClick endEvent:event];
}

@end
