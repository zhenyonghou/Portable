
#import <Foundation/Foundation.h>

@class BAPickerView;

@protocol BAPickerViewDelegate <NSObject>

// 确定选中
- (void)confirmPickerView:(id)pickerView/* andContent:(NSString *)content*/;
// 取消选择
- (void)cancelPickerView:(id)pickerView;

- (NSInteger)pickerView:(BAPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(BAPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional

- (NSInteger)numberOfComponentsInPickerView:(BAPickerView *)pickerView;

- (void)pickerView:(BAPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end