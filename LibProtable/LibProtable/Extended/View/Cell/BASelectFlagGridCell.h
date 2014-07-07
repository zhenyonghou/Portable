//
//  SDImageSelectCell.h
//  shuidi2
//
//  Created by houzhenyong on 14-3-4.
//  Copyright (c) 2014年 shuidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BASwitchButton.h"

@protocol BASelectFlagGridCellDelegate;

@interface BASelectFlagGridCell : UICollectionViewCell
{
    CGSize _iconSize;
    UIImageView *_imageView;
}

@property (nonatomic, strong, readonly) BASwitchButton* selectIconButton;

@property (nonatomic, assign) CGFloat iconRightMargin;
@property (nonatomic, assign) CGFloat iconTopMargin;

@property (nonatomic, weak) id<BASelectFlagGridCellDelegate> delegate;

- (void)setUnselectedIcon:(UIImage *)unselectedIcon selectedIcon:(UIImage*)selectedIcon;

- (void)setImage:(UIImage*)image;

@end

@protocol BASelectFlagGridCellDelegate <NSObject>

@optional

- (void)selectFlagGridCell:(BASelectFlagGridCell*)selectFlagCell stateChanged:(BOOL)select;

@end

