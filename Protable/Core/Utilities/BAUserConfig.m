//
//  BAUserConfig.m
//  PregnancyTracking
//
//  Created by hou zhenyong on 13-10-10.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import "BAUserConfig.h"

static NSString* const kCurrentSkinName                 = @"ba.currentSkinName";
static NSString* const kServerVersion                   = @"ba.serverVersion";
static NSString* const kDeviceToken                     = @"ba.deviceToken";
static NSString* const kLastUpdateTipForNewVersion      = @"ba.lastUpdateNewVersionTip";
static NSString* const kLastVersionForPraise            = @"ba.lastVersionForPraise";
static NSString* const kIntroVersion                    = @"ba.introVersion";

@implementation BAUserConfig

static BAUserConfig* _instance = nil;

+ (BAUserConfig*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BAUserConfig alloc] init];
    });

    return _instance;
}

- (void)registerDefaults
{
    NSDictionary *defaultDic = @{kCurrentSkinName : @("skin_basic")};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultDic];
}

- (void)saveImmediately
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)currentSkinName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentSkinName];
}

- (void)setCurrentSkinName:(NSString *)currentSkinName
{
    [[NSUserDefaults standardUserDefaults] setObject:currentSkinName forKey:kCurrentSkinName];
    [self saveImmediately];
}

- (NSString*)serverVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kServerVersion];
}

- (void)setServerVersion:(NSString *)serverVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:serverVersion forKey:kServerVersion];
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:kDeviceToken];
}

- (NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
}

- (NSDictionary*)lastUpdateTipForNewVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateTipForNewVersion];
}

- (void)setLastUpdateTipForNewVersion:(NSDictionary *)lastUpdateTipForNewVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTipForNewVersion forKey:kLastUpdateTipForNewVersion];
}

- (NSString*)introVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kIntroVersion];
}

- (void)setIntroVersion:(NSString *)introVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:introVersion forKey:kIntroVersion];
}

- (NSDictionary*)lastVersionForPraise
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastVersionForPraise];
}

- (void)setLastVersionForPraise:(NSDictionary *)lastVersionForPraise
{
    [[NSUserDefaults standardUserDefaults] setObject:lastVersionForPraise forKey:kLastVersionForPraise];
}

@end
