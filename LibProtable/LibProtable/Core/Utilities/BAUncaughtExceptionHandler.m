//
//  UncaughtExceptionHandler.m
//

#import "BAUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "BAApplication.h"

void HandleException(NSException *exception);
void SignalHandler(int signal);

NSString * const kUncaughtExceptionHandlerSignalExceptionName   = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const kUncaughtExceptionHandlerSignalKey             = @"UncaughtExceptionHandlerSignalKey";
NSString * const kUncaughtExceptionHandlerAddressesKey          = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t kUncaughtExceptionCount = 0;
const int32_t kUncaughtExceptionMaximum = 10;

const NSInteger kUncaughtExceptionHandlerSkipAddressCount = 0;
const NSInteger kUncaughtExceptionHandlerReportAddressCount = 10;

@implementation BAUncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    //Notice that we skip the first few addresses: this is because they will be the addresses of the signal or exception handling functions (not very interesting). Since we want to keep the data minimal (for display in a UIAlert dialog) I choose not to display the exception handling functions.
    for (
         i = kUncaughtExceptionHandlerSkipAddressCount;
         i < kUncaughtExceptionHandlerSkipAddressCount + kUncaughtExceptionHandlerReportAddressCount;
         i++) {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

+ (void)installUncaughtExceptionHandler
{
    // After install handler, Responding to the exceptions and signals can then happen in the implementation of the HandleException and installUncaughtExceptionHandler
    // install a handler for uncaught Objective-C exceptions
	NSSetUncaughtExceptionHandler(&HandleException);
    
    // install handlers for BSD signals
//	signal(SIGABRT, SignalHandler);
//	signal(SIGILL, SignalHandler);
//	signal(SIGSEGV, SignalHandler);
//	signal(SIGFPE, SignalHandler);
//	signal(SIGBUS, SignalHandler);
//	signal(SIGPIPE, SignalHandler);
}

// 每次APP启动时候先调用一次
+ (void)checkAndUploadLocalCrashLog
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *crashFilePath = [BAApplication crashFilePath];
        if ([fileManager fileExistsAtPath:crashFilePath]) {
            NSStringEncoding code = NSUTF8StringEncoding;
            NSString *fileContent = [NSString stringWithContentsOfFile:crashFilePath usedEncoding:&code error:nil];
            
            if (fileContent && [fileContent length]) {
                // TODO: upload crash log
                
            }
            [fileManager removeItemAtPath:crashFilePath error:nil];
        }
    });
}

@end

void HandleException(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Description: %@", [exception name]);
    NSLog(@"Description: %@", [exception description]);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);

    NSString *crashLog = [NSString stringWithFormat:@"%@%@",[exception name], [exception callStackSymbols]];
    NSError *error;
    if (![crashLog writeToFile:[BAApplication crashFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"write to file error:%@",error);
    }
    
    NSSetUncaughtExceptionHandler(NULL);
//	signal(SIGABRT, SIG_DFL);
//	signal(SIGILL, SIG_DFL);
//	signal(SIGSEGV, SIG_DFL);
//	signal(SIGFPE, SIG_DFL);
//	signal(SIGBUS, SIG_DFL);
//	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:kUncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:kUncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
        // re-raise the exception or resend the signal, to make the application to crash as norma
		[exception raise];
	}
    
}

void SignalHandler(int signal)
{
//	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
//	if (exceptionCount > UncaughtExceptionMaximum)
//	{
//		return;
//	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:kUncaughtExceptionHandlerSignalKey];
    
	NSArray *callStack = [BAUncaughtExceptionHandler backtrace];
	[userInfo setObject:callStack forKey:kUncaughtExceptionHandlerAddressesKey];
    
    
    NSException* exception = [NSException exceptionWithName:kUncaughtExceptionHandlerSignalExceptionName
                                                     reason:[NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal]
                                                   userInfo:userInfo];
	HandleException(exception);
}


