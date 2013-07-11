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

#import <QuartzCore/QuartzCore.h>

@interface XLQMainController ()

@end

@implementation XLQMainController

- (void)loadView
{
    [super loadView];
    self.title = @"老婆的心情";
    [self.view setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:1.0 blue:219.0/255.0 alpha:1]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setScrollEnabled:NO];
    
    self.share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.share setBackgroundImage:[UIImage imageNamed:@"share_to_time_line_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.share];
    [self.share addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];

    [self loadHeaderView];
}

- (void)loadHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.tableView.tableHeaderView = view;
    
    self.month = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 50)];
    [self.month setBackgroundColor:[UIColor clearColor]];
    [self.month setTextColor:[UIColor blackColor]];
    [self.month setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:self.month];
    
    self.preMonth = [[UIButton alloc] initWithFrame:CGRectMake(38, 9, 22, 31)];
    [self.preMonth setBackgroundImage:[UIImage imageNamed:@"button_pre.png"] forState:UIControlStateNormal];
    [self.preMonth addTarget:self action:@selector(onClickPreMonth) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.preMonth];
    
    self.postMonth = [[UIButton alloc] initWithFrame:CGRectMake(270, 9, 22, 31)];
    [self.postMonth setBackgroundImage:[UIImage imageNamed:@"button_next.png"] forState:UIControlStateNormal];
    [self.postMonth addTarget:self action:@selector(onClickPostMonth) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.postMonth];
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
    [self.month setText:[NSString stringWithFormat:@"%d年%d月", com.year, com.month]];
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
        return 33;
    } else {
        return 45;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
