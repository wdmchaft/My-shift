#import "ShiftAlgoBase.h"
#import "OneJob.h"

@interface ShiftAlgoBase()
{
  	enum JobShiftAlgoType shiftType;
	OneJob *JobContext;
    NSCalendar *curCalendar;
}

@property enum JobShiftAlgoType shiftType;

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

- (NSArray *) shiftCalcWorkdayBetweenStartDate: (NSDate *) startDate endDate: (NSDate *) endDate
{
    NSAssert(-1, @"should not call here");
    return nil;
}
- (BOOL) shiftIsWorkingDay: (NSDate *)theDate
{
    NSAssert(-1, @"should not call here");
    return NO;
}

- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{

    NSDateComponents *difference = [self.curCalendar components:NSDayCalendarUnit
                                                       fromDate:fromDateTime toDate:toDateTime options:0];
    
    return [difference day];
}

@end

