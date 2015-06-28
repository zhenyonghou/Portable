//
//  BBLeftViewCell.h
//  LibProtable
//
//  Created by houzhenyong on 14-6-21.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BBTableViewCell.h"

@interface BBLeftImageViewCell : BBTableViewCell {
}

@property (nonatomic, assign) CGRect imageViewFrame;

@property (nonatomic, strong, readonly) UIImageView *leftImageView;

- (void)setLeftImage:(UIImage*)image imageFrame:(CGRect)frame text:(NSString*)text;

@end
