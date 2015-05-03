//
//  BASkinCollectionViewCell.m
//  Read
//
//  Created by houzhenyong on 15/3/12.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASkinCollectionViewCell.h"

@implementation BASkinCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenChangeSkin:) name:kSkinChangeNotification object:nil];
    }

    self.backgroundColor = SKIN_COLOR(@"color_cell_background");

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
    self.backgroundColor = SKIN_COLOR(@"color_cell_background");
}

@end
