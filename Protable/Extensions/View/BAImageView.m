//  Created by hou zhenyong on 14-3-31.


#import "BAImageView.h"
//#import "UIImageView+WebCache.h"

@implementation BAImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.exclusiveTouch = YES;
        self.layer.masksToBounds = YES;
        
        _enableTouch = NO;
    }
    return self;
}

- (void)setEnableTouch:(BOOL)enableTouch
{
    _enableTouch = enableTouch;
    if (_enableTouch) {
        if (!_tapGestureRecognizer) {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            [self addGestureRecognizer:_tapGestureRecognizer];
        }
    } else {
        [self removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
}

- (void)dealloc
{
    if (_tapGestureRecognizer) {
        [self removeGestureRecognizer:_tapGestureRecognizer];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setImageUrl:(NSString*)avatarUrl placeholderImage:(UIImage*)placeholderImage
{
//    [self setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:placeholderImage];
}

- (void)onTap:(UIGestureRecognizer*)gestureRecoginizer
{
    if (self.enableTouch) {
        self.touchedBlock(self);
    }
}

@end


