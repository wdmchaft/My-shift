//
//  SSProfileTimeAndAlarmVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"

#define FROM_ITEM_STRING NSLocalizedString(@"Clock In", "Time to start work")
#define HOURS_ITEM_STRING NSLocalizedString(@"Hours", "How many hours?")
#define REMIND_BEFORE_WORK NSLocalizedString(@"Remind before start", "how long notice before work")
#define REMIND_BEFORE_CLOCK_OFF NSLocalizedString(@"Remind before off", "how long time remind me before off")

@interface SSProfileTimeAndAlarmVC : UITableViewController
{
    NSArray *itemsArray;
    OneJob *theJob;
    IBOutlet UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;
    int lastChooseCell;
}

@property (nonatomic, readonly) NSArray *itemsArray;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) OneJob *theJob;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (IBAction)datePickerValueChanged:(id)sender;
+ (void) configureTimeCell: (UITableViewCell *)cell indexPath: (NSIndexPath *)indexPath Job: (OneJob *)theJob;

@end
