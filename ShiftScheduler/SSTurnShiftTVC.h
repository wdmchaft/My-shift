//
//  SSTurnShiftTVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"


// default working days and off days when adding new profile.
#define PCVC_DEFAULT_OFF_DAYS 2
#define PCVC_DEFAULT_ON_DAYS 5        

#define PICKER_VIEW_ON 0
#define PICKER_VIEW_OFF 1

@class SCModalPickerView;
@interface SSTurnShiftTVC : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *picker;
    UIDatePicker *datePicker;
    NSArray *itemsArray;
    NSDateFormatter *dateFormatter;
    OneJob *theJob;
    NSIndexPath *firstChooseIndexPath; // the indexPath use choose when enter this UI.
    SCModalPickerView *modalPickerView;
    SCModalPickerView *modalDatePickerView;
}

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) OneJob *theJob;
@property (nonatomic, strong) NSIndexPath *firstChooseIndexPath;

+ (BOOL) isItemInThisViewController: (NSString *) item;
+ (void) configureTimeCell: (UITableViewCell *)cell indexPath: (NSIndexPath *)indexPath Job: (OneJob *)theJob dateFormatter:(NSDateFormatter *)dateFormatter;


@end
