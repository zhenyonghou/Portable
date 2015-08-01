//
//  BBUserDefaults.h
//
//  Created by houzhenyong on 15/1/7.
//  Copyright (c) 2015年 houzhenyong. All rights reserved.
//  https://github.com/zhenyonghou/BBUserDefaults

/**
 * 使用苹果提供的NSUserDefaults类可方便的存取用户信息数据，然而，App往往支持多个用户间
 * 切换，当NSUserDefaults遇到多用户切换，解决起来就稍稍不那么完美。
 * BBUserDefaults解决了NSUserDefaults的这点不足,BBUserDefaults为每个用户在Document
 * 目录里建一个以UserId命名的目录，将用户信息文件以plist格式存放在该目录下。
 * 
 * BBUserDefaults与NSUserDefaults数据存取接口相似。
 * BBUserDefaults与NSUserDefaults的不同：
 * 1）去除了几个冗余接口
 * 2）增加了- (void)setUserId:(NSNumber*)userId接口
 */

#import <Foundation/Foundation.h>

@interface BBUserDefaults : NSObject {
    NSMutableDictionary *_data;
}

@property (nonatomic, strong, readonly) NSNumber *userId;

+ (BBUserDefaults *)sharedInstance;

- (void)setUserId:(NSNumber*)userId;

- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(id)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;

- (NSString *)stringForKey:(NSString *)defaultName;
- (NSArray *)arrayForKey:(NSString *)defaultName;
- (NSDictionary *)dictionaryForKey:(NSString *)defaultName;
- (NSData *)dataForKey:(NSString *)defaultName;
- (NSArray *)stringArrayForKey:(NSString *)defaultName;
- (NSInteger)integerForKey:(NSString *)defaultName;
- (float)floatForKey:(NSString *)defaultName;
- (double)doubleForKey:(NSString *)defaultName;
- (BOOL)boolForKey:(NSString *)defaultName;
- (NSURL *)URLForKey:(NSString *)defaultName;

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (void)setFloat:(float)value forKey:(NSString *)defaultName;
- (void)setDouble:(double)value forKey:(NSString *)defaultName;
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName;

- (void)registerDefaults:(NSDictionary *)registrationDictionary;

- (BOOL)synchronize;

@end


extern NSString *const XCUserConfigPersistentReloadForChangedUserNotification;
