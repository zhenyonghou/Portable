//
//  BBDeviceID.m
//  Demo
//
//  Created by mumuhou on 15/8/8.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "BBDeviceID.h"

@interface BBDeviceID ()

@property(nonatomic, strong, readonly) NSString *uidKey;
@property(nonatomic, strong, readonly) NSString *uid;

@end


@implementation BBDeviceID

@synthesize uid = _uid;

+ (NSString *)uniqueId {
    return [[[BBDeviceID alloc] initWithKey:@"deviceUID"] uniqueId];
}

- (id)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        _uidKey = key;
        _uid = nil;
    }
    return self;
}

/*! Returns the Device UID.
 The UID is obtained in a chain of fallbacks:
 - Keychain
 - NSUserDefaults
 - Apple IFV (Identifier for Vendor)
 - Generate a random UUID if everything else is unavailable
 At last, the UID is persisted if needed to.
 */
- (NSString *)uniqueId {
    if (!_uid) _uid = [[self class] valueForKeychainKey:_uidKey service:_uidKey];
    if (!_uid) _uid = [[self class] valueForUserDefaultsKey:_uidKey];
    if (!_uid) _uid = [[self class] appleIFV];
    if (!_uid) _uid = [[self class] randomUUID];
    [self save];
    return _uid;
}

/*! Persist UID to NSUserDefaults and Keychain, if not yet saved
 */
- (void)save {
    if (![BBDeviceID valueForUserDefaultsKey:_uidKey]) {
        [BBDeviceID setValue:_uid forUserDefaultsKey:_uidKey];
    }
    if (![BBDeviceID valueForKeychainKey:_uidKey service:_uidKey]) {
        [BBDeviceID setValue:_uid forKeychainKey:_uidKey inService:_uidKey];
    }
}

#pragma mark - Keychain methods

/*! Create as generic NSDictionary to be used to query and update Keychain items.
 *  param1
 *  param2
 */
+ (NSMutableDictionary *)keychainItemForKey:(NSString *)key service:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    return keychainItem;
}

/*! Sets
 *  param1
 *  param2
 */
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

#pragma mark - UID Generation methods
//
//+ (NSString *)appleIFA {
//    NSString *ifa = nil;
//    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
//    if (ASIdentifierManagerClass) { // a dynamic way of checking if AdSupport.framework is available
//        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
//        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
//        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
//        NSUUID *advertisingIdentifier = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
//        ifa = [advertisingIdentifier UUIDString];
//    }
//    return ifa;
//}

+ (NSString *)appleIFV {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)randomUUID {
    return [[NSUUID UUID] UUIDString];;
}

@end
