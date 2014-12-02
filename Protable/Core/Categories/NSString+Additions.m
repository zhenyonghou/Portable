//
//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 shuidi. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (CGSize)calculateSizeWithFont:(UIFont*)font maximumWidth:(CGFloat)maximumWidth
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [self boundingRectWithSize:CGSizeMake(maximumWidth, MAXFLOAT)
                                  options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:attribute context:nil].size;
    } else {
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(maximumWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
}

- (CGSize)calculateSizeWithFont:(UIFont*)font maximumWidth:(CGFloat)maximumWidth numberOfLines:(NSUInteger)numberOfLines
{
    CGSize size;
    CGFloat height = numberOfLines == 0 ? CGFLOAT_MAX : numberOfLines * font.lineHeight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [self boundingRectWithSize:CGSizeMake(maximumWidth, height)
                                  options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:attribute context:nil].size;
    } else {
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(maximumWidth, height) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
}

@end
