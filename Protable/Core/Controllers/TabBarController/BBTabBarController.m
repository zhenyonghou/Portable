//
//  BBTabBarController.m
//
//  Created by zhenyonghou on 15/6/27.
//  Copyright © 2015年 zhenyonghou. All rights reserved.
//

#import "BBTabBarController.h"

@interface BBTabBarController ()

@property (nonatomic, strong) NSMutableArray<BBTabBarItem *> *bb_itemButtons;

@end

@implementation BBTabBarController

- (id)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"selectedViewController" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedViewController"];
}

- (void)bb_setBarItems:(NSArray <BBTabBarItem *> *)items
{
    if (self.bb_itemButtons) {
        for (UIButton *item in self.bb_itemButtons) {
            [item removeFromSuperview];
        }
        [self.bb_itemButtons removeAllObjects];
    } else {
        self.bb_itemButtons = [[NSMutableArray alloc] initWithCapacity:items.count];
    }
    
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width / items.count;
    
    NSInteger k = 0;
    for (BBTabBarItem *itemView in items) {
        itemView.frame = CGRectMake(0, 0, itemWidth, self.tabBar.bounds.size.height);
        
        itemView.center = CGPointMake(k * itemWidth + itemWidth / 2, self.tabBar.bounds.size.height / 2);
        [self.tabBar addSubview:itemView];
        [self.bb_itemButtons addObject:itemView];
        ++k;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bb_setSelectIndex:self.selectedIndex];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"selectedViewController"]) {
        NSUInteger index = [self.viewControllers indexOfObject:self.selectedViewController];
        
        [self bb_setSelectIndex:index];
    }
}

- (void)bb_setSelectIndex:(NSInteger)index
{
    NSUInteger k = 0;
    for (BBTabBarItem *item in self.bb_itemButtons) {
        item.selected = (index == k);
        ++k;
    }
}

@end
