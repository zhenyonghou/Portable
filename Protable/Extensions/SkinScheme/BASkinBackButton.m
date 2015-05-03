//
//  BASkinBackButton.m
//  Read
//
//  Created by houzhenyong on 15/2/6.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASkinBackButton.h"

@implementation BASkinBackButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenChangeSkin:) name:kSkinChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setConfigSkinBlock:(ConfigSkinBlock)configSkinBlock
{
    _configSkinBlock = configSkinBlock;
    
    if (_configSkinBlock) {
        _configSkinBlock();
    }
}

- (void)whenChangeSkin:(NSNotification *)notification
{
    if (self.configSkinBlock) {
        self.configSkinBlock();
    } else {
        [self onChangeSkin];
    }
}

- (void)onChangeSkin
{
    
}

+ (BASkinBackButton *)naviBarBackButtonWithTarget:(id)target action:(SEL)action
{
    BASkinBackButton* button = [[BASkinBackButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    if (IOS_VERSION >= 7.0) {
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    }
    return button;
}

@end
