//
//  BALineCollectionView.h
//  lxLineCollectionView
//
//  Created by hou zhenyong on 14-1-17.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BACollectionViewLineLayout.h"

@protocol BALineCollectionViewDelegate;

@interface BALineCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    BACollectionViewLineLayout* _lineLayout;
}

@property (nonatomic, assign) Class registerCellClass;

@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, weak) id<BALineCollectionViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withRegisterCellClass:(Class)cellClass;
- (void)reloadData;

@end

@protocol BALineCollectionViewDelegate <NSObject>

- (NSInteger)numberOfItemsForLineCollectionView:(BALineCollectionView*)lineCollectionView;

- (UICollectionViewCell*)lineCollectionView:(BALineCollectionView*)collectionView
                            cellIndentifier:(NSString*)cellIdentifier
                            cellAtIndexPath:(NSIndexPath *)indexPath;

// layout 相关
- (CGSize)itemSizeForLineCollectionView:(BALineCollectionView *)lineCollectionView;

- (UIEdgeInsets)edgeInsetsForLineCollectionView:(BALineCollectionView *)lineCollectionView;

- (CGFloat)interitemSpacingForLineCollectionView:(BALineCollectionView *)lineCollectionView;

@optional
- (void)lineCollectionView:(BALineCollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;

@end
