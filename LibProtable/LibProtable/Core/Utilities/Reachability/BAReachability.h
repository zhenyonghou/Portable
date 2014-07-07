//
//  SFReachability.h
//  lxReachability
//
//  Created by hou zhenyong on 14-1-7.
//  Copyright (c) 2014年 sfbest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface BAReachability : NSObject

+ (BAReachability *)sharedInstance;

- (void)startMonitor;
- (void)stopMonitor;
- (void)addObserver:(id)target selector:(SEL)selector;
- (void)removeObserver:(id)target;

- (NetworkStatus)networkStatus;

@property (strong, nonatomic) Reachability *reach;

@end
