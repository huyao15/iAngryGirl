//
//  XLQMainControllerViewController.m
//  AngryGirl
//
//  Created by 胡尧 on 13-7-5.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQMainController.h"
#import "XLQCalendarCell.h"
#import "XLQCalendarData.h"
#import "WXApi.h"
#import "XLQMobClickUtil.h"

#import <QuartzCore/QuartzCore.h>

@interface XLQMainController ()

@end

@implementation XLQMainController

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:1.0 blue:219.0/255.0 alpha:1]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setScrollEnabled:NO];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上月" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickPreMonth)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下月" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickPostMonth)];
    
    self.share = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 90, 300, 40)];
    [self.share setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    [self.share setBackgroundColor:[UIColor darkGrayColor]];
    [self.share addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.share];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loaddata];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loaddata
{
    NSDateComponents *com = [[XLQCalendarData instance] components];
    [self setTitle:[NSString stringWithFormat:@"%d年%d月", com.year, com.month]];
}

- (void)onClickPreMonth
{
    [[XLQCalendarData instance] preMonth];
    [self loaddata];
    [self.tableView reloadData];
}

- (void)onClickPostMonth
{
    [[XLQCalendarData instance] postMonth];
    [self loaddata];
    [self.tableView reloadData];
}

- (void) sendImageContent
{
    [XLQMobClickUtil click:@"share_to_pengyouquan_click"];
    UIGraphicsBeginImageContext(self.navigationController.view.bounds.size);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"image:%@",image);
    
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXImageObject *ext = [WXImageObject object];

    ext.imageData = message.thumbData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    BOOL b = [WXApi sendReq:req];
    if (!b) {
        NSLog(@"SendReq Error");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
    XLQCalendarCell *cell =  [[XLQCalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withSection:indexPath.section];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 35;
    } else {
        return 43;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
