/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <Foundation/Foundation.h>

@interface NSDate (KalAdditions)

// All of the following methods use [NSCalendar currentCalendar] to perform
// their calculations.

- (NSDate *)cc_dateByMovingToBeginningOfDay;
- (NSDate *)cc_dateByMovingToMiddleOfDay;
- (NSDate *)cc_dateByMovingToEndOfDay;
- (NSDate *)cc_dateByMovingToEndOfDayWithCalender:(NSCalendar *)cal;
- (NSDate *)cc_dateByMovingToMiddleOfDayWithCalender:(NSCalendar *) cal;
- (NSDate *)cc_dateByMovingToBeginningOfDayWithCalender:(NSCalendar *) cal;
- (NSDate *)cc_dateByMovingToNextDayWithCalender: (NSCalendar *)cal;
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth;
- (NSDateComponents *)cc_componentsForMonthDayAndYear;
- (NSUInteger)cc_weekday;
- (NSUInteger)cc_numberOfDaysInMonth;
- (NSString *)cc_getHourMinitesFromDate;
- (NSDate *)cc_convertToUTC;

@end