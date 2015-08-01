//
//  BBAssetsMultiSelectionViewController.h
//  LxAsset
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBAssetsHelper.h"

@protocol BBAssetsMultiSelectionViewControllerDelegate;

@interface BBAssetsMultiSelectionViewController : BBViewController

@property (nonatomic, assign) NSInteger maximumSelect;

@property (nonatomic, weak) id<BBAssetsMultiSelectionViewControllerDelegate> delegate;

- (id)initWithMaximumSelectCount:(NSInteger)maximumSelect;

- (NSArray*)selectedAssets;

/**
 *  从选择队列中删除，并且刷新collectionView
 */
- (void)removeAssetFromSelectedArrayAtIndex:(NSUInteger)index;


@end

@protocol BBAssetsMultiSelectionViewControllerDelegate <NSObject>

- (void)assetsMultiSelectViewControllerWillCancel:(BBAssetsMultiSelectionViewController*)viewController;

- (void)assetsMultiSelectViewController:(BBAssetsMultiSelectionViewController*)viewController willComplete:(NSArray*)assetsArray;

@optional

- (void)assetsMultiSelectViewController:(BBAssetsMultiSelectionViewController*)viewController cameraComplete:(ALAsset*)asset;


@end
