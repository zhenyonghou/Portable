//
//  DEBaseForthViewController.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "DEBaseForthViewController.h"
#import "BBSegmentViewController.h"

@interface DEBaseForthViewController () <BBSegmentSubViewControllerProtocol>

@property (nonatomic, strong) NSArray *model;

@end

@implementation DEBaseForthViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle:@"Base Examples"];
    self.model = @[@"Categories", @"View", @"Controllers", @"File", @"Utilities", @"Location"];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
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
    BBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
//    cell.showBottomSeparatorLine = (indexPath.row < [self.model count] - 1);
    cell.textLabel.text = self.model[indexPath.row];
    return cell;
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *name = self.model[indexPath.row];
    
    Class cls = NSClassFromString([NSString stringWithFormat:@"DEC%@ViewController", name]);
    UIViewController *vc = [[cls alloc] init];
    if (!vc) {
        NSLog(@"Error %s", __func__);
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- BBSegmentSubViewControllerProtocol

- (void)segmentedPageShown:(BOOL)shown
{
    self.tableView.scrollsToTop = shown;
}

@end
