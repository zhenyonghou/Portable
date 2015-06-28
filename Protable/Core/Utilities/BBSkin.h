//
//  BBSkin.h
//  Demo
//
//  Created by zhenyonghou on 15/6/28.
//  Copyright © 2015年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSkinResourceManager : NSObject

- (id)dataForKey:(NSString *)key;

@end



@interface BBSkin : NSObject

+ (instancetype)sharedInstance;

- (UIImage *)imageForKey:(NSString*)key;

- (UIColor *)colorForKey:(NSString *)key;

- (UIFont *)fontForKey:(NSString *)key;


@end

#define SKIN_IMAGE(key)      [[BBSkin sharedInstance] imageForKey:(key)]
#define SKIN_COLOR(key)      [[BBSkin sharedInstance] colorForKey:(key)]
#define SKIN_FONT(key)       [[BBSkin sharedInstance] fontForKey:(key)]

