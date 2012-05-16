#import "ShiftAlgoFreeRound.h"
#import "NSDateAdditions.h"
#import "OneJob.h"

/**
   Free Round shift is the shift with 
   X days on and Y days off round robin shift.
   It can fit some kind of shift work, like Bank Teller, etc.
   It widely used in China.
*/
@implementation ShiftAlgoFreeRound : ShiftAlgoBase

- (id)initWithContext:(OneJob *)context
{
    self = [super initWithContext:context];
    [self setShiftType:JOB_SHIFT_ALGO_FREE_ROUND];
    return self;
}

- (NSArray *) shiftCalcWorkdayBetweenStartDate: (NSDate *) beginDate endDate: (NSDate *) endDate
{
  //     输入： 两个UTC的时间。
//     输出： 一个加上了时区的nsdate的数组。
//     注意的是： 这里经过nscalender计算以后，时间就变成了utc时间。    
    
    
    NSInteger timeZoneDiff = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:beginDate];
    // 1st, calulate a first array.
    
    // 计算的时候使用gmt时间， 在要把date加入到时区里面的时候， 加上时区的秒数。

    NSDate *jobStartGMT = [self.JobContext.jobStartDate cc_dateByMovingToBeginningOfDayWithCalender:self.curCalendar];
    
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
    for (int i = 0; i < range; i++,workingDate = [workingDate cc_dateByMovingToNextDayWithCalender:self.curCalendar])
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
        int jobOnDays = [self.JobContext.jobOnDays intValue];
        int jobOffDays = [self.JobContext.jobOffDays intValue];
        
        int totaldays = jobOnDays + jobOffDays;
        
        int t = days % totaldays;
        
        if (t < jobOnDays) {
            [matchedArray addObject:[[workingDate copy] dateByAddingTimeInterval:timeZoneDiff]];
        }
        
    }
    
//    NSDate *date = [self.curCalender ]; 
    
       
    // 2nd, apply the half work day, (if have any).
    // 3rd, apply the switch of the shift.
    
    return matchedArray;
}

- (BOOL) shiftIsWorkingDay: (NSDate *)theDate
{
    int jobOnDays = [self.JobContext.jobOnDays intValue];
    int jobOffDays = [self.JobContext.jobOffDays intValue];

    
    NSDate *jobStartGMT = [self.JobContext.jobStartDate
                            cc_dateByMovingToBeginningOfDayWithCalender:self.curCalendar];
    int days = [self daysBetweenDateV2:jobStartGMT andDate:theDate];
   
    if (days < 0) return  NO;
    if (days == 0) return YES;
    
    int t = days % (jobOnDays + jobOffDays);
    if (t < jobOnDays)
        return YES;
    else
        return NO;
}

@end
