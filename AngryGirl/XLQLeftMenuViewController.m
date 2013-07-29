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
#import "XLQUtil.h"

@interface XLQLeftMenuViewController ()

@end

@implementation XLQLeftMenuViewController {
    NSInteger   currentRow;
    NSInteger   currentSection;
    UIImageView *bgImage;
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
    UIButton *changeBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, deviceWidth - leftMenuWidth, 40)];
    bgImage = [[UIImageView alloc]initWithImage:[XLQUtil getBackGroudImage]];
    bgImage.frame = CGRectMake(5, 5, 30, 30);
    [changeBgBtn addSubview:bgImage];
    UILabel *changeBgBtnBorder = [[UILabel alloc]initWithFrame:CGRectMake(0, changeBgBtn.frame.origin.y+changeBgBtn.frame.size.height, deviceWidth - leftMenuWidth, 1)];
    changeBgBtnBorder.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:changeBgBtnBorder];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, changeBgBtn.frame.size.width - bgImage.frame.size.width, changeBgBtn.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:@"换背景图"];
    [label setTextColor:[UIColor whiteColor]];
    [changeBgBtn addSubview:label];
    [self.view addSubview:changeBgBtn];

    [changeBgBtn addTarget:self action:@selector(changeBgImg) forControlEvents:UIControlEventTouchUpInside];

    [self loadModel];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-10, changeBgBtn.frame.origin.y + changeBgBtn.frame.size.height, deviceWidth - leftMenuWidth, deviceHeight - (changeBgBtn.frame.origin.y + changeBgBtn.frame.size.height))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorColor = [UIColor grayColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)loadModel
{
    currentRow = -1;
    _headViewArray = [[NSMutableArray alloc]init];
    NSArray *years = [XLQMenuContent usableYears];

    for (int i = 0; i < years.count; i++) {
        XLQHeadView *headview = [[XLQHeadView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth - leftMenuWidth, 40)];
        headview.delegate = self;
        headview.section = i;
        headview.year = [[years objectAtIndex:i] intValue];
        [headview.backBtn setTitle:[NSString stringWithFormat:@"%d年", [[years objectAtIndex:i] intValue]] forState:UIControlStateNormal];
        [self.headViewArray addObject:headview];
    }
}

- (void)changeBgImg
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self.viewDeckController toggleLeftViewAnimated:YES];
    [self.viewDeckController.centerController presentModalViewController:picker animated:YES];
}

#pragma UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    bgImage.image = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [[NSUserDefaults standardUserDefaults] setValue:imageData forKey:KEY_BGIMG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.delegate didChangeBgImg:image];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLQHeadView *headView = [self.headViewArray objectAtIndex:indexPath.section];

    return headView.open ? 35 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headViewArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XLQHeadView *headView = [self.headViewArray objectAtIndex:section];
    NSArray     *months = [XLQMenuContent usableMonthsFromYear:headView.year];
    return headView.open ?[months count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headViewArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    XLQHeadView     *headView = [self.headViewArray objectAtIndex:indexPath.section];
    XLQLeftMenuCell *cell = [[XLQLeftMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier rowAtIndexPath:indexPath withHeadView:headView];
    //    cell.selectedBackgroundView
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
    currentRow = indexPath.row;
    [_tableView reloadData];
    XLQHeadView *headView = [self.headViewArray objectAtIndex:indexPath.section];
    NSArray     *months = [XLQMenuContent usableMonthsFromYear:headView.year];
    [self.delegate didSelectedYear:headView.year month:[[months objectAtIndex:indexPath.row] intValue]];
}

#pragma mark - HeadViewdelegate
- (void)selectedWith:(XLQHeadView *)view
{
    currentRow = -1;

    if (view.open) {
        for (int i = 0; i < [_headViewArray count]; i++) {
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

// 界面重置
- (void)reset
{
    for (int i = 0; i < [_headViewArray count]; i++) {
        XLQHeadView *head = [_headViewArray objectAtIndex:i];

        if (head.section == currentSection) {
            head.open = YES;
        } else {
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