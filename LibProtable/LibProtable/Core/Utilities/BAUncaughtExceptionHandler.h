//
//  UncaughtExceptionHandler.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BAUncaughtExceptionHandler : NSObject

+ (void)installUncaughtExceptionHandler;

+ (void)checkAndUploadLocalCrashLog;

@end


