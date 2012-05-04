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
@dynamic jobRemindBeforeOff,jobRemindBeforeWork;
@synthesize curCalender, cachedJobOnIconColor, cachedJobOnIconID;



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
}


- (NSCalendar *) curCalender
{
    if (!curCalender) {
        curCalender = [NSCalendar currentCalendar];
    }
    return curCalender;
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


static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}


- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{

    NSDateComponents *difference = [self.curCalender components:NSDayCalendarUnit
                                                       fromDate:fromDateTime toDate:toDateTime options:0];
    
    return [difference day];
}

- (NSDate *) dateByMovingForwardDays:(NSInteger) i withDate:(NSDate *) theDate
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = i;
    return [self.curCalender dateByAddingComponents:c toDate:theDate options:0];
}


- (NSArray *)returnWorkdaysWithInStartDate:(NSDate *) beginDate endDate:(NSDate *) endDate
{
    
//     输入： 两个UTC的时间。
//     输出： 一个加上了时区的nsdate的数组。
//     注意的是： 这里经过nscalender计算以后，时间就变成了utc时间。    
    
    
    NSInteger timeZoneDiff = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:beginDate];
    // 1st, calulate a first array.
    
    // 计算的时候使用gmt时间， 在要把date加入到时区里面的时候， 加上时区的秒数。

    NSDate *jobStartGMT = [self.jobStartDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender];
    
    NSInteger diffBeginAndJobStartGMT = [self daysBetweenDateV2:jobStartGMT andDate:beginDate];
    NSInteger diffEndAndJobStartGMT = [self daysBetweenDateV2:jobStartGMT  andDate:endDate];
    NSInteger range  = [self daysBetweenDateV2:beginDate andDate:endDate];
    
    // 如果说都早于工作开始的时间， 就返回空
    if (diffEndAndJobStartGMT < 0 && diffBeginAndJobStartGMT < 0)
        return  [NSArray array];
    
    NSMutableArray *matchedArray = [[NSMutableArray alloc] init];
    NSDate *workingDate = beginDate;
    
//    这个循环从第一天开始，中间每次循环计算一个从beginDate开始的临时时间和工作开始时间的差距，
//    然后用这个差距所算出来的时间来计算工作的类型。
//    目前只计算工作的天数， 半天的那种需要后面加上。
    for (int i = 0;
         i < range;
         i++, workingDate = [workingDate cc_dateByMovingToNextDayWithCalender:self.curCalender]) 
    {
//    先计算出当前这个临时时间和工作开始时间的差别    
        int days = [self daysBetweenDateV2:jobStartGMT andDate:workingDate];
//    如果这个临时时间小于工作开始的时间，就直接进行下一个
        if (days < 0)
            continue;
//     恰好是工作当天，就直接加上了
        if (days == 0) {
            [matchedArray addObject:[[workingDate copy] dateByAddingTimeInterval:timeZoneDiff]];
            continue;
        }
//      剩下就是最通常的情况，用余数来计算工作的天数，如果小雨jobOnDays，那天以前都是工作日。
        int t = days % ([self.jobOnDays intValue]+ [self.jobOffDays intValue]);
        if (t < [self.jobOnDays intValue]) {
            [matchedArray addObject:[[workingDate copy] dateByAddingTimeInterval:timeZoneDiff]];
        }
    }
    
//    NSDate *date = [self.curCalender ]; 
    
       
    // 2nd, apply the half work day, (if have any).
    // 3rd, apply the switch of the shift.
    
    return matchedArray;
    
}

- (BOOL) isDayWorkingDay:(NSDate *)theDate
{
    NSDate *jobStartGMT = [self.jobStartDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalender];
    int days = [self daysBetweenDateV2:jobStartGMT andDate:theDate];
   
    if (days < 0) return  NO;
    if (days == 0) return YES;
    
    int t = days % ([self.jobOnDays intValue]+ [self.jobOffDays intValue]);
    if (t < [self.jobOnDays intValue])
        return YES;
    else
        return NO;
}

@end
