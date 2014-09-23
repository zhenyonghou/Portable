//
// UIAlertView+Blocks.h
// 源码来自https://github.com/jivadevoe/UIAlertView-Blocks
// 使用它省去繁琐的delegate

#import <UIKit/UIKit.h>
#import "BAButtonItem.h"

@interface UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(BAButtonItem *)inCancelButtonItem otherButtonItems:(BAButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(BAButtonItem *)item;

@end
