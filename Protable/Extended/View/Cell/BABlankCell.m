//
//  RRSpring
//
//  Created by renren-inc on 13-7-25.
//  Copyright (c) 2013年 RenRen.com. All rights reserved.
//

#import "BABlankCell.h"

#define kAccessoryViewRightMargin   10
#define kAccessoryViewLeftSpacing   5

@implementation BASeparatorLineview

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _lineWidth = 0.5f;
        _lineColor = SKIN_COLOR(@"cell_separator");
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [_lineColor set];
    
    // 获取图像环境上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置线宽
    CGContextSetLineWidth(context, _lineWidth);

    CGContextMoveToPoint(context, 0, 0);

    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    
    // 绘制
    CGContextStrokePath(context);
}

@end

#pragma mark-
#pragma mark- BABlankCell

@implementation BABlankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _separatorLineLeftMargin = 0.f;
        _topSeparatorLine = [[BASeparatorLineview alloc] initWithFrame:CGRectZero];
        _bottomSeparatorLine = [[BASeparatorLineview alloc] initWithFrame:CGRectZero];

        _topSeparatorLine.hidden = YES;
        _topSeparatorLine.backgroundColor = SKIN_COLOR(@"cell_separator");
        _bottomSeparatorLine.backgroundColor = SKIN_COLOR(@"cell_separator");

        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundView = _backgroundImageView;

        _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setCellPositionType:(BACustomCellPositionType)cellPositionType
{
    _cellPositionType = cellPositionType;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    // background image
//    if (self.backgroundImageView.image && [self.backgroundView isEqual:self.backgroundImageView]) {
//        self.backgroundView = _backgroundImageView;
//    }
    
    // separator line
    self.topSeparatorLine.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    self.bottomSeparatorLine.frame = CGRectMake(_separatorLineLeftMargin,
                                                self.frame.size.height - 1, self.frame.size.width, 0.5);

    // accessory image view
    if (self.accessoryImageView.image) {
        CGSize imageSize = self.accessoryImageView.image.size;
        self.accessoryImageView.frame = CGRectMake(self.width - kAccessoryViewRightMargin - imageSize.width - kAccessoryViewLeftSpacing,
                                                   (self.height - imageSize.height)/2,
                                                   imageSize.width,
                                                   imageSize.height);
        [self addSubview:self.accessoryImageView];
        self.textLabel.width = (self.accessoryImageView.left - kAccessoryViewLeftSpacing) - self.textLabel.left;
    } else {
        [self.accessoryImageView removeFromSuperview];
        self.textLabel.width = self.right - self.textLabel.left;
    }
}

- (void)setShowTopSeparatorLine:(BOOL)showTopSeparatorLine
{
    [self addSubview:_topSeparatorLine];
    _topSeparatorLine.hidden = !showTopSeparatorLine;
}

- (void)setShowBottomSeparatorLine:(BOOL)showBottomSeparatorLine
{
    [self addSubview:_bottomSeparatorLine];
    _bottomSeparatorLine.hidden = !showBottomSeparatorLine;
}

- (void)setSeparatorColor:(UIColor*)aColor
{
    _topSeparatorLine.backgroundColor = aColor;
    _bottomSeparatorLine.backgroundColor = aColor;
}

@end


