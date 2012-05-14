#import <Function/Function.h>
#import <CoreData/CoreData.h>

#import "OneJob.h"

@interface ShiftAlgoBase : NSObject

- (id) initWithContext: (OneJob *)context;
- (NSArray *) shiftCalcWorkdayBetweenStartDate: (NSDate *) startDate endDate: (NSDate *) endDate;
- (BOOL) shiftIsWorkingDay: (NSDate *)theDate;

- (NSInteger)daysBetweenDateV2:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

@end
