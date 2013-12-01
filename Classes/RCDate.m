//
//  RCDate.m
//  RunCalc
//
//  Created by Christian on 04/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCDate.h"

@implementation RCDate

+ (NSInteger)numberOfWeeksToDate:(NSDate *)endDate sinceDate:(NSDate *)startDate {
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier: NSGregorianCalendar];
    NSUInteger unitFlags = NSWeekCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:startDate toDate:endDate options:0];
    return [components week];
}

+ (NSInteger)numberOfDaysToDate:(NSDate *)endDate sinceDate:(NSDate *)startDate {
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier: NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:startDate toDate:endDate options:0];
    return [components day];
}

+ (NSInteger)numberOfDaysToDateSinceNow:(NSDate *)endDate {
    NSDate *now = [[NSDate alloc] init];
    return [RCDate numberOfDaysToDate:endDate sinceDate:now];
}

+ (NSInteger)numberOfWeeksToDateSinceNow:(NSDate *)endDate {
    NSDate *now = [[NSDate alloc] init];
    return [RCDate numberOfWeeksToDate:endDate sinceDate:now];
}

+ (NSDate *)dateBySubstractingWeeks:(NSInteger)nbWeeks toDate:(NSDate *)aDate {
//    NSDate *adjustedDate;
    NSDateComponents *componentsToSubstract = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components = [cal components:NSWeekdayCalendarUnit fromDate:aDate];
    // if the date day is Sunday to thursday
    if ([components weekday] < 6) {
        [componentsToSubstract setDay:0 - ([components weekday] - 1)];
    }
    else {
        [componentsToSubstract setDay:8 - [components weekday]];
    }
    [componentsToSubstract setWeek: -nbWeeks];
    return [cal dateByAddingComponents:componentsToSubstract toDate:aDate options:0];
}

@end
