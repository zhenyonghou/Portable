//
// UIActionSheet+Blocks.h
// 源码来自https://github.com/jivadevoe/UIAlertView-Blocks
// 使用它省去繁琐的delegate

#import <UIKit/UIKit.h>
#import "BAButtonItem.h"

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(BAButtonItem *)inCancelButtonItem destructiveButtonItem:(BAButtonItem *)inDestructiveItem otherButtonItems:(BAButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * 使用数组
 */
-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(BAButtonItem *)inCancelButtonItem destructiveButtonItem:(BAButtonItem *)inDestructiveItem otherButtonItemArray:(NSArray *)otherButtonItemArray;

- (NSInteger)addButtonItem:(BAButtonItem *)item;

/** This block is called when the action sheet is dismssed for any reason.
 */
@property (copy, nonatomic) void(^dismissalAction)();

@end
