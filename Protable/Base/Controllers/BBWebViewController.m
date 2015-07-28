//
//  BAWebViewController.m
//  Read
//
//  Created by houzhenyong on 14/11/4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BBWebViewController.h"

@interface BBWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

//@property (nonatomic, strong) UIBarButtonItem *activityItem;

@end

@implementation BBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

//    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    self.activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)loadUrl:(NSString *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString*)htmlString baseURL:(NSURL*)baseUrl {
    [self.webView loadHTMLString:htmlString baseURL:baseUrl];
}

#pragma mark- UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

@end
