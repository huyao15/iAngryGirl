//
//  XLQLeftMenuViewController.m
//  AngryGirl
//
//  Created by Penuel on 13-7-23.
//  Copyright (c) 2013年 胡尧. All rights reserved.
//

#import "XLQLeftMenuViewController.h"
#import "XLQMenuContent.h"
#import "XLQLeftMenuCell.h"
#import "XLQMainController.h"
#import "IIViewDeckController.h"


@interface XLQLeftMenuViewController ()

@end

@implementation XLQLeftMenuViewController{
    NSInteger currentRow;
    NSInteger currentSection;
}

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
    UIView *setBgImgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    UIImageView *bgImage=[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"share_to_time_line_icon.png"]];
    [setBgImgView addSubview:bgImage];
    bgImage.frame=CGRectMake(0, 0, 40, 40);
    NSLog(@"%f,%f,%f,%f",bgImage.frame.size.width,bgImage.frame.size.height,bgImage.frame.origin.x,bgImage.frame.origin.y);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(45, 0,setBgImgView.frame.size.width - bgImage.frame.size.width, setBgImgView.frame.size.height)];
    label.backgroundColor=[UIColor clearColor];
    [label setText:@"更换背景图片"];
    [label setTextColor:[UIColor whiteColor]];
    [setBgImgView addSubview:label];
    
    [self.view addSubview:setBgImgView];
    [self loadModel];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-10, setBgImgView.frame.origin.y+setBgImgView.frame.size.height,deviceWidth-leftMenuWidth,deviceHeight-(setBgImgView.frame.origin.y+setBgImgView.frame.size.height))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor grayColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor blackColor];
}

- (void)loadModel{
    currentRow = -1;
    _headViewArray = [[NSMutableArray alloc]init ];
    NSArray *years=[XLQMenuContent usableYears];
    for(int i=0;i<years.count;i++)
	{
		XLQHeadView* headview = [[XLQHeadView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth-leftMenuWidth, 40)];
        headview.delegate = self;
		headview.section = i;
        headview.year=[[years objectAtIndex:i] intValue];
        [headview.backBtn setTitle:[NSString stringWithFormat:@"%d年",[[years objectAtIndex:i] intValue]] forState:UIControlStateNormal];
		[self.headViewArray addObject:headview];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLQHeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    return headView.open?45:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.headViewArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XLQHeadView* headView = [self.headViewArray objectAtIndex:section];
    NSArray *months=[XLQMenuContent usableMonthsFromYear:headView.year];
    return headView.open?[months count]:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headViewArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    XLQHeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    XLQLeftMenuCell *cell = [[XLQLeftMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier rowAtIndexPath:indexPath withHeadView:headView];
//    cell.selectedBackgroundView
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewDeckController toggleLeftViewAnimated:YES];
    currentRow = indexPath.row;
    [_tableView reloadData];
    XLQHeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    NSArray *months=[XLQMenuContent usableMonthsFromYear:headView.year];
    [self.delegate didSelectedYear:headView.year month:[[months objectAtIndex:indexPath.row] intValue]];
}


#pragma mark - HeadViewdelegate
-(void)selectedWith:(XLQHeadView *)view{
    currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[_headViewArray count];i++)
        {
            XLQHeadView *head = [_headViewArray objectAtIndex:i];
            head.open = NO;
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
        return;
    }
    currentSection = view.section;
    [self reset];
    
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[_headViewArray count];i++)
    {
        XLQHeadView *head = [_headViewArray objectAtIndex:i];
        
        if(head.section == currentSection)
        {
            head.open = YES;
            
        }else {
            head.open = NO;
        }
        
    }
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
