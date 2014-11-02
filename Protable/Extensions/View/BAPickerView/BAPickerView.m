
#import "BAPickerView.h"

@implementation BAPickerView

- (id)initWithDelegate:(id<BAPickerViewDelegate>)delegate {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_NAVIGATIONBAR_HEIGHT - PHONE_STATUSBAR_HEIGHT)]) {
        self.backgroundColor = [UIColor clearColor];

        // 初始化bar
        UIBarButtonItem *canceItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", @"取消")
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(btnCancelClick)];
        
        NSString *doneTitle = NSLocalizedString(@"完成", @"完成");
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:doneTitle
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                                    action:@selector(btnDoneClick)];
        UIBarButtonItem *flexibleSpaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *buttons = [NSArray arrayWithObjects:canceItem, flexibleSpaceBarItem, doneItem, nil];

        // 为子视图构造工具栏
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                       self.frame.size.height - (PHONE_KEYBOARD_HEIGHT+PHONE_TOOLBAR_HEIGHT),
                                                                       self.frame.size.width,
                                                                       PHONE_TOOLBAR_HEIGHT)];
        toolBar.backgroundColor = [UIColor blackColor];
        toolBar.barStyle = UIBarStyleBlack;
        toolBar.translucent = YES;
        [toolBar sizeToFit];
        [toolBar setAlpha:0.7];
        [toolBar setItems:buttons animated:YES]; 
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
        // 初始化pickerView控件
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                              self.frame.size.height - PHONE_KEYBOARD_HEIGHT,
                                                                              self.frame.size.width,
                                                                              PHONE_KEYBOARD_HEIGHT)];
        picker.showsSelectionIndicator = YES;
        picker.dataSource = self;
        picker.delegate = self;
        [self addSubview:picker];
        self.pickerView = picker;
        
        self.delegate = delegate;

        _isShowing = NO;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)btnDoneClick {
    [self.delegate confirmPickerView:self];
}

- (void)btnCancelClick{
    if ([self.delegate respondsToSelector:@selector(cancelPickerView:)]) {
        [self.delegate cancelPickerView:self];
    }
    [self hidePickerWithAnimation];
}


#pragma mark- animation

- (void)showInView:(UIView *)view
{
    if (_isShowing) {
        return;
    }
    _isShowing = YES;
    
    self.frame = CGRectMake(0, view.frame.size.height, view.width, view.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hidePickerWithAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         _isShowing = NO;
                     }];
}


#pragma mark - UIPickerDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger count = 1;
    if ([self.delegate respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        count = [self.delegate numberOfComponentsInPickerView:self];
    }
    
    // 设置selectedIndexs
    
    return count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.delegate pickerView:self numberOfRowsInComponent:component];
}

#pragma mark - UIPickerDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        return [self.delegate pickerView:self titleForRow:row forComponent:component];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }
}


@end
