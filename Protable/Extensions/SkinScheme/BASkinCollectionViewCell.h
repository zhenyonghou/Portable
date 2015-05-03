//
//  BASkinCollectionViewCell.h
//  Read
//
//  Created by houzhenyong on 15/3/12.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfigSkinBlock)(void);

@interface BASkinCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) ConfigSkinBlock configSkinBlock;

// for subview
- (void)onChangeSkin;

@end
