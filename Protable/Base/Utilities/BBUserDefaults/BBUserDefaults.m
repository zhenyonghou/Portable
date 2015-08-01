//
//  BBUserDefaults.m
//
//  Created by houzhenyong on 15/1/7.
//  Copyright (c) 2015年 houzhenyong. All rights reserved.
//

#import "BBUserDefaults.h"

NSString *const XCUserConfigPersistentReloadForChangedUserNotification = @"xc.UserPersistentReloadForChangedUserNotification";

@implementation BBUserDefaults

static BBUserDefaults *instance;

+ (BBUserDefaults *)sharedInstance {
    @synchronized (self){
        if (instance == nil){
            instance = [[BBUserDefaults alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self synchronize];
    _data = nil;
}

- (void)setUserId:(NSNumber*)userId
{
    if (!_userId || ![_userId isEqual:userId]) {
        _userId = userId;
        
        [self loadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XCUserConfigPersistentReloadForChangedUserNotification object:nil];
    }
}

- (id)objectForKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    return [_data objectForKey:defaultName];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data setObject:value forKey:defaultName];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data removeObjectForKey:defaultName];
}


- (NSString *)stringForKey:(NSString *)defaultName
{
    id obj = [self objectForKey:defaultName];
    
    if (![obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return obj;
}

- (NSArray *)arrayForKey:(NSString *)defaultName
{
    id obj = [self objectForKey:defaultName];
    
    if (![obj isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return obj;
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName
{
    id obj = [self objectForKey:defaultName];
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return obj;
}

- (NSData *)dataForKey:(NSString *)defaultName
{
    id obj = [self objectForKey:defaultName];
    
    if (![obj isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    return obj;
}

- (NSArray *)stringArrayForKey:(NSString *)defaultName
{
    id obj = [self objectForKey:defaultName];
    
    if (![obj isKindOfClass:[NSArray class]]) {
        return nil;
    }

    return obj;
}

- (NSInteger)integerForKey:(NSString *)defaultName
{
    NSNumber *obj = [self objectForKey:defaultName];
    return [obj integerValue];
}

- (float)floatForKey:(NSString *)defaultName
{
    NSNumber *obj = [self objectForKey:defaultName];
    return [obj floatValue];
}

- (double)doubleForKey:(NSString *)defaultName
{
    NSNumber *obj = [self objectForKey:defaultName];
    return [obj doubleValue];
}

- (BOOL)boolForKey:(NSString *)defaultName
{
    NSNumber *obj = [self objectForKey:defaultName];
    return [obj boolValue];
}

- (NSURL *)URLForKey:(NSString *)defaultName
{
    NSString *obj = [self stringForKey:defaultName];
    return [NSURL URLWithString:obj];
}


- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data setObject:@(value) forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data setObject:@(value) forKey:defaultName];
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data setObject:@(value) forKey:defaultName];
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data setObject:@(value) forKey:defaultName];
}

- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName
{
    NSAssert(_userId, @"%s", __func__);
    
    [_data setObject:url.absoluteString forKey:defaultName];
}


- (void)registerDefaults:(NSDictionary *)registrationDictionary
{
    NSAssert(_userId, @"%s", __func__);
    
    if ([_data count] == 0) {
        [self loadData];
    }
    
    if (registrationDictionary) {
        [registrationDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            __block BOOL find = NO;
            [_data enumerateKeysAndObjectsUsingBlock:^(id key2, id obj2, BOOL *stop2) {
                if ([key isEqualToString:key2]) {
                    find = YES;
                    *stop2 = YES;
                }
            }];
            
            if (!find) {
                [_data setObject:obj forKey:key];
            }
        }];
    }
}


- (BOOL)synchronize
{
    NSAssert(_userId, @"%s", __func__);
    
    return [_data writeToFile:[self persistentFilePath] atomically:YES];
}

#pragma mark- private methods

- (void)loadData
{
    [_data removeAllObjects];
    
    NSString *filePath = [self persistentFilePath];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
}

- (NSString*)persistentFilePath
{
    NSArray  *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    
    NSString *folder = [NSString stringWithFormat:@"%@", _userId];
    path = [path stringByAppendingPathComponent:folder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *err = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:YES attributes:nil error:&err])
        {
            NSLog(@"XCUserPersistent: Error creating Directory: %@", err);
        }
    }
    
    path = [path stringByAppendingPathComponent:@"UserConfig.plist"];
    
    return path;
}


@end
