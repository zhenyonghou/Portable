//
//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 shuidi. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

- (NSString*)MD5
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)trim {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

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
