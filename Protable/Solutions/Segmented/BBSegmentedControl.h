//
//  BBSegmentedControl.h
//  LxJSDemo
//
//  Created by mumuhou on 15/7/14.
//  Copyright (c) 2015年 The Third Rock Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

@interface BBSegmentedControl : UIControl

@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;


@property (nonatomic, strong) NSArray *sectionTitles;

@property (nonatomic, strong) UIColor *backgroundColor;


@property (nonatomic, assign) NSInteger selectedSegmentIndex;

@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

@property (nonatomic, strong) NSDictionary *titleTextAttributes;

@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes;

// bottom line
@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, strong) UIColor *bottomLineColor;

// selectionIndicator

@property (nonatomic, strong) UIColor *selectionIndicatorColor;

@property (nonatomic, assign) CGFloat selectionIndicatorHeight;



- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;

@end
