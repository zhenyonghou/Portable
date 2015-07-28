//
//  NSDate+NSDate+BAAdditions.h
//  shuidi2
//
//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Protable)

- (NSDateComponents *)componentsOfDay;

- (NSUInteger)year;

- (NSUInteger)month;

- (NSUInteger)day;

- (NSUInteger)hour;

- (NSUInteger)minute;

- (NSUInteger)second;

// 获得NSDate对应的星期 (1: 周日, 2: 周一, ...)
- (NSUInteger)weekday;

- (NSString*)weekdayName;

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day;

// 返回两个日期间的时间元素组件
+ (NSDateComponents*)fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate;

- (NSInteger)daysFromDate:(NSDate*)startDate;

- (NSInteger)daysToDate:(NSDate*)endDate;

// 前一天
- (NSDate *)previousDay;

// 下一天
- (NSDate *)followingDay;

// 判断与某一天是否为同一天
- (BOOL)sameDayWithDate:(NSDate *)otherDate;

// 判断与某一天是否为同一周
- (BOOL)sameWeekWithDate:(NSDate *)otherDate;

// 判断与某一天是否为同一月
- (BOOL)sameMonthWithDate:(NSDate *)otherDate;

@end
