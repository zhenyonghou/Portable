//
//  NSAttributedString+Height.m
//  lxCoretextParagraph
//
//  Created by hou zhenyong on 14-2-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "NSAttributedString+Height.h"

@implementation NSAttributedString (Height)

-(CGFloat)heightForWidth:(CGFloat)width
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     context:nil];
    return ceilf(CGRectGetHeight(rect)) + 1;
}
@end
