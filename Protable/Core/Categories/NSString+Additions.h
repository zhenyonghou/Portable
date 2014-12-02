//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 shuidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (CGSize)calculateSizeWithFont:(UIFont*)font maximumWidth:(CGFloat)maximumWidth;
- (CGSize)calculateSizeWithFont:(UIFont*)font maximumWidth:(CGFloat)maximumWidth numberOfLines:(NSUInteger)numberOfLines;

@end
