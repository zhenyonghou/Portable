//
//  DETableViewController.m
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "DEBaseExamplesViewController.h"
#import "DEBaseFirstViewController.h"
#import "DEBaseSecondViewController.h"
#import "DEBaseThirdViewController.h"
#import "DEBaseForthViewController.h"
#import "DEBaseFifthViewController.h"

@interface DEBaseExamplesViewController ()

@property (nonatomic, strong) DEBaseFirstViewController *firstViewController;
@property (nonatomic, strong) DEBaseSecondViewController *secondViewController;
@property (nonatomic, strong) DEBaseThirdViewController *thirdViewController;
@property (nonatomic, strong) DEBaseForthViewController *forthViewController;
@property (nonatomic, strong) DEBaseFifthViewController *fifthViewController;

@end

@implementation DEBaseExamplesViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviTitle:@"Base"];
    self.view.backgroundColor = [UIColor colorWithHex:0xf0f0f0];

    self.firstViewController = [[DEBaseFirstViewController alloc] init];
//    self.firstViewController.delegate = self;
    self.secondViewController = [[DEBaseSecondViewController alloc] init];
//    self.serviceViewController.delegate = self;
    self.thirdViewController = [[DEBaseThirdViewController alloc] init];
//    self.housingViewController.delegate = self;
    self.forthViewController = [[DEBaseForthViewController alloc] init];
//    self.jobsViewController.delegate = self;
    self.fifthViewController = [[DEBaseFifthViewController alloc] init];
//    self.followingViewController.delegate = self;
    
    NSArray *pageTitles = @[@"Demo第1页", @"Demo第2页", @"第3页", @"第4页", @"第5页"];
    
    NSArray *pageControllers = @[self.firstViewController,
                                 self.secondViewController,
                                 self.thirdViewController,
                                 self.forthViewController,
                                 self.fifthViewController];
    
    [self setPageTitles:pageTitles controllers:pageControllers];
    
    // customize segmented control
    CTFontRef normalFont = [BBUtility ctFontRefFromUIFont:[UIFont systemFontOfSize:14]];
    CGColorRef normalColor = [UIColor blackColor].CGColor;
    CGColorRef selectedColor = [UIColor colorWithHex:0xff8830].CGColor;//FANCY_COLOR(@"ff8830").CGColor;
    CTFontRef selectedFont = [BBUtility ctFontRefFromUIFont:[UIFont systemFontOfSize:14]];
    
    NSDictionary *normalAttributes = @{NSFontAttributeName : (__bridge id)normalFont, NSForegroundColorAttributeName : (__bridge id)normalColor};
    NSDictionary *selectedAttributes = @{NSFontAttributeName : (__bridge id)selectedFont, NSForegroundColorAttributeName : (__bridge id)selectedColor};
    [self setTitleNormalAttributes:normalAttributes titleSelectedAttributes:selectedAttributes];
    
    self.segmentedControl.bottomLineColor = [UIColor lightGrayColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0xff8830];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


@end
