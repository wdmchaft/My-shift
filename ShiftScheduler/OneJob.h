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
@property (nonatomic, strong) NSString * jobName;       // the job's name
@property (nonatomic, strong) NSString * jobDescription; //the detail describe of this job
@property (nonatomic, strong) NSNumber * jobOnDays; // how long works once
@property (nonatomic, strong) NSNumber * jobOffDays; // how long rest once.
@property (nonatomic, strong) NSDate * jobStartDate;
@property (nonatomic, strong) NSDate * jobFinishDate;
@property (nonatomic, strong) NSData * jobGeneratedData;
@property (nonatomic, strong) NSArray * workdays;

@property (nonatomic, strong) NSCalendar *curCalender;


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
