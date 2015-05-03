//  Created by hou zhenyong on 13-7-25.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BACustomCellPositionType) {
    kCustomCellPositionTypeHeader    = 0,
    kCustomCellPositionTypeMiddle,
    kCustomCellPositionTypeTail,
    kCustomCellPositionTypeOnlyOne
};

@interface BASeparatorLineView : UIView

@end


@interface BABlankCell : UITableViewCell

@property (nonatomic, assign) BOOL showBottomSeparatorLine;

// cell位置类型
@property (nonatomic, assign) BACustomCellPositionType cellPositionType;

@property (nonatomic, strong, readonly) BASeparatorLineView *bottomSeparatorLine;
@property (nonatomic, assign) CGFloat separatorLineLeftMargin;  // 只对bottom separator line有效

/**
 方便地为cell设置 背景图片
 */
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/**
 方便地设置 accessory image
 */
@property (nonatomic, strong, readonly) UIImageView *accessoryImageView;

- (void)internalSetting;

- (void)setBackgroundImage:(UIImage*)image hlBackgroundImage:(UIImage*)hlImage;

@end
