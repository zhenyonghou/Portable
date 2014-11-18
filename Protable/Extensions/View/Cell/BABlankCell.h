//  Created by Hou zhenyong on 13-7-25.
//  Copyright (c) 2013年 Hou zhenyong. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BACustomCellPositionType) {
    kCustomCellPositionTypeHeader    = 0,
    kCustomCellPositionTypeMiddle,
    kCustomCellPositionTypeTail,
    kCustomCellPositionTypeOnlyOne
};

@interface BASeparatorLineVew : UIView

@property (nonatomic, assign) CGFloat lineWidth;        // 粗细程度
@property (nonatomic, strong) UIColor *lineColor;

@end


@interface BABlankCell : UITableViewCell

@property (nonatomic, assign) BOOL showTopSeparatorLine;
@property (nonatomic, assign) BOOL showBottomSeparatorLine;


/**
 * cell位置类型
 * 根据Cell的位置可以指定背景图片（适用于卡片式），bottom separator line有无等，
 * 这里默认指定的是bottom separator line
 */
@property (nonatomic, assign) BACustomCellPositionType cellPositionType;

// cell separator
@property (nonatomic, strong, readonly) BASeparatorLineVew *topSeparatorLine;
@property (nonatomic, strong, readonly) BASeparatorLineVew *bottomSeparatorLine;
@property (nonatomic, assign) CGFloat separatorLineLeftMargin;  // 只对bottom separator line有效

/**
 方便地为cell设置 背景图片
 */
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/**
 方便地设置 accessory image
 */
@property (nonatomic, strong, readonly) UIImageView *accessoryImageView;

- (void)onChangeSkin:(NSNotification *)notification;

@end
