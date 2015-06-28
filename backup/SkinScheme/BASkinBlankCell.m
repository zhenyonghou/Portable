//
//  BASkinBlankCell.m
//  Read
//
//  Created by houzhenyong on 15/2/3.
//  Copyright (c) 2015年 xiaochuankeji. All rights reserved.
//

#import "BASkinBlankCell.h"

@implementation BASkinBlankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_cell_background")]
//               hlBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_cell_highlighted")]];
//        self.bottomSeparatorLine.backgroundColor = SKIN_COLOR(@"color_cell_separator");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeSkin:) name:kSkinChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onChangeSkin:(NSNotification *)notification
{
//    [self setBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_cell_background")]
//           hlBackgroundImage:[UIImage imageWithColor:SKIN_COLOR(@"color_cell_highlighted")]];
//    
//    self.bottomSeparatorLine.backgroundColor = SKIN_COLOR(@"color_cell_separator");
}

@end
