//
//  BAPickerView.h


#import <UIKit/UIKit.h>
#import "BAPickerViewDelegate.h"

@interface BAPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> {
    BOOL _isShowing;
}

- (id)initWithDelegate:(id<BAPickerViewDelegate>)delegate;
- (void)setData:(NSArray*)data;
- (void)showInView:(UIView *)view;
- (void)hidePickerWithAnimation;

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) id<BAPickerViewDelegate> delegate;

@end

