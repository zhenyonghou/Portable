//
//  DEExtensionsExamplesViewController.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "DEExtensionsExamplesViewController.h"


@interface DEExtensionsExamplesViewController ()

@property (nonatomic, strong) NSArray *model;

@end

@implementation DEExtensionsExamplesViewController

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
    
    [self setNewTitle:@"Extensions Examples"];
    
    self.model = @[@"Attributed", @"View"];
    
    [self.tableView reloadData];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [BAUtility printRect:self.view.frame mark:@"2 didAppear view"];
//    [BAUtility printRect:self.tableView.frame mark:@"2 didAppear tableView"];
//    NSLog(@"%f %f", self.tableView.contentInset.top, self.tableView.contentInset.bottom);;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"blankCellId;laks";
    BAEnableTouchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BAEnableTouchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_cell_bg_normal")]
               hlBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_cell_bg_hl")]];
    }
    
    cell.showBottomSeparatorLine = (indexPath.row < [self.model count] - 1);
    
    cell.textLabel.text = self.model[indexPath.row];
    return cell;
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.model[indexPath.row];
    
    Class cls = NSClassFromString([NSString stringWithFormat:@"DEE%@ViewController", name]);
    UIViewController *vc = [[cls alloc] init];
    if (!vc) {
        NSLog(@"Error %s", __func__);
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
