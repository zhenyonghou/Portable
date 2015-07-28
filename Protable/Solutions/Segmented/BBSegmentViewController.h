//
//  BBSegmentViewController.h
//
//  Created by mumuhou on 15/7/14.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSegmentedControl.h"

@protocol BBSegmentSubViewControllerProtocol <NSObject>

- (void)segmentedPageShown:(BOOL)shown;

@end

@interface BBSegmentViewController : UIViewController

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) BBSegmentedControl *segmentedControl;

@property (nonatomic, strong, readonly) NSArray *pageControllers;

@property (nonatomic, strong, readonly) UIViewController *currentController;


- (void)setPageTitles:(NSArray *)pageTitles controllers:(NSArray *)controllers;

- (void)setTitleNormalAttributes:(NSDictionary *)normalAttributes titleSelectedAttributes:(NSDictionary *)selectedAttributes;

- (void)segmentedSelectedPageShown:(NSInteger)index;

- (void)onSegmentedSelectedChanged:(BBSegmentedControl *)segmentedControl;

@end
