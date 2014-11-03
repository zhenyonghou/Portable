//
//  BAUtility.h
//  Adult
//
//  Created by houzhenyong on 14-8-6.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

static float degreesToRadians(float degrees) {return degrees * M_PI / 180;}

static float radiansToDegrees(float radians) {return radians * 180/M_PI;}

@interface BAUtility : NSObject

+ (void)printRect:(CGRect)rect mark:(NSString*)mark;

@end
