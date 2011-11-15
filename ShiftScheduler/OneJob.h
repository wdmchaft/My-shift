//
//  OneJob.h
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OneJob : NSManagedObject {
    NSArray *workdays;
    NSCalendar *curCalender;
    
@private
}
@property (nonatomic, retain) NSString * jobName;       // the job's name
@property (nonatomic, retain) NSString * jobDescription; //the detail describe of this job
@property (nonatomic, retain) NSNumber * jobOnDays; // how long works once
@property (nonatomic, retain) NSNumber * jobOffDays; // how long rest once.
@property (nonatomic, retain) NSDate * jobStartDate;
@property (nonatomic, retain) NSDate * jobFinishDate;
@property (nonatomic, retain) NSData * jobGeneratedData;
@property (nonatomic, retain) NSArray * workdays;

@property (nonatomic, retain) NSCalendar *curCalender;


// init the work date generator with these input.
- (id) initWithWorkConfigWithStartDate: (NSDate *) startDate
                     workdayLengthWith: (int) workdaylength
                     restdayLengthWith: (int) restdayLength
                         lengthOfArray: (int) lengthOfArray
                              withName: (NSString *)name;

// return a array with nsdata object between a range of date
- (NSArray *) returnWorkdaysWithInStartDate:(NSDate *) startDate endDate: (NSDate *) endDate;
- (BOOL) isDayWorkingDay:(NSDate *)theDate;
- (void) generateJobArrayWithArray;
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
- (NSArray *) JobDayArray;


@end
