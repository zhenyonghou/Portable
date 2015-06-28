//
//  BAWebViewController.h
//  Read
//
//  Created by houzhenyong on 14/11/4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BBViewController.h"

@interface BAWebViewController : BBViewController <UIWebViewDelegate>

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithURL:(NSURL *)URL;

- (NSURL *)URL;

- (void)openURL:(NSURL*)URL;
- (void)openRequest:(NSURLRequest*)request;
- (void)openHTMLString:(NSString*)htmlString baseURL:(NSURL*)baseUrl;

@property (nonatomic, readwrite, assign, getter = isToolbarHidden) BOOL toolbarHidden;

@property (nonatomic, readonly, strong) UIWebView* webView;


@end
