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


@interface OneJob : NSManagedObject {
    NSCalendar *curCalender;
    NSCalendar *timezoneCalender;
    
    UIImage *iconImage;
    UIColor *iconColor;
    UIColor *defaultIconColor;
    NSString *cachedJobOnIconID;
    NSString *cachedJonOnIconColor;
    NSNumber *cachedJobOnIconColorOn;
    
}
@property (nonatomic, strong) NSString * jobName;       // the job's name
@property (nonatomic, strong) NSString * jobDescription; //the detail describe of this job
@property (nonatomic, strong) NSNumber * jobOnDays; // how long works once
@property (nonatomic, strong) NSNumber * jobOffDays; // how long rest once.
@property (nonatomic, strong) NSDate * jobStartDate;
@property (nonatomic, strong) NSDate * jobFinishDate;
@property (nonatomic, retain) NSString * jobOnColorID;
@property (nonatomic, retain) NSString * jobOnIconID;

@property (nonatomic, retain) NSNumber * jobOnIconColorOn;

@property (nonatomic, strong) NSCalendar *curCalender;
@property (nonatomic, readonly) UIImage  *iconImage;
@property (nonatomic, readonly) UIColor  *iconColor;
@property (nonatomic, readonly)  UIColor *defaultIconColor;


// init the work date generator with these input.
- (id) initWithWorkConfigWithStartDate: (NSDate *) startDate
                     workdayLengthWith: (int) workdaylength
                     restdayLengthWith: (int) restdayLength
                         lengthOfArray: (int) lengthOfArray
                              withName: (NSString *)name;

- (NSArray *) returnWorkdaysWithInStartDate:(NSDate *) startDate endDate: (NSDate *) endDate;
- (BOOL) isDayWorkingDay:(NSDate *)theDate;
- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

// This function create a Image Context and draw the image with mask
// then clip the context to mask
// then fill the color user choosed.
// that can create a image shape with specify color icon.
+ (UIImage *) processIconImageWithColor: (UIImage *)icon withColor: (UIColor *)color;


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



