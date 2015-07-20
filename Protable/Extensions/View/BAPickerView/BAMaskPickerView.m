//
//  MaskPickerView.m
//  Pregnancy
//
//  Created by houzhenyong on 14-6-8.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAMaskPickerView.h"

@implementation BAMaskPickerView

- (id)initWithParentView:(UIView*)parentView
{
    self = [super init];
    if (self) {
        _parentView = parentView;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mm_width, self.mm_height)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor blackColor];
        [self addSubview:_contentView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)show:(BOOL)isShow
{
    if (isShow) {
        [self showInView:self.parentView];
    } else {
        [self dismiss];
    }
}

- (void)showInView:(UIView *)view
{
    if (!_pickerView) {
        _pickerView = [self viewForPicker];
        [self addSubview:_pickerView];
        [self pickerViewReloadData];
    }

    self.frame = CGRectMake(0, 0, view.mm_width, view.mm_height);
    [view addSubview:self];

    _pickerView.frame = [self pickerViewFrameWhenHidden];

    _contentView.alpha = 0.f;

    [UIView animateWithDuration:0.16 animations:^{
        _pickerView.frame = [self pickerViewFrameWhenShow];

        _contentView.alpha = 0.4;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.16 animations:^{
        _pickerView.frame = [self pickerViewFrameWhenHidden];
        _contentView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

// subclass implement
- (UIView*)viewForPicker
{
    return nil;
}

- (CGRect)pickerViewFrameWhenShow
{
    return CGRectZero;
}

- (CGRect)pickerViewFrameWhenHidden
{
    return CGRectZero;
}

- (void)pickerViewReloadData
{

}

@end
