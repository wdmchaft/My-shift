#import "ShiftAlgoBase.h"

@interface ShiftAlgoBase : Nsobject {
@private
  	JobShiftAlgoType shiftType;
	OneJob *JobContext;
}

@property JobShiftAlgoType shiftType;
@property (assign) OneJob *JobContext;
@end

@implementation ShiftAlgoBase
@synthesize shiftType;
@synthesize jobContext;

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
  return nil;
}
- (BOOL) shiftIsWorkingDay: (NSDate *)theDate
{
  return NO;
}

- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{

    NSDateComponents *difference = [self.curCalender components:NSDayCalendarUnit
                                                       fromDate:fromDateTime toDate:toDateTime options:0];
    
    return [difference day];
}

@end

