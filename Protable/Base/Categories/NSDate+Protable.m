//
//  NSDate+BAAdditions.m
//
//  Created by houzhenyong on 14-3-8.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "NSDate+Protable.h"

@implementation NSDate (Protable)

- (NSDateComponents *)componentsOfDay
{
    static NSDateComponents *dateComponents = nil;
    static NSDate *previousDate = nil;
    
    if (!previousDate || ![previousDate isEqualToDate:self]) {
        previousDate = self;
        dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    }
    
    return dateComponents;
}

- (NSUInteger)year
{
    return [self componentsOfDay].year;
}

- (NSUInteger)month
{
    return [self componentsOfDay].month;
}

- (NSUInteger)day
{
    return [self componentsOfDay].day;
}

- (NSUInteger)hour
{
    return [self componentsOfDay].hour;
}

- (NSUInteger)minute
{
    return [self componentsOfDay].minute;
}

- (NSUInteger)second
{
    return [self componentsOfDay].second;
}

- (NSUInteger)weekday
{
    return [self componentsOfDay].weekday;
}

- (NSString*)weekdayName
{
    NSArray* weekdayArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    return weekdayArray[[self weekday] - 1];
}
//
//- (NSUInteger)week
//{
//    return [self componentsOfDay].week;
//}

// 返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return dateAfterDay;
}

// 返回两个日期间的时间元素组件
+ (NSDateComponents*)fromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
    return comps;
}

// 返回两个日期间的天数
+ (NSInteger)daysFromStartDate:(NSDate*)startDate toEndDate:(NSDate*)endDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSDayCalendarUnit fromDate:startDate  toDate:endDate  options:0];
    return [comps day];
}

- (NSInteger)daysFromDate:(NSDate*)startDate
{
    return [[self class] daysFromStartDate:startDate toEndDate:self];
}

- (NSInteger)daysToDate:(NSDate*)endDate
{
    return [[self class] daysFromStartDate:self toEndDate:endDate];
}

// 前一天
- (NSDate *)previousDay
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

// 下一天
- (NSDate *)followingDay
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

// 判断与某一天是否为同一天
- (BOOL)sameDayWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day) {
        return YES;
    } else {
        return NO;
    }
}

// 判断与某一天是否为同一周
- (BOOL)sameWeekWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear) {
        return YES;
    } else {
        return NO;
    }
}

// 判断与某一天是否为同一月
- (BOOL)sameMonthWithDate:(NSDate *)otherDate
{
    if (self.year == otherDate.year && self.month == otherDate.month) {
        return YES;
    } else {
        return NO;
    }
}

// 获取当天是当月的第几周
- (NSUInteger)weekOfDayInMonth
{
    NSDate *firstDayOfTheMonth = [self firstDayOfTheMonth];
    NSUInteger weekdayOfFirstDayOfTheMonth = [firstDayOfTheMonth componentsOfDay].weekday;
    NSUInteger day = [self componentsOfDay].day;
    
    return ((day + weekdayOfFirstDayOfTheMonth - 1)%7) ? ((day + weekdayOfFirstDayOfTheMonth - 1)/7) + 1: ((day + weekdayOfFirstDayOfTheMonth - 1)/7);
}

// 获取当天是当年的第几周
- (NSUInteger)weekOfDayInYear
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekOfYearCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}

// 获取当月的第一天
- (NSDate *)firstDayOfTheMonth
{
    [[self componentsOfDay] setDay:1];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}


@end
