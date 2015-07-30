//
//  BAPickerView.h


#import <UIKit/UIKit.h>
#import "BBPickerViewDelegate.h"

@interface BBPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> {
}

- (id)initWithDelegate:(id<BBPickerViewDelegate>)delegate;

- (void)showInView:(UIView *)view;
- (void)hidePickerWithAnimation;

@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) id<BBPickerViewDelegate> delegate;

@end

