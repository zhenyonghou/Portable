//
//  DEBaseFirstViewController
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "DESComponentsViewController.h"
#import "BBUtility.h"
#import "BBSegmentViewController.h"

@interface DESComponentsViewController () <BBSegmentSubViewControllerProtocol>

@property (nonatomic, strong) NSArray *model;

@end

@implementation DESComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = @[@"EmailSuggestTextField", @"Web"];
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    [self.tableView reloadData];
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
