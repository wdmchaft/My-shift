//
//  SSProfileTimeAndAlarmVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"
#import "SCModalPickerView.h"

#define FROM_ITEM_STRING NSLocalizedString(@"Clock In", "Time to start work")
#define HOURS_ITEM_STRING NSLocalizedString(@"Hours", "How many hours?")
#define REMIND_BEFORE_WORK NSLocalizedString(@"Remind before start", "how long notice before work")
#define REMIND_BEFORE_CLOCK_OFF NSLocalizedString(@"Remind before off", "how long time remind me before off")
@class SCModalPickerView;

@interface SSProfileTimeAndAlarmVC : UITableViewController
{
    NSArray *itemsArray;
    OneJob *theJob;
    IBOutlet UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;
    NSIndexPath *firstChooseIndexPath; // the indexPath use choose when enter this UI.
    int lastChooseCell;
    SCModalPickerView *modalPickerView;
}

@property (weak, nonatomic, readonly) NSArray *itemsArray;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) OneJob *theJob;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSIndexPath *firstChooseIndexPath;


+ (void) configureTimeCell: (UITableViewCell *)cell indexPath: (NSIndexPath *)indexPath Job: (OneJob *)theJob;

+ (BOOL) isItemInThisViewController: (NSString *) item;

@end
