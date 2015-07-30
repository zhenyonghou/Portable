//
//  BBAppVersionChecker.h
//  Demo
//
//  Created by mumuhou on 15/7/30.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAppVersionChecker : NSObject

/**
 * 从服务器请求最新的版本信息
 */
+ (void)requestNewVersionWithSuccessBlock:(void(^)(BOOL hasNewVersion, NSString *version, NSString *detail, NSString *link))successBlock
                             failureBlock:(void (^)(NSString *errorMsg))failureBlock;

/**
 *  从本地缓存中加载版本信息，本地缓存的数据是之前由服务器返回的
 */
+ (void)loadFromLocalWithCompleteBlock:(void (^)(NSString *version, NSString *detail, NSString *link))completeBlock;

/**
 * 与本地缓存的版本进行比较
 */
+ (BOOL)hasNewerVersion;


@end
