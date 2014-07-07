//
//  BAAttributedText.m
//  lxCoretextParagraph
//
//  Created by hou zhenyong on 14-2-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAAttributedText.h"
#import "NSAttributedString+Height.h"

@implementation BAAttributedText

- (id)initWithString:(NSString*)string
{
    if (self = [super init]) {
        if (string) {
            _attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            _lineSpacing = .0f;
            _paragraphSpacing = .0f;
            _contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    
    _textColor = [UIColor whiteColor];
    _textFont = [UIFont systemFontOfSize:13.f];
    
    return self;
}

- (void)setTextColor:(UIColor *)textColor
            textFont:(UIFont*)font
         lineSpacing:(CGFloat)lineSpacing
    paragraphSpacing:(CGFloat)paragraphSpacing
{
    _textColor = textColor;
    _textFont = font;
    
    [self setAttributesStringAttributes:_attributedString];
    
    _lineSpacing = lineSpacing;
    _paragraphSpacing = paragraphSpacing;
    
    [self setAttributedStringParagraphStyle:_attributedString];
}

- (CGFloat)calculateHeightWithWidth:(CGFloat)width
{
    CGFloat realWidth = width - self.contentInsets.left - self.contentInsets.right;
    return [_attributedString heightForWidth:realWidth] + self.contentInsets.top + self.contentInsets.bottom;
}

- (void)setAttributesStringAttributes:(NSMutableAttributedString *)attributedString
{
    NSDictionary* tempAttributes = @{NSFontAttributeName : _textFont,
                                     NSForegroundColorAttributeName : _textColor,
                                     NSKernAttributeName : @(1.2)};
    [attributedString addAttributes:tempAttributes range:NSMakeRange(0, [attributedString length])];
}

- (void)setAttributedStringParagraphStyle:(NSMutableAttributedString*)attributedString
{    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = _lineSpacing;                              // 行间距
    paragraphStyle.paragraphSpacing = _paragraphSpacing;                    // 段落间距
    paragraphStyle.alignment = NSTextAlignmentLeft; // NSTextAlignmentJustified;
    paragraphStyle.firstLineHeadIndent = _textFont.pointSize * 2;           // 首行缩进距离
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [attributedString length])];
}

@end
