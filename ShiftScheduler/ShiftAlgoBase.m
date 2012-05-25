#import "ShiftAlgoBase.h"
#import "OneJob.h"

@interface ShiftAlgoBase()
{
  	enum JobShiftAlgoType shiftType;
	OneJob *JobContext;
    NSCalendar *curCalendar;
}

@property (nonatomic)enum JobShiftAlgoType shiftType;

@end

@implementation ShiftAlgoBase
@synthesize shiftType, JobContext, curCalendar;


- (NSCalendar *) curCalendar
{
    if (!curCalendar) {
        curCalendar = [NSCalendar currentCalendar];
    }
    return curCalendar;
}

- (id) initWithContext: (OneJob *)context
{
  self = [super init];
  if (self) {
    self.jobContext = context;
  }
  return self;
}

- (void) setShiftType:(enum JobShiftAlgoType)mshiftType
{
    shiftType = mshiftType;
}

- (NSNumber *) shiftTotalCycle
{
    NSAssert(NO, @"should not call here");
    return [NSNumber numberWithInt:7];
}

- (NSArray *) shiftCalcWorkdayBetweenStartDate: (NSDate *) startDate endDate: (NSDate *) endDate
{
    NSAssert(NO, @"should not call here");
    return nil;
}
- (BOOL) shiftIsWorkingDay: (NSDate *)theDate
{
    NSAssert(NO, @"should not call here");
    return NO;
}

- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{

    NSDateComponents *difference = [self.curCalendar components:NSDayCalendarUnit
                                                       fromDate:fromDateTime toDate:toDateTime options:0];
    
    return [difference day];
}

@end

