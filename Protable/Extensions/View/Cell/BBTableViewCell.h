//
//  BBTableViewCell.h
//  Lx0624
//
//  Created by zhenyonghou on 15/6/26.
//  Copyright © 2015年 zhenyonghou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIView *separatorLine;

@property (nonatomic, assign) CGFloat separatorLeftMargin;

/**
 方便地设置 accessory image
 */
@property (nonatomic, strong, readonly) UIImageView *accessoryImageView;


@end
