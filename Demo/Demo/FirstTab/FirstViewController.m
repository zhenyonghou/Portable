//
//  FirstViewController.m
//  Demo
//
//  Created by houzhenyong on 14-11-2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "FirstViewController.h"
#import "DETableViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        _bottomBarHeight = PHONE_TABBAR_HEIGHT;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    [self setRightItemWithAction:@selector(onTouchRightButton) title:@"rightbutton"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BAUtility printRect:self.tableView.frame mark:@"didAppear tableView"];
    NSLog(@"%f %f", self.tableView.contentInset.top, self.tableView.contentInset.bottom);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchRightButton
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
    label.font = [UIFont systemFontOfSize:17];
    static int k = 0;
    label.text = [NSString stringWithFormat:@"Button%d", k++];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    [self.view addSubview:label];
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"blankCellId;laks";
    BABlankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BABlankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor orangeColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DETableViewController *vc = [[DETableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
