//
// BAButtonItem.h
// 源码来自https://github.com/jivadevoe/UIAlertView-Blocks

#import <Foundation/Foundation.h>

@interface BAButtonItem : NSObject
{
    NSString *label;
    void (^action)();
}
@property (retain, nonatomic) NSString *label;
@property (copy, nonatomic) void (^action)();
+(id)item;
+(id)itemWithLabel:(NSString *)inLabel;
+(id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action;
@end

