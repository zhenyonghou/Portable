//
//  DECEmailSuggestTextFieldViewController.m
//  Demo
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "DECEmailSuggestTextFieldViewController.h"
#import "BBEmailSuggestTextField.h"

@interface DECEmailSuggestTextFieldViewController () <UITextFieldDelegate>

@property (nonatomic, strong) BBEmailSuggestTextField *emailTextField;

@end

@implementation DECEmailSuggestTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setItemTitle:@"输入邮箱"];
    
    self.emailTextField = [[BBEmailSuggestTextField alloc] initWithFrame:CGRectMake(15, 140, SCREEN_WIDTH - 15 * 2, 40)];
    
    NSArray *domainList = @[@"gmail.com", @"qq.com", @"126.com", @"163.com", @"hotmail.com"];
    
    self.emailTextField.preferredDomainList = domainList;
    self.emailTextField.delegate = self;
    self.emailTextField.font = [UIFont systemFontOfSize:15];
    self.emailTextField.backgroundColor = [UIColor whiteColor];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.emailTextField setPlaceholder: NSLocalizedString(@"Email address", nil)];
    self.emailTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_icon"]];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.emailTextField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.emailTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.emailTextField resignFirstResponder];
}

@end
