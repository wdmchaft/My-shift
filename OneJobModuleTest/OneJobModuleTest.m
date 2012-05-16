//
//  OneJobModuleTest.m
//  OneJobModuleTest
//
//  Created by 洁靖 张 on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OneJobModuleTest.h"
#import "NSDateAdditions.h"
#import "ShiftAlgoFreeJump.h"
#import "ShiftAlgoFreeRound.h"

@implementation OneJobModuleTest


@synthesize moc;

- (void)setUp
{
    [super setUp];
    
    NSArray *bundles = [NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]];
    
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:bundles];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] 
                                         initWithManagedObjectModel:mom];
    STAssertTrue([psc addPersistentStoreWithType: NSInMemoryStoreType 
                                   configuration:nil 
                                             URL:nil 
                                         options:nil 
                                           error:NULL] 
                 ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;

    calender = [NSCalendar currentCalendar];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    self.moc = nil;    
    [super tearDown];
}

// the default on and off is 5/2
- (void)testFreesRoundADefaultOnDay
{
    onOffJob = [NSEntityDescription insertNewObjectForEntityForName:@"OneJob" 
                                             inManagedObjectContext:self.moc];
    [onOffJob forceDefaultSetting];
    onOffJob.jobShiftType = [NSNumber numberWithInt:JOB_SHIFT_ALGO_FREE_ROUND];

    NSDate *today = [NSDate date];
    onOffJob.jobStartDate = today; // start from today... 
    
    int testround = 50;
    int totalloop = 7;
    int default_on = JOB_DEFAULT_ON_DAYS;
    int default_off = JOB_DEFAULT_OFF_DAYS;
    
    STAssertTrue(onOffJob.jobOnDays.intValue == default_on, 
                 @"default on not equal to 5");
    STAssertTrue(onOffJob.jobOffDays.intValue == default_off, 
                 @"defualt off not equla to 2");
    
    NSLog(@"start Date: %@", [formatter stringFromDate:today]);

    int workdays = 0;
    // start test isDayWorking Day...
    for (int j = 0 ; j < testround; j++) {
    
        for (int i = 0 + (totalloop*j); i < default_on + (totalloop * j); i++) {
            NSDate *target_time = [today cc_dateByMovingToNextOrBackwardsFewDays:i
                                                            withCalender:calender];
            STAssertTrue([onOffJob isDayWorkingDay:target_time], 
                         @"%d day is working day: date: %@", 
                         i, 
                         [formatter stringFromDate:target_time]);
            workdays++;
            
            // this function is return the work days between start and target, if it was same day, it means no work days. so it return 0.
            // this is a special case... 
            NSArray *a = [onOffJob returnWorkdaysWithInStartDate:today endDate:target_time];
            STAssertTrue( a.count == workdays - 1,
                          @"work days not equal count:%d loop:%d, array:%@  ",
                         a.count, workdays, a);
        }
        for (int i = 0 + (totalloop*j); i < default_off + (totalloop * j); i++) {
            
            i = default_on + i;
            NSDate *target_time = [today cc_dateByMovingToNextOrBackwardsFewDays:i
                                                                    withCalender:calender];
            STAssertFalse([onOffJob isDayWorkingDay:target_time], 
                          @"%d day is off day: date: %@", 
                          i, 
                          [formatter stringFromDate:target_time]);
        }
    }
}

- (void) testFreeJumpShift
{
    OneJob *freejumpJob;

    freejumpJob = [NSEntityDescription insertNewObjectForEntityForName:@"OneJob" 
                                             inManagedObjectContext:self.moc];
    [freejumpJob forceDefaultSetting];
    freejumpJob.jobShiftType = [NSNumber numberWithInt:JOB_SHIFT_ALGO_FREE_JUMP];
    
    
        // Setup a test array for flowing case:
        // 1. 2 on 2 off, and 6 on 6 off.
        // Totally 12+4 = 16 days.
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    
    [ma addObject: [NSNumber numberWithInt: 1]];
    [ma addObject: [NSNumber numberWithInt: 1]];
    [ma addObject: [NSNumber numberWithInt: 0]];
    [ma addObject: [NSNumber numberWithInt: 0]];
    for (int i = 0; i < 6; i++)
        [ma addObject: [NSNumber numberWithInt: 1]];
    for (int i = 0; i < 6; i++)
        [ma addObject: [NSNumber numberWithInt: 0]];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    
    freejumpJob.jobFreejumpTable = ma;

    NSDate *today = [NSDate date];
    
    // test case is inside of Jump Shift model
    // and the model is 
    // 1, 2, working
    // 3, 4, off
    // 6 days on
    // 6 days off.
    
    int testround = 2;
    
    for (int i = 0; i < testround; i++) {
        int each_round = 16;
        for (int j = 0; j < each_round; j++) {
            int t = (each_round * i) + j;
            NSDate *target_time = [today cc_dateByMovingToNextOrBackwardsFewDays:t withCalender:calender];
            
            NSArray *a = [freejumpJob returnWorkdaysWithInStartDate:today endDate:target_time];
            if (t != 0)
                STAssertTrue(( [a count] > 0), @"%d count: %d of target time not > 0, %d %@",t, a.count, t, [formatter stringFromDate:target_time]);
            
            if (j == 0 
                || j == 1 
                || (j >= 4 && j < 10)) {
                STAssertTrue([freejumpJob isDayWorkingDay:target_time],
                             @"%d day working: %@", t, [formatter stringFromDate:target_time]);
            } else {
                STAssertFalse([freejumpJob isDayWorkingDay:target_time],
                             @"%d day off: %@", t, [formatter stringFromDate:target_time]);
            }
            
            
        }
    }
}




@end
