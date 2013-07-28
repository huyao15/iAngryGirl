//
//  XLQAppDelegate.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQAppDelegate.h"
#import "XLQMainController.h"
#import "XLQDataBaseUtil.h"
#import "XLQMobClickUtil.h"
#import "XLQMoodDAO.h"
#import "IIViewDeckController.h"
#import "XLQLeftMenuViewController.h"

@implementation XLQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL b = [WXApi registerApp:@"wx62b2217684d2e7be"];
    if (!b) {
        NSLog(@"RegisterApp Error");
    }
    [self initDataSource];
    [XLQMobClickUtil start];
//    XLQMainController *mainController = [[XLQMainController alloc] init];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
//    self.window.rootViewController = navController;
    
    IIViewDeckController* deckController = [self generateControllerStack];
    self.window.rootViewController = deckController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (IIViewDeckController*)generateControllerStack {
    XLQLeftMenuViewController* leftController = [[XLQLeftMenuViewController alloc]init];
                                                 
    
    UIViewController *centerController = [[XLQMainController alloc] init];
    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                                    leftViewController:leftController
                                                                                   rightViewController:nil];
    deckController.leftSize = leftMenuWidth;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}

-(void)initDataSource{
    XLQDataBaseUtil *dataBase =[XLQDataBaseUtil sharedInstance];
    [dataBase updateTable];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
