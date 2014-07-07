//
//  BACollectionViewLineLayout.m
//
//  Created by hou zhenyong on 14-1-17.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BACollectionViewLineLayout.h"

@implementation BACollectionViewLineLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    attributes.center = CGPointMake((self.itemSize.width + self.interitemSpacing) * indexPath.item + self.sectionInset.left + self.itemSize.width/2,
                                    self.itemSize.height/2 + self.sectionInset.top);
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.itemCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

// required
- (CGSize)collectionViewContentSize
{
    CGFloat width = (self.itemSize.width + self.interitemSpacing) * self.itemCount + self.sectionInset.left + self.sectionInset.right;
    CGFloat height = self.collectionView.frame.size.height/* - self.sectionInset.top - self.sectionInset.bottom*/;
    return CGSizeMake(width, height);
}

@end
