//
//  BARightViewCell.h
//  LibProtable
//
//  Created by houzhenyong on 14-6-22.

//

#import "BASkinBlankCell.h"

@interface BASkinRightViewCell : BASkinBlankCell

@property (nonatomic, strong) UIView *rightView;    // default is nil

- (void)updateRithView;

@end
