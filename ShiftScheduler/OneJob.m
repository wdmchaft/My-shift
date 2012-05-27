//
//  OneJob.m
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OneJob.h"
#import "NSDateAdditions.h"
#import "UIColor+HexCoding.h"
#import "UIImage+MonoImage.h"

#import "ShiftAlgoBase.h"
#import "ShiftAlgoFreeRound.h"
#import "ShiftAlgoFreeJump.h"

#define WORKDAY_TYPE_FULL 0
#define WORKDAY_TYPE_NOT  1
#define WORKDAY_TYPE_HALF 2
@interface WorkDay : NSObject {
@private
    int dayType;
    NSDate *theDate;
}

@property int dayType;
@property (strong) NSDate *theDate;
@end

@implementation WorkDay
@synthesize dayType;
@synthesize theDate;
@end

@interface OneJob()
{
    ShiftAlgoBase *shiftAlgo;
    NSArray *jobShiftAllTypesString;
    NSCalendar *curCalender;
    NSCalendar *timezoneCalender;
    NSArray *jobFreejumpTable;
    UIImage *iconImage;
    UIColor *iconColor;
    UIColor *defaultIconColor;
    NSString *cachedJobOnIconID;
    NSString *cachedJobOnIconColor;
    NSNumber *cachedJobOnIconColorOn;
}
@property (strong, nonatomic) ShiftAlgoBase *shiftAlgo;

@end

@implementation OneJob
@dynamic jobName;
@dynamic jobEnable;
@dynamic jobDescription;
@dynamic jobEveryDayLengthSec;
@dynamic jobEverydayStartTime;
@dynamic jobOnDays;
@dynamic jobOffDays;
@dynamic jobStartDate;
@dynamic jobFinishDate;
@dynamic shiftdays;
@dynamic jobOnColorID,jobOnIconColorOn;
@dynamic jobOnIconID;
@dynamic jobShiftType;
@dynamic jobRemindBeforeOff,jobRemindBeforeWork;
@synthesize curCalender, cachedJobOnIconColor, cachedJobOnIconID, shiftAlgo, jobShiftTypeString;

- (ShiftAlgoBase *)shiftAlgo;
{
    if (shiftAlgo == nil) {
	enum JobShiftAlgoType type = (enum JobShiftAlgoType)self.jobShiftType.intValue;
	switch(type) {
        case JOB_SHIFT_ALGO_FREE_ROUND:
            shiftAlgo = [[ShiftAlgoFreeRound alloc] initWithContext:self];
            break;
        case JOB_SHIFT_ALGO_FREE_JUMP:
            shiftAlgo = [[ShiftAlgoFreeJump alloc] initWithContext:self];
            break;
	default:
	    assert (-1);
	}
    }
    return shiftAlgo;
}

- (void) setJobFreejumpTable:(NSArray *) array
{
    jobFreejumpTable = [array copy];
    
    // archive the table to the core date also do here.
    // *TODO* add later.
}

/** this function should do the job convert all jump work information
 * to an array can be process by the modale
 */
- (NSArray *) jobFreejumpTable
{
#warning add later.
    return jobFreejumpTable;
}

#define FREE_JUMP_STRING NSLocalizedString(@"Free Jump", "")
#define FREE_ROUND_STRING NSLocalizedString(@"Day Round", "")
#define HOUR_ROUND_STRING NSLocalizedString(@"Hour Round", "")
#define NA_SHITF_STRING   NSLocalizedString(@"N/A", "")

- (NSArray *) jobShiftAllTypesString
{
    
    if (jobShiftAllTypesString == nil) {
        jobShiftAllTypesString = [[NSArray alloc] initWithObjects:
                                  FREE_ROUND_STRING,
                                  FREE_JUMP_STRING,
                                  HOUR_ROUND_STRING,
                                  nil];
    }
    return jobShiftAllTypesString;
}

- (Boolean) shiftTypeValied
{
    NSInteger n = self.jobShiftType.intValue;
    if (n > 0 && n < [[self jobShiftAllTypesString] count]) {
        return YES;
    }
    return NO;
}

