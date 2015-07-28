//
//  BAWebViewController.h
//  Read
//
//  Created by houzhenyong on 14/11/4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BBViewController.h"

@interface BBWebViewController : BBViewController <UIWebViewDelegate>

- (void)loadUrl:(NSString *)url;

- (void)loadHTMLString:(NSString*)htmlString baseURL:(NSURL*)baseUrl;


@end