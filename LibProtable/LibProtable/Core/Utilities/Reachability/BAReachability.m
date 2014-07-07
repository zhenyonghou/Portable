//
//  SFReachability.m
//  lxReachability
//
//  Created by hou zhenyong on 14-1-7.
//  Copyright (c) 2014年 sfbest. All rights reserved.
//

#import "BAReachability.h"

static BAReachability *instance = nil;

@implementation BAReachability

+ (BAReachability *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BAReachability alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        ;
    }
    return self;
}

- (void)dealloc
{
    self.reach = nil;
}

- (void)startMonitor
{
    if (!self.reach) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        self.reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    }
    [self.reach startNotifier];
}

- (void)stopMonitor
{
    [self.reach stopNotifier];
}

- (void)addObserver:(id)target selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:selector
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)removeObserver:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability* reach = [note object];
    
    if([reach isReachable])
    {
        if ([reach isReachableViaWiFi]) {
            NSLog(@"WIFI");
        } else if ([reach isReachableViaWWAN]) {
            NSLog(@"2G/3G");
        } else {
            NSAssert(NO, @"%s", __FUNCTION__);
        }
    }
    else
    {
        NSLog(@"Notification Says Unreachable");
    }
}

- (NetworkStatus)networkStatus
{
    return [self.reach currentReachabilityStatus];
}

@end
