//
//  OneJob.m
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OneJob.h"
#import "NSDateAdditions.h"
#import "NSDate+JobInfo.h"

#define WORKDAY_TYPE_FULL 0
#define WORKDAY_TYPE_NOT  1
#define WORKDAY_TYPE_HALF 2
@interface WorkDay : NSObject {
@private
    int dayType;
    NSDate *theDate;
}

@property int dayType;
@property (retain) NSDate *theDate;
@end

@implementation WorkDay
@synthesize dayType;
@synthesize theDate;
@end


@implementation OneJob
@dynamic jobName;
@dynamic jobDescription;
@dynamic jobOnDays;
@dynamic jobOffDays;
@dynamic jobStartDate;
@dynamic jobFinishDate;
@dynamic jobGeneratedData;


@synthesize workdays;
@synthesize curCalender;

- (NSArray *)workdays
{
    if (!workdays || [workdays count] == 0) {
        workdays = [self JobDayArray];
        [workdays retain];
    }

    return workdays;
}

- (NSCalendar *) curCalender
{
    if (!curCalender) {
        curCalender = [[NSCalendar currentCalendar] retain];
    }
    return curCalender;
}

- (id)init
{
    self = [super init];
    return self;
}

#define DAY_TO_SECONDS 60*60*24

// ideas1 ， 只储存所有工作的日期， 在这个workdays的数组里。
//            问题： 但是问题是， 这样做了以后无法调整， 要调班的时候无法做了。
// idea2, 储存所有的日期， 一年也就365个嘛， 一百年也没多少个。 所以放的下。 
//          这样就需要把nsdate做继承。 继承或者不继承。。 继承了不用改现有代码。
// 先选择2把。
- (id) initWithWorkConfigWithStartDate: (NSDate *) thestartDate
                     workdayLengthWith: (int) workdaylength
                     restdayLengthWith: (int) restdayLength
                         lengthOfArray: (int) lengthOfArray
                              withName:(NSString *)name
{
    self = [self init];

    self.jobName = name;
    self.jobOnDays = [NSNumber numberWithInt:workdaylength];
    self.jobOffDays = [NSNumber numberWithInt:restdayLength];
    self.jobStartDate = [thestartDate cc_dateByMovingToBeginningOfDay]; // store UTC date to align with Kal's return value.
    [self generateJobArrayWithArray];
    
    return self;
}

- (void) dealloc
{
    [curCalender release];
}

#define DEFAULT_ARRAY_LENGTH 365

- (NSArray *) JobDayArray 
{
    NSMutableArray *daysArray = [NSMutableArray array];
    for (int i = 0; i < DEFAULT_ARRAY_LENGTH; i++) {
        WorkDay *the_day = [[[WorkDay alloc] init] autorelease];
        int t_worktype = WORKDAY_TYPE_FULL;
        //    if ((i % (workdaylength + restdayLength)) >= workdaylength)
        if (( i % ([self.jobOnDays intValue] + [self.jobOffDays intValue])) >= [self.jobOnDays intValue])
            t_worktype = WORKDAY_TYPE_NOT;
        the_day.dayType = t_worktype;


        //        the_day.theDate = [NSDate dateWithTimeInterval:i * DAY_TO_SECONDS sinceDate:thestartDate];
        the_day.theDate = [NSDate dateWithTimeInterval: i * DAY_TO_SECONDS sinceDate:self.jobStartDate];
        // hack to test function!!!
        the_day.theDate.jobType = WORKDAY_TYPE_HALF;
        
        [daysArray addObject:the_day];
    }
    return daysArray;
}

- (void) generateJobArrayWithArray
{
    self.workdays = [self JobDayArray];    
}

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    fromDate = [fromDateTime cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender];
    toDate = [[toDateTime cc_dateByMovingToEndOfDayWithCalender:self.curCalender] dateByAddingTimeInterval:100];
    // Add 100 seconds to make two day more than 24 Hour. 
    
    NSDateComponents *difference = [self.curCalender components:NSDayCalendarUnit
                                          fromDate:fromDate toDate:toDate options:0];

    return [difference day];
}


// TODO: this funtion will interval all the date!!!
// Every op will do 365 times!! if one year!!
- (NSArray *)returnWorkdaysWithInStartDate:(NSDate *) thestartDate endDate:(NSDate *) endDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (WorkDay *oneday in self.workdays) {
        if (IsDateBetweenInclusive(oneday.theDate,thestartDate,endDate) && oneday.dayType == WORKDAY_TYPE_FULL)
            [matches addObject:oneday.theDate];
//        else if ([self daysBetweenDate:oneday.theDate andDate:endDate] == 0 &&
//                 oneday.dayType == WORKDAY_TYPE_FULL)
//            // deal with start day and stop day are same day.
//            [matches addObject:oneday.theDate];
    }
    return matches;
}

- (BOOL) isDayWorkingDay:(NSDate *)theDate
{
    for (WorkDay *oneday in self.workdays) {
        if ([[oneday.theDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender] 
             compare:[theDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender]] == NSOrderedSame
            && oneday.dayType == WORKDAY_TYPE_FULL)
            return YES;
    }
    return NO;
}

@end
