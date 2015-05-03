//
//  RRSpring
//
//  Created by renren-inc on 13-7-25.
//

#import "BABlankCell.h"

#define kAccessoryViewRightMargin   15
#define kAccessoryViewLeftSpacing   5

@implementation BASeparatorLineView

@end


#pragma mark- XCBlankCell

@implementation BABlankCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetting];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self internalSetting];
    }
    return self;
}

- (void)internalSetting
{
    self.backgroundColor = [UIColor clearColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _separatorLineLeftMargin = 15.f;
    _bottomSeparatorLine = [[BASeparatorLineView alloc] initWithFrame:CGRectZero];
    _bottomSeparatorLine.backgroundColor = SKIN_COLOR(@"color_cell_separator");
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundView = _backgroundImageView;
    
    _accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
}

- (void)setCellPositionType:(BACustomCellPositionType)cellPositionType
{
    _cellPositionType = cellPositionType;
    if (kCustomCellPositionTypeTail == cellPositionType
        || kCustomCellPositionTypeOnlyOne == cellPositionType) {
        self.showBottomSeparatorLine = NO;
    } else {
        self.showBottomSeparatorLine = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.bottomSeparatorLine.frame = CGRectMake(_separatorLineLeftMargin,
                                                self.frame.size.height - 0.5,
                                                self.frame.size.width,
                                                0.5);
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

- (void)setShowBottomSeparatorLine:(BOOL)showBottomSeparatorLine
{
    if (showBottomSeparatorLine) {
        [self addSubview:_bottomSeparatorLine];
    } else {
        [_bottomSeparatorLine removeFromSuperview];
    }
    _bottomSeparatorLine.hidden = !showBottomSeparatorLine;
}

#pragma mark- touch

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setBackgroundImage:(UIImage*)image hlBackgroundImage:(UIImage*)hlImage
{
    self.backgroundImageView.image = image;
    self.backgroundImageView.highlightedImage = hlImage;
    
    self.backgroundImageView.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:NO];
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:NO];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backgroundImageView setHighlighted:NO];
    [super touchesMoved:touches withEvent:event];
}


@end
