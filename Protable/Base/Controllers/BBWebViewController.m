//
//  BAWebViewController.m
//  Read
//
//  Created by houzhenyong on 14/11/4.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "BBWebViewController.h"

@interface BBWebViewController ()

@property (nonatomic, readwrite, strong) UIWebView* webView;

@property (nonatomic, readwrite, strong) NSURL* loadingURL;

@property (nonatomic, readwrite, strong) NSURLRequest* loadRequest;

@property (nonatomic, readwrite, strong) UIToolbar* toolbar;
@property (nonatomic, readwrite, strong) UIBarButtonItem* backButton;
@property (nonatomic, readwrite, strong) UIBarButtonItem* forwardButton;
@property (nonatomic, readwrite, strong) UIBarButtonItem* refreshButton;
@property (nonatomic, readwrite, strong) UIBarButtonItem* stopButton;
@property (nonatomic, readwrite, strong) UIBarButtonItem* actionButton;
@property (nonatomic, readwrite, strong) UIBarButtonItem* activityItem;

@end

@implementation BBWebViewController

- (id)initWithRequest:(NSURLRequest *)request {
    if ((self = [super init])) {
        self.hidesBottomBarWhenPushed = YES;
        [self openRequest:request];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithURL:(NSURL *)URL {
    return [self initWithRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)didTapBackButton {
    [self.webView goBack];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didTapForwardButton {
    [self.webView goForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didTapRefreshButton {
    [self.webView reload];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didTapStopButton {
    [self.webView stopLoading];
}

#pragma mark - Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURL *)URL {
    return self.loadingURL ? self.loadingURL : self.webView.request.mainDocumentURL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openRequest:(NSURLRequest *)request {
    self.loadRequest = request;
    
    if ([self isViewLoaded]) {
        if (nil != request) {
            [self.webView loadRequest:request];
            
        } else {
            [self.webView stopLoading];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openHTMLString:(NSString*)htmlString baseURL:(NSURL*)baseUrl {
    NSParameterAssert([self isViewLoaded]);
    [_webView loadHTMLString:htmlString baseURL:baseUrl];
}

//- (void)updateWebViewFrame {
//    if (self.toolbarHidden) {
//        self.webView.frame = self.view.bounds;
//        
//    } else {
//        self.webView.frame = NIRectContract(self.view.bounds, 0, self.toolbar.frame.size.height);
//    }
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setToolbarHidden:(BOOL)hidden {
    _toolbarHidden = hidden;
    if ([self isViewLoaded]) {
        self.toolbar.hidden = hidden;
//        [self updateWebViewFrame];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    if (nil != self.loadRequest) {
        [self.webView loadRequest:self.loadRequest];
    }
    
//    [self buildToolbar];
    
    self.backButton =
    [[UIBarButtonItem alloc] initWithImage:SKIN_IMAGE(@"backIcon")
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didTapBackButton)];
    self.backButton.tag = 2;
    self.backButton.enabled = NO;
    
    UIImage* forwardIcon = SKIN_IMAGE(@"forwardIcon");
    // We weren't able to find the forward or back icons in your application's resources.
    // Ensure that you've dragged the NimbusWebController.bundle from src/webcontroller/resources
    // into your application with the "Create Folder References" option selected. You can verify that
    // you've done this correctly by expanding the NimbusPhotos.bundle file in your project
    // and verifying that the 'gfx' directory is blue. Also verify that the bundle is being
    // copied in the Copy Bundle Resources phase.
    NSParameterAssert(nil != forwardIcon);
    
    self.forwardButton =
    [[UIBarButtonItem alloc] initWithImage:forwardIcon
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didTapForwardButton)];
    self.forwardButton.tag = 1;
    self.forwardButton.enabled = NO;
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                          UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefreshButton)];
    self.refreshButton.tag = 3;
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                       UIBarButtonSystemItemStop target:self action:@selector(didTapStopButton)];
    self.stopButton.tag = 3;
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                         UIBarButtonSystemItemAction target:self action:@selector(didTapShareButton)];
    
    UIBarItem* flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                  target: nil
                                                  action: nil];
    
    self.toolbar.items = [NSArray arrayWithObjects:
                          self.backButton,
                          flexibleSpace,
                          self.forwardButton,
                          flexibleSpace,
                          self.refreshButton,
                          flexibleSpace,
                          self.actionButton,
                          nil];
    [self.view addSubview:self.toolbar];
}

- (void)buildToolbar
{
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.mm_height - PHONE_TOOLBAR_HEIGHT, SCREEN_WIDTH, PHONE_TOOLBAR_HEIGHT)];
    self.toolbar.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                     | UIViewAutoresizingFlexibleWidth);
    self.toolbar.tintColor = [UIColor redColor];
    self.toolbar.hidden = self.toolbarHidden;
    
    [self.view addSubview:self.toolbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    self.loadingURL = [request.mainDocumentURL copy];
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView*)webView {
    self.title = NSLocalizedString(@"Loading...", @"");
    if (!self.navigationItem.rightBarButtonItem) {
        [self.navigationItem setRightBarButtonItem:self.activityItem animated:YES];
    }
    
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.toolbar.items) {
        if (button.tag == 3) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.toolbar.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:self.stopButton];
            self.toolbar.items = newItems;
            break;
        }
        ++buttonIndex;
    }
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    self.loadingURL = nil;
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.navigationItem.rightBarButtonItem == self.activityItem) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.toolbar.items) {
        if (button.tag == 3) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.toolbar.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:self.refreshButton];
            self.toolbar.items = newItems;
            break;
        }
        ++buttonIndex;
    }
    
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    self.loadingURL = nil;
    [self webViewDidFinishLoad:webView];
}

@end
