
#import "BAPickerView.h"

@implementation BAPickerView

- (id)initWithDelegate:(id<BAPickerViewDelegate>)delegate {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
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
        UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,
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

- (void)setData:(NSArray*)data
{
    self.listData = [NSArray arrayWithArray:data];
}

- (void)btnDoneClick {
//    NSInteger idx = [self.pickerView selectedRowInComponent:0];
    [self.delegate confirmPickerView:self/* andContent:[self.listData objectAtIndex:idx]*/];
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
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hidePickerWithAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
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
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.listData count];
}

#pragma mark - UIPickerDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.listData objectAtIndex:row];  
      
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //
}


@end
