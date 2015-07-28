//
//  DECWebViewController.m
//  Demo
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "DECWebViewController.h"

@interface DECWebViewController ()

@end

@implementation DECWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadUrl:@"http://www.baidu.com"];
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
