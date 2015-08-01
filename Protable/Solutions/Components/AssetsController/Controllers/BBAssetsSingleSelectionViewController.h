//
//  UIAssetsSingleSelectViewController.h
//  LxAsset
//
//  Created by houzhenyong on 14-6-26.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBAssetsHelper.h"

@protocol BBAssetsSingleSelectionViewControllerDelegate;

@interface BBAssetsSingleSelectionViewController : BBViewController

@property (nonatomic, weak) id<BBAssetsSingleSelectionViewControllerDelegate> delegate;

@end


@protocol BBAssetsSingleSelectionViewControllerDelegate <NSObject>

- (void)assetsSingleSelectViewControllerWillCancel:(BBAssetsSingleSelectionViewController*)viewController;

- (void)assetsSingleSelectViewController:(BBAssetsSingleSelectionViewController*)viewController willComplete:(ALAsset*)selectedAsset;

- (void)assetsSingleSelectViewController:(BBAssetsSingleSelectionViewController*)viewController cameraComplete:(ALAsset*)asset;

@end
