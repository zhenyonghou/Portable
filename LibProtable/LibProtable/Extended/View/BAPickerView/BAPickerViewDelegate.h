
#import <Foundation/Foundation.h>

@protocol BAPickerViewDelegate <NSObject>

// 确定选中
- (void)confirmPickerView:(id)pickerView/* andContent:(NSString *)content*/;
// 取消选择
- (void)cancelPickerView:(id)pickerView;

@end