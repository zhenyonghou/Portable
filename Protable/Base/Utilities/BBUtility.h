//
//  BAUtility.h
//  Adult
//
//  Created by houzhenyong on 14-8-6.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

static inline double degreesToRadians(double degrees) {return degrees * M_PI / 180;}

static inline double radiansToDegrees(double radians) {return radians * 180/M_PI;}

@interface BBUtility : NSObject

+ (CTFontRef)ctFontRefFromUIFont:(UIFont *)font;

+ (void)printRect:(CGRect)rect mark:(NSString*)mark;

@end
