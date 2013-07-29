//
//  DDMessageDialogo.h
//  diandian
//
//  Created by 李 鹏鹏 on 13-6-19.
//
//

#import <Foundation/Foundation.h>

@interface XLQMessageDialogo : NSObject
+ (void)showMessage : (NSString *)msg inView : (UIView *)view inSeconds : (float)seconds;
@end
