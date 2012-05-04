//
//  OneJob.h
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#include "ShiftDay.h"


#define JOB_DEFAULT_ON_DAYS 5
#define JOB_DEFAULT_OFF_DAYS 2
#define JOB_DEFAULT_ICON_FILE @"bag32.png"
#define JOB_DEFAULT_COLOR_VALUE @"25AA5C"
#define JOB_DEFAULT_EVERYDAY_ON_LENGTH (60*60*8)
#define JOB_DEFAULT_REMIND_TIME_BEFORE_WORK -1
#define JOB_DEFAULT_REMIND_TIME_BEFORE_OFF -1

@interface OneJob : NSManagedObject {
    NSCalendar *curCalender;
    NSCalendar *timezoneCalender;
    
    UIImage *iconImage;
    UIColor *iconColor;
    UIColor *defaultIconColor;
    NSString *cachedJobOnIconID;
    NSString *cachedJobOnIconColor;
    NSNumber *cachedJobOnIconColorOn;
    
}
@property (nonatomic, strong) NSString * jobName;       // the job's name
@property (nonatomic, strong) NSNumber * jobEnable;   // bool enable the job display on the cal or not
@property (nonatomic, strong) NSString * jobDescription; //the detail describe of this job
@property (nonatomic, strong) NSNumber * jobEveryDayLengthSec;  // minites of every day work.
@property (nonatomic, strong) NSDate * jobEverydayStartTime;
@property (nonatomic, strong) NSNumber * jobOnDays; // how long works once
@property (nonatomic, strong) NSNumber * jobOffDays; // how long rest once.
@property (nonatomic, strong) NSDate * jobStartDate;
@property (nonatomic, strong) NSDate * jobFinishDate;
@property (nonatomic, strong) NSString * jobOnColorID;
@property (nonatomic, strong) NSString * jobOnIconID;

@property (nonatomic, strong) NSNumber * jobOnIconColorOn;

@property (nonatomic, strong) NSCalendar *curCalender;
@property (weak, nonatomic, readonly) UIImage  *iconImage;
@property (weak, nonatomic, readonly) UIColor  *iconColor;
@property (nonatomic, strong) NSString *cachedJobOnIconColor;
@property (nonatomic, strong) NSString *cachedJobOnIconID;

@property (weak, nonatomic, readonly)  UIColor *defaultIconColor;
@property (nonatomic, strong) NSNumber * jobRemindBeforeOff;
@property (nonatomic, strong) NSNumber * jobRemindBeforeWork;


// init the work date generator with these input.
- (id) initWithWorkConfigWithStartDate: (NSDate *) startDate
                     workdayLengthWith: (int) workdaylength
                     restdayLengthWith: (int) restdayLength
                         lengthOfArray: (int) lengthOfArray
                              withName: (NSString *)name;

- (NSArray *) returnWorkdaysWithInStartDate:(NSDate *) startDate endDate: (NSDate *) endDate;
- (BOOL) isDayWorkingDay:(NSDate *)theDate;
- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

- (UIColor *) iconColor;
- (void) trydDfaultSetting;
- (void) forceDefaultSetting;
- (NSString *) jobEverydayOffTimeWithFormatter:(NSDateFormatter *) formatter;

@property (nonatomic, strong) NSSet *shiftdays;
@end

@interface OneJob (CoreDataGeneratedAccessors)

//  should check whether the shiftday is allowed. if the shift day is now allowed, return -Error Code;

//  eg, if the shift day is exchange shift day, one of "From" or "To" must has one "on day"
//      in a overwork shift day: it must added to a "off day"
//      in a vacation shift day: it must be on a "on day"

// return value:
// failed: return -X; is error number
// success: return 0;
- (NSInteger)addShiftdaysObject:(ShiftDay *)value;

- (void)removeShiftdaysObject:(ShiftDay *)value;
- (void)addShiftdays:(NSSet *)values;
- (void)removeShiftdays:(NSSet *)values;

@end



