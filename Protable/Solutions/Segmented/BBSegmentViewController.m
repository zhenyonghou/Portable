//
//  BBSegmentViewController.m
//
//  Created by mumuhou on 15/7/14.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "BBSegmentViewController.h"

//static NSInteger kNaviBarZoomOutHeight      = 20;
static NSInteger kSegmentControlHeight      = 40;

@interface BBSegmentViewController () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIViewController *currentController;

@property (nonatomic, assign) NSInteger lastPageIndex;

@property (nonatomic, assign) BOOL isScrollingReasonForDragging;

@end

@implementation BBSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)setPageTitles:(NSArray *)pageTitles controllers:(NSArray *)controllers
{
    [self setupSegmentedControlWithPageTitles:pageTitles];
    [self setupContentViewWithPageCount:[pageTitles count]];

    _pageControllers = controllers;
    
    [self setupChildViewControllers:controllers];
    
    [self.segmentedControl registerObserverForScrollView:self.contentView];
}

- (void)setTitleNormalAttributes:(NSDictionary *)normalAttributes titleSelectedAttributes:(NSDictionary *)selectedAttributes
{
    self.segmentedControl.titleTextAttributes = normalAttributes;
    self.segmentedControl.selectedTitleTextAttributes = selectedAttributes;
}

- (UIViewController *)currentController {
    return self.pageControllers[self.segmentedControl.selectedSegmentIndex];
}

#pragma mark- setup

- (void)setupSegmentedControlWithPageTitles:(NSArray *)pageTitles
{
    if (!self.segmentedControl) {
        BBSegmentedControl *segmentedControl = [[BBSegmentedControl alloc] initWithFrame:CGRectMake(0,
                                                                                                    64,
                                                                                                    [UIScreen mainScreen].bounds.size.width,
                                                                                                    kSegmentControlHeight)];
        segmentedControl.backgroundColor = [UIColor whiteColor];
        [segmentedControl addTarget:self action:@selector(onSegmentedSelectedChanged:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl setSelectedSegmentIndex:0 animated:NO notify:NO];
        segmentedControl.sectionTitles = pageTitles;
        self.segmentedControl = segmentedControl;

        [self.view addSubview:self.segmentedControl];

        __weak typeof(self) weakSelf = self;
        self.segmentedControl.indexChangeBlock = ^(NSInteger index) {

            CGRect scrollViewRect = CGRectMake(weakSelf.view.bounds.size.width * index,
                                               segmentedControl.bounds.origin.y,
                                               weakSelf.view.bounds.size.width,
                                               weakSelf.contentView.bounds.size.height);
            [weakSelf.contentView scrollRectToVisible:scrollViewRect animated:YES];
        };
    }
}

- (void)setupContentViewWithPageCount:(NSInteger)pageCount
{
    if (!self.contentView) {
        const CGFloat kTabBarHeight = 49;
        CGFloat scrollViewOriginY = 64 + kSegmentControlHeight;
        CGFloat scrollViewHeight = [UIScreen mainScreen].bounds.size.height - scrollViewOriginY - kTabBarHeight;

        CGRect scrollFrame = CGRectMake(0,
                                        scrollViewOriginY,
                                        [UIScreen mainScreen].bounds.size.width,
                                        scrollViewHeight);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        scrollView.contentInset = UIEdgeInsetsZero;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollEnabled = YES;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        self.contentView = scrollView;
        self.contentView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * pageCount, self.contentView.bounds.size.height);
        [self.view addSubview:self.contentView];
    }
}

- (void)setupChildViewControllers:(NSArray *)childControllers
{
    for (NSInteger k = 0; k < [childControllers count]; ++k) {
        UIViewController *vc = childControllers[k];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * k,
                                   0,
                                   [UIScreen mainScreen].bounds.size.width,
                                   self.contentView.bounds.size.height);
        vc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:vc.view];
    }
}

- (void)onSegmentedSelectedChanged:(BBSegmentedControl *)segmentedControl
{
    [self segmentedSelectedPageShown:segmentedControl.selectedSegmentIndex];
}

- (void)segmentedSelectedPageShown:(NSInteger)index
{
    for (int k = 0; k < [self.pageControllers count]; ++k) {
        id<BBSegmentSubViewControllerProtocol> obj = self.pageControllers[k];
        
        if ([obj respondsToSelector:@selector(segmentedPageShown:)]) {
            [obj segmentedPageShown:(k == index)];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.segmentedControl];
    [self segmentedSelectedPageShown:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"--------offset=%f, %d, %d", scrollView.contentOffset.x, scrollView.isDragging, scrollView.isDecelerating);

#ifndef BBSegmentedControlScrollStyle
    
    if (self.isScrollingReasonForDragging) {
        CGFloat pageWidth = scrollView.frame.size.width;
        CGFloat currentPage = scrollView.contentOffset.x / pageWidth;
        
        NSInteger nextPage = (NSInteger)currentPage;
        
        float onePageOffset = fmod(currentPage, 1);
        
        if (onePageOffset <= 0.5) {
            
        } else if (onePageOffset > 0.5) {
            nextPage ++;
        }
        
        if (self.lastPageIndex != nextPage) {
            // change page
            [self.segmentedControl setSelectedSegmentIndex:nextPage animated:YES notify:NO];
            
            self.lastPageIndex = nextPage;
        }
    }
#endif
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isScrollingReasonForDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.contentView]) {
        
#ifdef BBSegmentedControlScrollStyle
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [self.segmentedControl setSelectedSegmentIndex:page animated:YES notify:NO];
#else
        self.isScrollingReasonForDragging = NO;
        self.lastPageIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
#endif
        [self onSegmentedSelectedChanged:self.segmentedControl];
    }
}

@end
