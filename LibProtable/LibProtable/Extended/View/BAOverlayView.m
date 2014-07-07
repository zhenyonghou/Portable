//
//  PTOverlayView.m
//  lxOverlayView
//
//  Created by hou zhenyong on 13-11-19.
//  Copyright (c) 2013年 hou zhenyong. All rights reserved.
//

#import "BAOverlayView.h"

@implementation BAOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _loadingText = NSLocalizedString(@"努力加载中...", @"努力加载中...");
        _emptyText = NSLocalizedString(@"暂无内容", @"暂无内容");
        _errorText = NSLocalizedString(@"网络不给力，请稍后再试", @"网络不给力，请稍后再试");

        _animate = YES;
        _status = kOverlayStatusRemove;

        self.alpha = 0;
        self.userInteractionEnabled = NO;
    }
    return self;
}

// 适配
- (void)suitForStatus:(BAOverlayStatus)status {
    self.status = status;
    
    if (status == kOverlayStatusLoading) {
        [self.indicatorView startAnimating];
    }
    else {
        if ([self.indicatorView isAnimating]) {
            [self.indicatorView stopAnimating];
        }
    }
    
    switch (status) {
        case kOverlayStatusLoading:
            [self resetImgWithName:nil];
            [self.indicatorView startAnimating];
            self.label.text = _loadingText;
            break;

        case kOverlayStatusEmpty:
            self.label.text = _emptyText;
            [self resetImgWithName:@"overlay_error"];
            break;
            
        case kOverlayStatusError:
            self.label.text = _errorText;
            [self resetImgWithName:@"overlay_error"];
            break;
            
//        case kOverlayStatusForbit:
//            self.label.text = _forbitText;
//            [self resetImgWithName:@"overlay_forbit"];
//            break;
            
        case kOverlayStatusRemove:
            self.label.text = nil;
            [self resetImgWithName:nil];
            break;

        default:
            break;
    }
}

//// 换肤
//- (void)changeSkinAction {
//    setLabelFontAndColor(self.label, @"73ListEmptyLabel");
//    SkinType sType = [RCResManager getInstance].skinType;
//    if (sType == SkinType_Light) {
//        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    }else if (sType == SkinType_Night) {
//        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    }else {
//        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    }
//}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, kOverlayImageHeight);
        _imgView = [[UIImageView alloc] initWithFrame:newFrame];
        [self addSubview:_imgView];
    }
    
    return _imgView;
}

- (UILabel *)label {
    if (_label == nil) {
        CGRect newFrame = CGRectMake(25, kOverlayImageHeight, self.frame.size.width - 50, kOverlayTextHeight);
        _label = [[UILabel alloc] initWithFrame:newFrame];
        _label.numberOfLines = 0;
        [self addSubview:_label];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor whiteColor];
//        setLabelFontAndColor(_label, @"73ListEmptyLabel");
    }
    
    return _label;
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        //CGFloat indicatorWidth = 30;
        CGRect newFrame = CGRectMake((self.frame.size.width - kIndicatorWidth) / 2,
                                     kOverlayImageHeight - kIndicatorWidth,
                                     kIndicatorWidth,
                                     kIndicatorWidth);
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:newFrame];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        SkinType sType = [RCResManager getInstance].skinType;
//        if (sType == SkinType_Light) {
//            _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        }else if (sType == SkinType_Night) {
//            _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//        }else {
//            _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//        }
        
        [self addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

// 重置图片
- (void)resetImgWithName:(NSString *)name {
//    [self.imgView setImage:[[BAResourceManager sharedInstance] imageForKey:name]];
}

@end
