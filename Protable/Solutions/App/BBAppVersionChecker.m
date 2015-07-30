//
//  BBAppVersionChecker.m
//  Demo
//
//  Created by mumuhou on 15/7/30.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "BBAppVersionChecker.h"

static NSString * const kServerVersionDataKey = @"kNewVersionResponsedData";

@implementation BBAppVersionChecker

+ (void)requestNewVersionWithSuccessBlock:(void(^)(BOOL hasNewVersion, NSString *version, NSString *detail, NSString *link))successBlock
                             failureBlock:(void (^)(NSString *errorMsg))failureBlock
{
    // 从服务器请求APP的最新版本信息
}

+ (void)loadFromLocalWithCompleteBlock:(void (^)(NSString *version, NSString *detail, NSString *link))completeBlock
{
    NSDictionary *versionData = [[NSUserDefaults standardUserDefaults] objectForKey:kServerVersionDataKey];
    NSString *version = [versionData objectForKey:@"ver"];
    NSString *detail = [versionData objectForKey:@"detail"];
    NSString *link = [versionData objectForKey:@"link"];
    completeBlock(version, detail, link);
}

+ (BOOL)hasNewerVersion
{
    __block BOOL ret;
    [[self class] loadFromLocalWithCompleteBlock:^(NSString *version, NSString *detail, NSString *link) {
        if (version) {
            NSComparisonResult result = [[self class] compareVersionA:[BBApplication applicationVersion] versionB:version];
            ret = (result == NSOrderedAscending);
        } else {
            ret = NO;
        }
    }];
    return ret;
}

+ (NSComparisonResult)compareVersionA:(NSString *)versionA versionB:(NSString *)versionB
{
    return [versionA compare:versionB options:NSNumericSearch];
}

@end
