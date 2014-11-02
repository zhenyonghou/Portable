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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNewTitle:@"FirstViewController"];
    [self setRightItemWithAction:@selector(onTouchRightButton) title:@"push"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchRightButton
{
    DETableViewController *vc = [[DETableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
