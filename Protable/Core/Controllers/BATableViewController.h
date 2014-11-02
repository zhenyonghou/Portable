//
//  BATableViewController.h
//  Demo
//
//  Created by houzhenyong on 14/11/2.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BAViewController.h"

@interface BATableViewController : BAViewController <UITableViewDataSource, UITableViewDelegate>{
@protected
    BOOL _hasToolBar;
}

@property (nonatomic, strong) UITableView *tableView;

@end
