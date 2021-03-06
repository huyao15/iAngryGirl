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
#import "XLQMessageDialogo.h"

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
    self.viewDeckController.delegate = self;
    
	// Do any additional setup after loading the view.
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,deviceWidth,deviceHeight)];
    [bgImgView setImage:[XLQUtil getBackGroudImage]];
    [bgImgView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgImgView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,deviceWidth,deviceHeight)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgImgView];
    self.title=@"记录心情";
    
    int t = self.navigationController.navigationBar.frame.size.height + 5;
    
    //bar
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDescription)];
    //head
    UIView *headView = [self buildInfoView:CGRectMake(10, t, deviceWidth-20, 50)];
    [self.view addSubview:headView];
    
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(5, headView.frame.size.height + t, deviceWidth-10, 300)];
    self.textView.font=[UIFont systemFontOfSize:18];
    self.textView.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    //self.textView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8].CGColor;
    //self.textView.layer.borderWidth=1;
    self.textView.text=self.dayData.description;
    self.textView.layer.masksToBounds=YES;
    self.textView.layer.cornerRadius=5;
    self.textView.delegate=self;
    self.textView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [self.view addSubview:self.textView];
    
    self.placeHolderLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.textView.frame.size.width, 20)];
    self.placeHolderLabel.backgroundColor=[UIColor clearColor];
    self.placeHolderLabel.text=@"你今天肿么她了...";
    self.placeHolderLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    if ([XLQUtil isEmptyStr:self.dayData.description]) {
        self.placeHolderLabel.hidden=NO;
    }else{
        self.placeHolderLabel.hidden=YES;
    }
    [self.textView addSubview:self.placeHolderLabel];
    
    
    [self setUpForDismissKeyboard];
}

-(UIView *)buildInfoView:(CGRect)frame{
    UIView *headView=[[UIView alloc]initWithFrame:frame];
    headView.backgroundColor=[UIColor clearColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, headView.frame.size.width/2, headView.frame.size.height)];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    label.text=[NSString stringWithFormat:@"%@：",[XLQUtil stringFromDayData:self.dayData] ];
    [headView addSubview:label];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(label.frame.size.width, 0, 50,50)];
    [imageView setImage:[UIImage imageNamed:self.dayData.mood.resource]];
    [headView addSubview:imageView];
    
    return headView;
}

-(void)cancel{
    _noShowLeftView = NO;
    [self viewDeckController:self.viewDeckController shouldOpenViewSide:IIViewDeckLeftSide];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveDescription{
    NSString *description = self.textView.text;
    if ([XLQUtil isEmptyStr:description]) {
        [XLQMessageDialogo showMessage:@"内容不能为空" inView:self.view inSeconds:2];
        return;
    }
    [XLQMoodDAO updateDescription:description WithYear:self.dayData.year withMonth:self.dayData.month withDay:self.dayData.day];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeHolderLabel.hidden=YES;
    return YES;
}


#pragma IIViewDeckSide
- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide{
    if (_noShowLeftView) {
        return NO;
    }
    return YES;
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
