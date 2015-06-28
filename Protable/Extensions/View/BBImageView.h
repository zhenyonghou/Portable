//  Created by hou zhenyong on 14-3-31.
//

#import <UIKit/UIKit.h>

@interface BBImageView : UIImageView {
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@property (nonatomic, assign) BOOL enableTouch;     // default NO

@property (nonatomic, copy) void (^touchedBlock)(id sender);

- (void)setCornerRadius:(CGFloat)cornerRadius;

- (void)setImageUrl:(NSString*)avatarUrl placeholderImage:(UIImage*)placeholderImage;

@end