- (Boolean) isShiftDateValied
{
    return  self.jobFinishDate == nil || ([self.jobStartDate compare:self.jobFinishDate] == NSOrderedAscending) ;
}

- (NSNumber *) shiftTotalCycle
{
    return [self.shiftAlgo shiftTotalCycle];
}

- (NSString *) jobShiftTypeString
{
    
    if ([self shiftTypeValied])
        return [[self jobShiftAllTypesString]
		   objectAtIndex:(self.jobShiftType.intValue - 1)];
    //    NSAssert(NO, @"shiftType return with empty string, should not happen");
    return [NSString string];
}

- (void) trydDfaultSetting
// will reset to default setting if not set.
{
    if (!self.jobOnDays)
        self.jobOnDays = [NSNumber numberWithInt:JOB_DEFAULT_ON_DAYS];
    
    if (!self.jobOffDays)
        self.jobOffDays = [NSNumber numberWithInt:JOB_DEFAULT_OFF_DAYS];
    
    if (!self.jobStartDate)
        self.jobStartDate = [NSDate date];
    
    if (!self.jobOnIconID)
    self.jobOnIconID = JOB_DEFAULT_ICON_FILE;
    
    if (!self.jobEnable)
        self.jobEnable = [NSNumber numberWithBool:YES];
    
    if (!self.jobOnColorID)
        self.jobOnColorID = JOB_DEFAULT_COLOR_VALUE;
    
    NSDateComponents *defaultOnTime = [[NSDateComponents alloc] init];
    [defaultOnTime setHour:8];
    [defaultOnTime setMinute:0];
    if (!self.jobEverydayStartTime)
        self.jobEverydayStartTime =  [[NSCalendar currentCalendar] dateFromComponents:defaultOnTime];
    
    if (!self.jobEveryDayLengthSec)
        self.jobEveryDayLengthSec = [NSNumber numberWithInt: JOB_DEFAULT_EVERYDAY_ON_LENGTH]; // 8 hour a day default
    
    if (!self.jobRemindBeforeOff)
        self.jobRemindBeforeOff = [NSNumber numberWithInt:JOB_DEFAULT_REMIND_TIME_BEFORE_OFF];
    
    if (!self.jobRemindBeforeWork)
        self.jobRemindBeforeWork = [NSNumber numberWithInt:JOB_DEFAULT_REMIND_TIME_BEFORE_WORK];
    
    if (!self.jobShiftType)
        self.jobShiftType = [NSNumber numberWithInt:JOB_SHIFT_ALGO_FREE_ROUND];
}



- (void) forceDefaultSetting
// will reset to default setting if not set.
{
    self.jobOnDays = [NSNumber numberWithInt:JOB_DEFAULT_ON_DAYS];
    
    self.jobOffDays = [NSNumber numberWithInt:JOB_DEFAULT_OFF_DAYS];
    
    self.jobStartDate = [NSDate date];
    
    self.jobOnIconID = JOB_DEFAULT_ICON_FILE;
    
    self.jobOnColorID = JOB_DEFAULT_COLOR_VALUE;
    
    self.jobEnable = [NSNumber numberWithBool:YES];
    
    NSDateComponents *defaultOnTime = [[NSDateComponents alloc] init];
    [defaultOnTime setHour:8];
    [defaultOnTime setMinute:0];
    self.jobEverydayStartTime =  [[NSCalendar currentCalendar] dateFromComponents:defaultOnTime];
    
    self.jobEveryDayLengthSec = [NSNumber numberWithInt: JOB_DEFAULT_EVERYDAY_ON_LENGTH]; // 8 hour a day default
    self.jobRemindBeforeOff = [NSNumber numberWithInt:JOB_DEFAULT_REMIND_TIME_BEFORE_OFF];
    self.jobRemindBeforeWork = [NSNumber numberWithInt:JOB_DEFAULT_REMIND_TIME_BEFORE_WORK];
    
//#warning  remove this test message
//    self.jobShiftType = [NSNumber numberWithInt:JOB_SHIFT_ALGO_FREE_JUMP];
//#warning  remove this test message
}




