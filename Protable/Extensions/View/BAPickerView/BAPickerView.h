//
//  BAPickerView.h


#import <UIKit/UIKit.h>
#import "BAPickerViewDelegate.h"

@interface BAPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> {
}

- (id)initWithDelegate:(id<BAPickerViewDelegate>)delegate;

- (void)showInView:(UIView *)view;
- (void)hidePickerWithAnimation;

@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) id<BAPickerViewDelegate> delegate;

@end

