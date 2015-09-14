//
//  HGDeviceID.m
//
//  Created by mumuhou on 15/9/14.
//  Copyright (c) 2015年 mumuhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "BBDeviceID.h"

@implementation BBDeviceID {
    NSString *_deviceIdKey;
}

+ (NSString *)uniqueId
{
    return [[[BBDeviceID alloc] initWithKey:@"MMUDeviceID"] deviceId];
}

#pragma mark- inner methods

- (id)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        _deviceIdKey = key;
    }
    return self;
}

- (NSString *)deviceId
{
    NSString *deviceId;
    BOOL needSave = NO;
    
    deviceId = [[self class] valueForKeychainKey:_deviceIdKey service:_deviceIdKey];
    if (!deviceId) {
        deviceId = [[self class] valueForUserDefaultsKey:_deviceIdKey];
        needSave = YES;
    }
    
    if (!deviceId) {
        deviceId = [[self class] IDFA];
    }
    
    if (!deviceId) {
        deviceId = [[self class] randomUUID];
    }

    if (needSave) {
        [self saveDeviceId:deviceId];
    }
    return deviceId;
}

- (void)saveDeviceId:(NSString *)deviceId
{
    if (![[self class] valueForUserDefaultsKey:_deviceIdKey]) {
        [[self class] setValue:deviceId forUserDefaultsKey:_deviceIdKey];
    }
    if (![[self class] valueForKeychainKey:_deviceIdKey service:_deviceIdKey]) {
        [[self class] setValue:deviceId forKeychainKey:_deviceIdKey inService:_deviceIdKey];
    }
}

#pragma mark- keychain methods

+ (NSMutableDictionary *)keychainItemForKey:(NSString *)key service:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    return keychainItem;
}

+ (OSStatus)setValue:(NSString *)value forKeychainKey:(NSString *)key inService:(NSString *)service {
    NSMutableDictionary *keychainItem = [[self class] keychainItemForKey:key service:service];
    keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    return SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
}

+ (NSString *)valueForKeychainKey:(NSString *)key service:(NSString *)service {
    OSStatus status;
    NSMutableDictionary *keychainItem = [[self class] keychainItemForKey:key service:service];
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    CFDictionaryRef result = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    if (status != noErr) {
        return nil;
    }
    NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
    NSData *data = resultDict[(__bridge id)kSecValueData];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - NSUserDefaults methods

+ (BOOL)setValue:(NSString *)value forUserDefaultsKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)valueForUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark-

+ (NSString *)IDFV {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)IDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)randomUUID {
    return [[NSUUID UUID] UUIDString];;
}

@end
