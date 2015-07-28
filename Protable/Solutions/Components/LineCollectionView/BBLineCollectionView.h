//
//  BALineCollectionView.h
//  lxLineCollectionView
//
//  Created by hou zhenyong on 14-1-17.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCollectionViewLineLayout.h"

@protocol BBLineCollectionViewDelegate;

@interface BBLineCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    BBCollectionViewLineLayout* _lineLayout;
}

@property (nonatomic, weak) id<BBLineCollectionViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withRegisterCellClass:(Class)cellClass;

- (void)reloadData;

- (id)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath;

@end


@protocol BBLineCollectionViewDelegate <NSObject>

- (NSInteger)numberOfItemsForLineCollectionView:(BBLineCollectionView*)lineCollectionView;

- (UICollectionViewCell*)lineCollectionView:(BBLineCollectionView*)collectionView
                            cellIndentifier:(NSString*)cellIdentifier
                            cellAtIndexPath:(NSIndexPath *)indexPath;

// layout 相关
- (CGSize)itemSizeForLineCollectionView:(BBLineCollectionView *)lineCollectionView;

- (UIEdgeInsets)edgeInsetsForLineCollectionView:(BBLineCollectionView *)lineCollectionView;

- (CGFloat)interitemSpacingForLineCollectionView:(BBLineCollectionView *)lineCollectionView;

@optional
- (void)lineCollectionView:(BBLineCollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;

@end
