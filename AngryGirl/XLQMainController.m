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
#import "XLQDayDescViewController.h"
#import "XLQUtil.h"
#import "IIViewDeckController.h"

#import <QuartzCore/QuartzCore.h>

#define calTitleHeight  35
#define calTextHeight   43

@interface XLQMainController ()

@end

@implementation XLQMainController {
    XLQDayData *data;
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithRed:254.0 / 255.0 green:1.0 blue:219.0 / 255.0 alpha:1]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setScrollEnabled:NO];

    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_more.png"] style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    ((XLQLeftMenuViewController *)self.viewDeckController.leftController).delegate=self;
    self.share = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 90, 300, 40)];
    [self.share setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    [self.share setBackgroundColor:[UIColor darkGrayColor]];
    [self.share addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.share];

    self.descText = [[UITextView alloc]initWithFrame:CGRectMake(10, (calTextHeight * 5 + calTitleHeight), deviceWidth - 20, self.share.frame.origin.y - (calTextHeight * 5 + calTitleHeight + 5))];
    self.descText.backgroundColor = [UIColor clearColor];
    self.descText.editable = NO;
    self.descText.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.descText];
    self.descText.userInteractionEnabled = YES;
    self.descText.textColor = [UIColor grayColor];
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickDescLable)];
    [self.descText addGestureRecognizer:tapGestureTel];
    self.descText.hidden = YES;
}

- (void)viewDidLoad//此方法会再road的时候还进入吗
{
    [super viewDidLoad];
    [self loaddata];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.descText.hidden = YES;
    self.share.hidden = NO;
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

-(void)didSelectedYear:(NSInteger)year month:(NSInteger)month{
    NSDateComponents *com = [[[XLQCalendarData alloc] initWithYear:year month:month] components];
    [self setTitle:[NSString stringWithFormat:@"%d年%d月", com.year, com.month]];
    [self.tableView reloadData];
}

- (void)onClickDescLable
{
    NSLog(@"onClickDescLable");
    XLQDayDescViewController *dayDescViewController = [[XLQDayDescViewController alloc]init];
    dayDescViewController.dayData = data;
    [self.navigationController pushViewController:dayDescViewController animated:YES];
}

- (void)clickedDayButton:(XLQDayData *)dayData
{
    self.descText.hidden = NO;

    if ([XLQUtil isEmptyStr:dayData.description]) {
        self.descText.text = [NSString stringWithFormat:@"[点我] %@：", [XLQUtil stringFromDayData:dayData]];
    } else {
        self.descText.text = [NSString stringWithFormat:@"%@：%@", [XLQUtil stringFromDayData:dayData], dayData.description];
    }

    data = dayData;
}

- (void)sendImageContent
{
    self.share.hidden = YES;
    self.descText.hidden = YES;
    
    [XLQMobClickUtil click:@"share_to_pengyouquan_click"];
    UIGraphicsBeginImageContext(self.navigationController.view.bounds.size);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSLog(@"image:%@", image);

    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageWithData:UIImageJPEGRepresentation(image, 0.3)]];

    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0);

    message.mediaObject = ext;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;

    BOOL b = [WXApi sendReq:req];

    if (!b) {
        NSLog(@"SendReq Error");
    }
    self.share.hidden = NO;
    req = nil;
    message = nil;
    image = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
    XLQCalendarCell *cell = [[XLQCalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withSection:indexPath.section withBtnDelegate:self withComps:nil];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return calTitleHeight;
    } else {
        return calTextHeight;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end