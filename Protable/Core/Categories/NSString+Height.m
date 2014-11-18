//
//  NSString+SDExtended.m
//  shuidi2
//
//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "NSString+Height.h"

@implementation NSString (Height)

- (CGFloat)calculateHeightWithFont:(UIFont*)font constantWidth:(CGFloat)width
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                  options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:attribute context:nil].size;
    } else {
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size.height;
}

- (CGFloat)calculateHeightWithFont:(UIFont*)font constantWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines
{
    CGSize size;
    CGFloat height = numberOfLines == 0 ? CGFLOAT_MAX : numberOfLines * font.lineHeight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [self boundingRectWithSize:CGSizeMake(width, height)
                                  options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:attribute context:nil].size;
    } else {
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size.height;
}

@end
