//
//  BBSegmentViewController.m
//
//  Created by mumuhou on 15/7/14.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "BBSegmentViewController.h"

static NSInteger kNaviBarZoomOutHeight      = 20;
static NSInteger kSegmentControlHeight      = 40;

@interface BBSegmentViewController () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIViewController *currentController;

@property (nonatomic, assign) CGPoint lastContentOffset;

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
        segmentedControl.selectedSegmentIndex = 0;
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
//        const CGFloat kNaviBarHeight = 44;
//        const CGFloat kStatusBarHeight = 20;
        const CGFloat kTabBarHeight = 49;
//        CGFloat scrollViewHeight = self.view.bounds.size.height - kSegmentControlHeight - kTabBarHeight;
//        CGRect scrollFrame = CGRectMake(0, kSegmentControlHeight, [UIScreen mainScreen].bounds.size.width, scrollViewHeight);
//        CGFloat scrollViewHeight = [UIScreen mainScreen].bounds.size.height - kNaviBarHeight - kStatusBarHeight - kSegmentControlHeight - kTabBarHeight;

        CGFloat scrollViewOriginY = 64 + kSegmentControlHeight;
        CGFloat scrollViewHeight = [UIScreen mainScreen].bounds.size.height - scrollViewOriginY - kTabBarHeight;

        CGRect scrollFrame = CGRectMake(0,
                                        scrollViewOriginY,
                                        [UIScreen mainScreen].bounds.size.width,
                                        scrollViewHeight);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        scrollView.contentInset = UIEdgeInsetsZero;
        scrollView.backgroundColor = [UIColor orangeColor];
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"--------offset=%f, %d, %d", scrollView.contentOffset.x, scrollView.isDragging, scrollView.isDecelerating);
//    
//    if (scrollView.decelerating) {
//        if (self.lastContentOffset.x < scrollView.contentOffset.x) {
//            CGFloat pageWidth = scrollView.frame.size.width;
//            NSInteger page = scrollView.contentOffset.x / pageWidth + 1;
//            NSLog(@"page++  %d", page);
//        } else {
//            CGFloat pageWidth = scrollView.frame.size.width;
//            NSInteger page = scrollView.contentOffset.x / pageWidth;
//            NSLog(@"page-- %d", page);
//        }
//    }
//    self.lastContentOffset = scrollView.contentOffset;
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"%s", __func__);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    NSLog(@"%s", __func__);
////    CGFloat pageWidth = scrollView.frame.size.width;
////    NSInteger page = scrollView.contentOffset.x / pageWidth;
////    NSLog(@"offset=%f, page=%d", scrollView.contentOffset.x, page);
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"%s", __func__);
////    CGFloat pageWidth = scrollView.frame.size.width;
////    NSInteger page = scrollView.contentOffset.x / pageWidth;
////    NSLog(@"offset=%f, page=%d", scrollView.contentOffset.x, page);
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"%s", __func__);
////    CGFloat pageWidth = scrollView.frame.size.width;
////    NSInteger page = scrollView.contentOffset.x / pageWidth;
////    NSLog(@"offset=%f, page=%d", scrollView.contentOffset.x, page);
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.contentView]) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
//        NSLog(@"offset=%f, page=%d", scrollView.contentOffset.x, page);
        
        [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
        
        [self onSegmentedSelectedChanged:self.segmentedControl];
    }
}

@end
