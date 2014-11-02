//
//  UIView+Bounce.m
//  lxAnimation
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "UIView+Bounce.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Bounce)

+ (CAKeyframeAnimation*)dockBounceAnimation
{
    CGFloat const kFactorsPerSec    = 15.0f;
    CGFloat const kFactorsMaxValue  = 128.0f;
//    NSUInteger const kNumFactors    = 22;
//    CGFloat factors[kNumFactors]    = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 32, 32, 18, 28, 32, 28, 128, 128};
    
    NSUInteger const kNumFactors    = 5;
    CGFloat factors[kNumFactors]    = {80, 150, 120, 110, 128};
    
    NSMutableArray* transforms = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < kNumFactors; i++)
    {
//        CGFloat positionOffset  = factors[i]/ kFactorsMaxValue * viewHeight;
//        CATransform3D transform = CATransform3DMakeTranslation(0.0f, -positionOffset, 0.0f);

        CGFloat stretchFactor = factors[i]/ kFactorsMaxValue;
        
//        NSLog(@"%f", stretchFactor);
        CATransform3D transform = CATransform3DMakeScale(stretchFactor, stretchFactor, 0);
        
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount           = 1;
    animation.duration              = kNumFactors * 1.0f/kFactorsPerSec;
    animation.fillMode              = kCAFillModeForwards;
    animation.values                = transforms;
    animation.removedOnCompletion   = YES; // final stage is equal to starting stage
    animation.autoreverses          = NO;
    
    return animation;
}

- (void)bounce:(float)bounceFactor
{
    CAKeyframeAnimation* animation = [[self class] dockBounceAnimation];
    [self.layer addAnimation:animation forKey:@"bouncing"];
}

@end
