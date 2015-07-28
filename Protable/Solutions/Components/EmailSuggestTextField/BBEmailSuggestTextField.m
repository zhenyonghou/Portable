//
//  HGEmailSuggestTextField.m
//  LxTextField
//
//  Created by zhenyonghou on 15/6/11.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import "BBEmailSuggestTextField.h"

@interface BBEmailSuggestTextField ()

@property (nonatomic, strong, readwrite) UILabel *autocompleteLabel;

@property (nonatomic, strong) NSString *autocompleteString;

@end

@implementation BBEmailSuggestTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self internalSetting];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self internalSetting];
    }
    return self;
}

- (void)internalSetting
{
    [self setupAutocompleteLabel];
    
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.returnKeyType = UIReturnKeyNext;
    self.autocorrectionType = UITextAutocorrectionTypeNo;

    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    _autocompleteLabel.font = font;
}

- (BOOL)becomeFirstResponder
{
//    [self clearAutocompleteData];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (self.autocompleteString.length > 0) {
        self.text = [NSString stringWithFormat:@"%@%@", self.text, self.autocompleteString];
    }
    
    [self clearAutocompleteData];
    return [super resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
}

- (void)clearAutocompleteData
{
    self.autocompleteString = @"";
    self.autocompleteLabel.text = @"";
    self.autocompleteLabel.hidden = YES;
}

- (void)setupAutocompleteLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = self.font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.hidden = YES;
    label.lineBreakMode = NSLineBreakByClipping;
    self.autocompleteLabel = label;
    
    [self addSubview:self.autocompleteLabel];
    
    self.autocompleteString = @"";
}

- (void)textFieldDidChange:(id)sender
{
    [self checkAndMatchingDomain];
}

- (void)checkAndMatchingDomain
{
    NSUInteger locationOfAt = [self.text rangeOfString:@"@"].location;
    if (NSNotFound != locationOfAt && locationOfAt < self.text.length - 1) {
        NSString *inputDomain = [self.text substringFromIndex:locationOfAt + 1];
        
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", inputDomain];
        NSArray *searchResult = [self.preferredDomainList filteredArrayUsingPredicate:predicateString];
        
//        NSLog(@"inputDomain = %@", inputDomain);

//        NSLog(@"searchResult = %@", searchResult);

        if (searchResult.count > 0) {
            self.autocompleteString = [searchResult[0] substringFromIndex:inputDomain.length];
            self.autocompleteLabel.text = self.autocompleteString;
            NSLog(@"autocompleteString = %@", self.autocompleteString);
        } else {
            [self clearAutocompleteData];
        }
    } else {
        [self clearAutocompleteData];
    }
    
    [self updateAutocompleteLabel];
}

- (CGRect)calculateFrameOfAutocompleteLabel
{
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
    
    CGRect prefixTextRect = [self.text boundingRectWithSize:textRect.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil];
    
    CGSize autocompleteTextSize = [self.autocompleteString boundingRectWithSize:CGSizeMake(textRect.size.width - prefixTextRect.size.width, textRect.size.height)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                     attributes:attribute
                                                                        context:nil].size;
    
    CGRect autocompleteLabelRect = CGRectMake(textRect.origin.x + prefixTextRect.size.width + self.autocompleteTextOffset.x,
                                              textRect.origin.y + self.autocompleteTextOffset.y,
                                              autocompleteTextSize.width,
                                              textRect.size.height);

    return autocompleteLabelRect;
}

- (void)updateAutocompleteLabel
{
    if (self.autocompleteString.length > 0) {
        self.autocompleteLabel.hidden = NO;

        self.autocompleteLabel.frame = [self calculateFrameOfAutocompleteLabel];
    } else {
        self.autocompleteLabel.hidden = YES;
    }
}

@end
