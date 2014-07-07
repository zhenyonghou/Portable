//
//  BACollectionViewLineLayout.h
//
//  Created by hou zhenyong on 14-1-17.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BACollectionViewLineLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat interitemSpacing;

@end
