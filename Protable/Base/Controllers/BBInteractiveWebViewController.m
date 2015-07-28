//
//  BBInteractiveWebViewController.m
//  Demo
//
//  Created by mumuhou on 15/7/28.
//  Copyright (c) 2015年 hou zhenyong. All rights reserved.
//

#import "BBInteractiveWebViewController.h"

@interface BBInteractiveWebViewController ()

@end

@implementation BBInteractiveWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    
    if ([url.scheme isEqualToString:@"mumuhou"]) {
        NSDictionary *parameters = [self parseParametersFromUrlQueryString:url.query];
        return [self javascriptResponsedWithHost:url.host parameters:parameters];
    }
    
    return YES;
}


- (NSDictionary *)parseParametersFromUrlQueryString:(NSString *)queryString
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    if (queryString.length > 0) {
        NSArray *keyAndValueArray = [queryString componentsSeparatedByString:@"&"];
        if (keyAndValueArray && keyAndValueArray.count > 0) {
            for (NSString *keyAndValue in keyAndValueArray) {
                NSArray *kv = [keyAndValue componentsSeparatedByString:@"="];
                if (kv.count == 2) {
                    NSString *key = kv[0];
                    NSString *value = kv[1];
                    if (value.length > 0) {
                        [retDic setObject:value forKey:key];
                    }
                }
            }
        }
    }
    return retDic;
}

- (BOOL)javascriptResponsedWithHost:(NSString *)host parameters:(NSDictionary *)parameters
{
    if ([host isEqualToString:@"search-category"]) {
        
    }
    return NO;
}

@end
