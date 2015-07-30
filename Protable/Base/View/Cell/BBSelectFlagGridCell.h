//
//  SDImageSelectCell.h
//  shuidi2
//
//  Created by houzhenyong on 14-3-4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSwitchButton.h"

@protocol BBSelectFlagGridCellDelegate;

@interface BBSelectFlagGridCell : UICollectionViewCell
{
    CGSize _iconSize;
    UIImageView *_imageView;
}

@property (nonatomic, strong, readonly) BBSwitchButton* selectIconButton;

@property (nonatomic, assign) CGFloat iconRightMargin;
@property (nonatomic, assign) CGFloat iconTopMargin;

@property (nonatomic, weak) id<BBSelectFlagGridCellDelegate> delegate;

- (void)setUnselectedIcon:(UIImage *)unselectedIcon selectedIcon:(UIImage*)selectedIcon;

- (void)setImage:(UIImage*)image;

@end

@protocol BBSelectFlagGridCellDelegate <NSObject>

@optional

- (void)selectFlagGridCell:(BBSelectFlagGridCell*)selectFlagCell stateChanged:(BOOL)select;

@end

