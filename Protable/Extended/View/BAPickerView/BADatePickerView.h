//
//  BADatePickerView.h
//  Adult
//
//  Created by houzhenyong on 14-7-27.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BADatePickerViewDelegate;

@interface BADatePickerView : UIView

- (id)initWithDelegate:(id<BADatePickerViewDelegate>)delegate;

- (void)showInView:(UIView *)view;
- (void)hidePickerWithAnimation;

@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIDatePicker *pickerView;

@property (nonatomic, strong) NSDate *date;        // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
@property (nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, strong) NSDate *maximumDate; // default is nil

@end



@protocol BADatePickerViewDelegate <NSObject>

// 确定选中
- (void)confirmDatePickerView:(id)pickerView;
// 取消选择
- (void)cancelDatePickerView:(id)pickerView;

@end

