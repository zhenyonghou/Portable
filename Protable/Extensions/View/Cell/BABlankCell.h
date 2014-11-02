//  Created by renren-inc on 13-7-25.
//  Copyright (c) 2013年 RenRen.com. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BACustomCellPositionType) {
    kCustomCellPositionTypeHeader    = 0,
    kCustomCellPositionTypeMiddle,
    kCustomCellPositionTypeTail,
    kCustomCellPositionTypeOnlyOne
};

@interface BASeparatorLineview : UIView

@property (nonatomic, assign) CGFloat lineWidth;        // 粗细程度
@property (nonatomic, strong) UIColor *lineColor;

@end


@interface BABlankCell : UITableViewCell

@property (nonatomic, assign) BOOL showTopSeparatorLine;
@property (nonatomic, assign) BOOL showBottomSeparatorLine;

// cell位置类型
@property (nonatomic, assign) BACustomCellPositionType cellPositionType;

// cell separator
@property (nonatomic, strong, readonly) BASeparatorLineview *topSeparatorLine;
@property (nonatomic, strong, readonly) BASeparatorLineview *bottomSeparatorLine;
@property (nonatomic, assign) CGFloat separatorLineLeftMargin;  // 只对bottom separator line有效

/**
 方便地为cell设置 背景图片
 */
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/**
 方便地设置 accessory image
 */
@property (nonatomic, strong, readonly) UIImageView *accessoryImageView;

@end
