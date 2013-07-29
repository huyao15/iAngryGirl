//
//  DDMessageDialogo.m
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-19.
//
//

#import "XLQMessageDialogo.h"
#import "MBProgressHUD.h"

@implementation XLQMessageDialogo

+ (void)showMessage:(NSString *)msg inView:(UIView *)view inSeconds:(float)seconds
{
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = msg;
    
    HUD.mode = MBProgressHUDModeText;
    
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(seconds);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

@end
