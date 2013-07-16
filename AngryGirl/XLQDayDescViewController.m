//
//  XLQDayDescViewController.m
//  AngryGirl
//
//  Created by Penuel on 13-7-15.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQDayDescViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "XLQUtil.h"
#import "XLQMoodDAO.h"

@interface XLQDayDescViewController ()

@end

@implementation XLQDayDescViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:1.0 blue:219.0/255.0 alpha:1];
    self.title=@"记录心情";
    
    //bar
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDescription)];
    //head
    UIView *headView = [self buildInfoView:CGRectMake(10, 0, deviceWidth-20, 50)];
    [self.view addSubview:headView];
    
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(10, headView.frame.size.height, deviceWidth-20, 200)];
    self.textView.font=[UIFont systemFontOfSize:18];
    self.textView.layer.borderColor=[[UIColor greenColor]CGColor];
    self.textView.layer.borderWidth=2;
    self.textView.text=self.dayData.description;
    self.textView.layer.masksToBounds=YES;
    self.textView.layer.cornerRadius=5;
    [self.view addSubview:self.textView];
}

-(UIView *)buildInfoView:(CGRect)frame{
    UIView *headView=[[UIView alloc]initWithFrame:frame];
    headView.backgroundColor=[UIColor clearColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, headView.frame.size.width/2, headView.frame.size.height)];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor grayColor];
    label.text=[NSString stringWithFormat:@"%@：",[XLQUtil stringFromDayData:self.dayData] ];
    [headView addSubview:label];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(label.frame.size.width, 0, 50,50)];
    [imageView setImage:[UIImage imageNamed:self.dayData.mood.resource]];
    [headView addSubview:imageView];
    
    return headView;
}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveDescription{
    NSString *description = self.textView.text;
    if ([XLQUtil isEmptyStr:description]) {
        return;
    }
    [XLQMoodDAO updateDescription:description WithYear:self.dayData.year withMonth:self.dayData.month withDay:self.dayData.day];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
