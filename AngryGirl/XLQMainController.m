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
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Compress.h"


@interface XLQMainController ()

@end

@implementation XLQMainController {
    XLQDayData *data;
    UIImageView *bgImgView;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    bgImgView = [[UIImageView alloc] initWithImage:[XLQUtil getBackGroudImage]];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.clipsToBounds = YES;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setScrollEnabled:NO];
    self.tableView.backgroundView = bgImgView;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];

    self.navigationController.navigationBar.alpha = 0.8;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [menuButton setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
    menuButton.layer.masksToBounds = YES;
    menuButton.layer.cornerRadius = 4;
    [menuButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.viewDeckController.delegate=self;
    ((XLQLeftMenuViewController *)self.viewDeckController.leftController).delegate = self;
    self.share = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 90, 300, 40)];
    [self.share setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    [self.share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.share setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:0.6]];
    [self.share addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    self.share.layer.masksToBounds = YES;
    self.share.layer.cornerRadius = 5;
    [self.view addSubview:self.share];

    self.descText = [[UITextView alloc]initWithFrame:CGRectMake(5, calCellHeight * 5 , deviceWidth - 10, self.share.frame.origin.y - (calCellHeight * 5 + 10))];
    self.descText.backgroundColor = [UIColor clearColor];
    self.descText.editable = NO;
    self.descText.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.descText];
    self.descText.userInteractionEnabled = YES;
    self.descText.textColor = [UIColor colorWithWhite:0.75 alpha:0.6];
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickDescLable)];
    [self.descText addGestureRecognizer:tapGestureTel];
    self.descText.hidden = YES;
}

- (void)viewDidLoad 
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

#pragma XLQLeftMenuViewController

- (void)didSelectedYear:(NSInteger)year month:(NSInteger)month
{
    [[XLQCalendarData instance] reLoadDataYear:year month:month];
    self.descText.hidden = YES;
    [self loaddata];
    [self.tableView reloadData];
}

-(void)didChangeBgImg:(UIImage *)image{
    [bgImgView setImage:image];
}

- (void)onClickDescLable
{
    NSLog(@"onClickDescLable");
    XLQDayDescViewController *dayDescViewController = [[XLQDayDescViewController alloc]init];
    dayDescViewController.dayData = data;
    dayDescViewController.noShowLeftView = YES;
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
    UIImage *comImage = [image compressedImage:CGSizeMake(150, 150)];
    
    [message setThumbImage:comImage];
    NSLog(@"%d",UIImageJPEGRepresentation(comImage, 1.0).length);
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"图片大小%d",ext.imageData.length);
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

#pragma IIViewDeckControllerDelegate

-(void)viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated{
    if (viewDeckSide==IIViewDeckLeftSide) {
        self.share.userInteractionEnabled = YES;
        self.descText.userInteractionEnabled = YES;
        self.tableView.userInteractionEnabled = YES;
    }
}

-(void)viewDeckController:(IIViewDeckController *)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated{
    if (viewDeckSide==IIViewDeckLeftSide) {
        self.share.userInteractionEnabled = NO;
        self.descText.userInteractionEnabled = NO;
        self.tableView.userInteractionEnabled = NO;
    }
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
    XLQCalendarCell *cell = [[XLQCalendarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withSection:indexPath.section withBtnDelegate:self];

    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return calCellHeight+1;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

@end