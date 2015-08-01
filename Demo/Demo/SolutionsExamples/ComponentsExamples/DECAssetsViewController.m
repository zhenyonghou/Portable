//
//  DECAssetsViewController.m
//  Demo
//
//  Created by mumuhou on 15/8/1.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "DECAssetsViewController.h"
#import "BBAssetsSingleSelectionViewController.h"
#import "BBAssetsMultiSelectionViewController.h"

@interface DECAssetsViewController () <BBAssetsMultiSelectionViewControllerDelegate, BBAssetsSingleSelectionViewControllerDelegate>

@end

static NSString *kCellId = @"kCellId001";

@implementation DECAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"multiple select";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"single select";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Camera";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BBAssetsMultiSelectionViewController *vc = [[BBAssetsMultiSelectionViewController alloc] initWithMaximumSelectCount:0];
        vc.delegate = self;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        BBAssetsSingleSelectionViewController *vc = [[BBAssetsSingleSelectionViewController alloc] init];
        vc.delegate = self;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
    } else if (indexPath.row == 2) {
    
    }
}


#pragma mark- BBAssetsMultiSelectionViewControllerDelegate

- (void)assetsMultiSelectViewControllerWillCancel:(BBAssetsMultiSelectionViewController*)viewController
{

}

- (void)assetsMultiSelectViewController:(BBAssetsMultiSelectionViewController*)viewController willComplete:(NSArray*)assetsArray
{

}


#pragma mark-

- (void)assetsSingleSelectViewControllerWillCancel:(BBAssetsSingleSelectionViewController*)viewController{
    
}

- (void)assetsSingleSelectViewController:(BBAssetsSingleSelectionViewController*)viewController willComplete:(ALAsset*)selectedAsset{
    
}

- (void)assetsSingleSelectViewController:(BBAssetsSingleSelectionViewController*)viewController cameraComplete:(ALAsset*)asset
{

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
