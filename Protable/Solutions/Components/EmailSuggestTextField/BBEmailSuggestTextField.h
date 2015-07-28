//
//  HGEmailSuggestTextField.h
//  LxTextField
//
//  Created by zhenyonghou on 15/6/11.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//  仿豆瓣邮件输入框

#import <UIKit/UIKit.h>

@interface BBEmailSuggestTextField : UITextField

@property (nonatomic, strong, readonly) UILabel *autocompleteLabel;

@property (nonatomic, strong) NSArray *preferredDomainList;

@property (nonatomic, assign) CGPoint autocompleteTextOffset;

@end
