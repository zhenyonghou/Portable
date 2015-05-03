//
//  BASkinImageView.m
//  Read
//
//  Created by houzhenyong on 15/3/13.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASkinImageView.h"

@interface BASkinImageView ()

@property (nonatomic, strong) CALayer *nightLayer;

@end


@implementation BASkinImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (!_nightLayer) {
        _nightLayer = [CALayer layer];
        _nightLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor;
    }

//    self.clipsToBounds = YES;
    [self setSkin];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenChangeSkin:) name:kSkinChangeNotification object:nil];
}

- (void)whenChangeSkin:(NSNotification *)notification
{
    [self setSkin];
    
    if (self.configSkinBlock) {
        self.configSkinBlock();
    } else {
        [self onChangeSkin];
    }
}

- (void)onChangeSkin
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinChangeNotification object:nil];
}

- (void)setSkin
{
//    if ([[BAApplicationConfig sharedInstance].currentSkinName isEqualToString:@"skin_night"]) {
//        _nightLayer.frame = self.bounds;
//        self.layer.mask = _nightLayer;
//    } else {
//        self.layer.mask = nil;
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    if ([[BAApplicationConfig sharedInstance].currentSkinName isEqualToString:@"skin_night"]) {
//        _nightLayer.frame = self.bounds;
//        self.layer.mask = _nightLayer;
//    } else {
//        self.layer.mask = nil;
//    }
}

@end
