//
//  BAAttributedText.h
//  lxCoretextParagraph
//
//  Created by hou zhenyong on 14-2-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAAttributedText : NSObject {
    UIFont* _textFont;
    UIColor* _textColor;
    
    CGFloat _lineSpacing;
    CGFloat _paragraphSpacing;
}

@property (nonatomic, readonly) NSMutableAttributedString* attributedString;
@property (nonatomic, assign) UIEdgeInsets contentInsets;

- (id)initWithString:(NSString*)string;

- (void)setTextColor:(UIColor *)textColor
            textFont:(UIFont*)font
         lineSpacing:(CGFloat)lineSpacing
    paragraphSpacing:(CGFloat)paragraphSpacing;

// 设置以上属性之后再调用此函数
- (CGFloat)calculateHeightWithWidth:(CGFloat)width;

@end
