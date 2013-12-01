//
//  RCDate.h
//  RunCalc
//
//  Created by Christian on 04/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDate : NSObject

+(NSInteger)numberOfWeeksToDate:(NSDate *)endDate sinceDate:(NSDate *)startDate;
+(NSInteger)numberOfDaysToDate:(NSDate *)endDate sinceDate:(NSDate *)startDate;
+(NSInteger)numberOfWeeksToDateSinceNow:(NSDate *)endDate;
+(NSInteger)numberOfDaysToDateSinceNow:(NSDate *)endDate;
+(NSDate *) dateBySubstractingWeeks: (NSInteger) nbWeeK toDate:(NSDate *)aDate;

@end
