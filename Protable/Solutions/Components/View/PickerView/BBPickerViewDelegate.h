
#import <Foundation/Foundation.h>

@class BBPickerView;

@protocol BBPickerViewDelegate <NSObject>

// 确定选中
- (void)confirmPickerView:(id)pickerView/* andContent:(NSString *)content*/;
// 取消选择
- (void)cancelPickerView:(id)pickerView;

- (NSInteger)pickerView:(BBPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(BBPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional

- (NSInteger)numberOfComponentsInPickerView:(BBPickerView *)pickerView;

- (void)pickerView:(BBPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end