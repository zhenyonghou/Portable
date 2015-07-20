//
//  DECTestLabelViewController.m
//  Demo
//
//  Created by houzhenyong on 15/2/10.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "DECTestLabelViewController.h"

@interface DECTestLabelViewController () {
    UILabel *_summaryLabel;
}

@end

@implementation DECTestLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int kCellHeight = 170;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, kCellHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    _summaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _summaryLabel.backgroundColor = [UIColor clearColor];
//    _summaryLabel.numberOfLines = 1;
//    _summaryLabel.textColor = SKIN_COLOR(@"color_placeholder");
    _summaryLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:_summaryLabel];
    
    _summaryLabel.text = @"可以更改此内容进行测试，宽度不变，高度根据内容自动调节";
    [_summaryLabel fitSizeWithConstantWidth:(SCREEN_WIDTH - 60 - 35) limitedLines:1];
    [_summaryLabel mm_setLeft:(60) bottom:(kCellHeight - 15)];
    _summaryLabel.backgroundColor = [UIColor redColor];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 34, 0, 35, kCellHeight)];
    tempView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:0.5];
    [contentView addSubview:tempView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
