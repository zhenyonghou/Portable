//
//  BABadgeNumberButton.h
//  houzhenyong
//
//  Created by houzhenyong on 14-3-14.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BABadgeNumberButton : UIButton {
    NSInteger _maximumNumber;
    NSInteger _badgeNumber;
    UILabel* _badgeLabel;
}

- (id)initWithFrame:(CGRect)frame withMaximumNumber:(NSUInteger)maximumNumber;

- (void)setBadgeNumber:(NSUInteger)badgeNumber;

- (void)badgeNumberAdd:(NSUInteger)number;

- (void)clearBadge;

@end