- (NSString *)jobEverydayOffTimeWithFormatter:(NSDateFormatter *)formatter
{
    return [formatter stringFromDate:[self.jobEverydayStartTime dateByAddingTimeInterval:
                                   self.jobEveryDayLengthSec.intValue]];
}


- (UIImage *) iconImage
{
    if (!iconImage 
        || ![cachedJobOnIconID isEqualToString:self.jobOnIconID]
#ifdef ENABLE_COLOR_ENABLE_CHOOSE
        || ![cachedJobOnIconColorOn isEqualToNumber:self.jobOnIconColorOn]
#endif
        ) {
        
        if (self.jobOnIconID == nil)
            self.jobOnIconID = JOB_DEFAULT_ICON_FILE;
        
        NSString *iconpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"jobicons.bundle/%@", self.jobOnIconID] ofType:nil];
        
        iconImage = [UIImage imageWithContentsOfFile:iconpath];
        cachedJobOnIconID = self.jobOnIconID;
        if (!iconImage) {
            NSLog(@"ICON: can't found icon %@", self.jobOnIconID);
        }
        
        // disable cholor enable or not choose by user;
#ifdef ENABLE_COLOR_ENABLE_CHOOSE
        cachedJobOnIconColorOn = self.jobOnIconColorOn;
       if (self.jobOnIconColorOn.intValue == TRUE) {
            iconImage = [OneJob processIconImageWithColor:iconImage withColor:self.iconColor];
        }
#else
        iconImage = [UIImage generateMonoImage:iconImage withColor:self.iconColor];
#endif
    }
    return iconImage;
}

// Always have a color of Icon,
// for this application, color can use to notice different tasks,
// so different color make sense, no color not make sense.
// instread of return NULL, Return a default COLOR

#define DEFAULT_ALPHA_VALUE_OF_JOB_ICON 0.9f

- (UIColor *) defaultIconColor
{
    if (defaultIconColor == nil) {
        // 39814c is green one
        // B674C2 is light purple one
        defaultIconColor = [UIColor colorWithHexString:JOB_DEFAULT_COLOR_VALUE withAlpha:DEFAULT_ALPHA_VALUE_OF_JOB_ICON];
    }
    return defaultIconColor;
}

- (UIColor *) iconColor
{
    if (!iconColor || ![cachedJobOnIconColor isEqualToString:self.jobOnColorID]) {
        if (self.jobOnColorID == nil)
            return self.defaultIconColor;
        NSLog(@"%@", self.jobOnColorID);
        iconColor = [UIColor colorWithHexString:self.jobOnColorID 
                                      withAlpha:DEFAULT_ALPHA_VALUE_OF_JOB_ICON];
        
        if (cachedJobOnIconColor != self.jobOnIconID) 
            cachedJobOnIconID = nil;
        cachedJobOnIconColor = self.jobOnColorID;
        
    }
    
#ifdef ENABLE_COLOR_ENABLE_CHOOSE
    if (self.jobOnIconColorOn.intValue == FALSE)
       return nil;
#endif

    return iconColor;
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
    self.jobStartDate = thestartDate;
    return self;
}


+ (BOOL) IsDateBetweenInclusive:(NSDate *)date begin: (NSDate *) begin end: (NSDate *)end;
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

- (NSDate *) dateByMovingForwardDays:(NSInteger) i withDate:(NSDate *) theDate
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = i;
    return [self.curCalender dateByAddingComponents:c toDate:theDate options:0];
}


- (NSArray *)returnWorkdaysWithInStartDate:(NSDate *) beginDate endDate:(NSDate *) endDate
{
    return [self.shiftAlgo shiftCalcWorkdayBetweenStartDate:beginDate endDate:endDate];
}

- (BOOL) isDayWorkingDay:(NSDate *)theDate
{
    return [self.shiftAlgo shiftIsWorkingDay:theDate];
}
@end
