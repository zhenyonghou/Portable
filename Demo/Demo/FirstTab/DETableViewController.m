//
//  DETableViewController.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "DETableViewController.h"
#import "BABlankCell.h"

@interface DETableViewController ()

@end

@implementation DETableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BAUtility printRect:self.view.frame mark:@"didAppear view"];
    [BAUtility printRect:self.tableView.frame mark:@"didAppear tableView"];
    NSLog(@"%f", self.tableView.contentInset.top);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
