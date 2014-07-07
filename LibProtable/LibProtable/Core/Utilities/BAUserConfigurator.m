//
//  BAUserConfigurator.m
//  PregnancyTracking
//
//  Created by hou zhenyong on 13-10-10.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import "BAUserConfigurator.h"

static NSString* const kCurrentSkinName         = @"ba.currentSkinName";
static NSString* const kServerVersion           = @"ba.serverVersion";

@implementation BAUserConfigurator

static BAUserConfigurator* _instance = nil;

+ (BAUserConfigurator*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BAUserConfigurator alloc] init];
    });

    return _instance;
}

- (NSString*)currentSkinName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentSkinName];
}

- (void)setCurrentSkinName:(NSString *)currentSkinName
{
    [[NSUserDefaults standardUserDefaults] setObject:currentSkinName forKey:kCurrentSkinName];
}

- (NSString*)serverVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kServerVersion];
}

- (void)setServerVersion:(NSString *)serverVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:serverVersion forKey:kServerVersion];
}

@end
