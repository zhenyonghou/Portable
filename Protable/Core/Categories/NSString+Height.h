//
//  NSString+SDExtended.h
//  shuidi2
//
//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Height)

- (CGFloat)calculateHeightWithFont:(UIFont*)font constantWidth:(CGFloat)width;
- (CGFloat)calculateHeightWithFont:(UIFont*)font constantWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines;

@end
