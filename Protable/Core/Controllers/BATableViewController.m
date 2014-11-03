//
//  BATableViewController.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BATableViewController.h"

@interface BATableViewController ()

@end

@implementation BATableViewController

- (id)init
{
    if (self = [super init]) {
        _bottomBarHeight = 0.f;
    }
    return self;
}

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS_VERSION >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(PHONE_NAVIGATIONBAR_HEIGHT + PHONE_STATUSBAR_HEIGHT,
                                                   0,
                                                   _bottomBarHeight,
                                                   0);
        self.tableView.contentInset = edgeInsets;
    }
}


#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
