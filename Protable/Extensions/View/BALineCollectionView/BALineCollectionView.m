//
//  BALineCollectionView.m
//  lxLineCollectionView
//
//  Created by hou zhenyong on 14-1-17.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BALineCollectionView.h"
#import "BACollectionViewCell.h"

@interface BALineCollectionView ()

@property (nonatomic, assign) Class registerCellClass;

@property (nonatomic, strong) UICollectionView* collectionView;

@end

@implementation BALineCollectionView

static NSString* kCellIndentifier = @"MY_CELL";

- (id)initWithFrame:(CGRect)frame withRegisterCellClass:(Class)cellClass
{
    self = [super initWithFrame:frame];
    if (self) {
        _registerCellClass = cellClass;
    }
    return self;
}

- (void)reloadData
{
    if (!_lineLayout) {
        _lineLayout = [[BACollectionViewLineLayout alloc] init];
        _lineLayout.itemSize = [self.delegate itemSizeForLineCollectionView:self];
        _lineLayout.sectionInset = [self.delegate edgeInsetsForLineCollectionView:self];
        _lineLayout.interitemSpacing = [self.delegate interitemSpacingForLineCollectionView:self];
    }
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                                             collectionViewLayout:_lineLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:self.registerCellClass forCellWithReuseIdentifier:kCellIndentifier];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        [self addSubview:_collectionView];
    }

    [_collectionView reloadData];
}

- (id)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:kCellIndentifier forIndexPath:indexPath];
}

#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _lineLayout.itemCount = [self.delegate numberOfItemsForLineCollectionView:self];
    return _lineLayout.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    BACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIndentifier forIndexPath:indexPath];
    return [self.delegate lineCollectionView:self cellIndentifier:kCellIndentifier cellAtIndexPath:indexPath];
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(lineCollectionView:didSelectItemAtIndex:)]) {
        [self.delegate lineCollectionView:self didSelectItemAtIndex:indexPath.item];
    }
}

@end
