//
//  PTOverlayView.h
//  lxOverlayView
//
//  Created by hou zhenyong on 13-11-19.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOverlayImageHeight 125
#define kOverlayTextHeight 57
#define kIndicatorWidth 30.0

//提示状态机
typedef NS_ENUM(NSInteger, BAOverlayStatus) {
    kOverlayStatusRemove = 1,           //无提示
    kOverlayStatusLoading,              //加载中
    kOverlayStatusEmpty,                //数据空
    kOverlayStatusError,                //网络错误
//    kOverlayStatusForbit,             //无权限
};

@interface BAOverlayView : UIView{
}

// 适配
- (void)suitForStatus:(BAOverlayStatus)status;

@property (nonatomic, assign) BAOverlayStatus status;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *loadingText;
@property (nonatomic, copy) NSString *emptyText;
@property (nonatomic, copy) NSString *errorText;
@property (nonatomic, copy) NSString *forbitText;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
//@property (nonatomic, assign) BOOL supportSkin;
@property (nonatomic, assign) BOOL animate;

@end
