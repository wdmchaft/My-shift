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

@interface SSTurnShiftTVC : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    int lastChoosePicker;
    UIPickerView *picker;
    UIDatePicker *datePicker;
    NSArray *itemsArray;
    NSDateFormatter *dateFormatter;
    OneJob *theJob;
    
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) OneJob *theJob;


- (IBAction)datePickerValueChanged:(id)sender;	

+ (void) showOrHideDatePickerView: (BOOL) show datePicker:(UIDatePicker *)datePicker view:(UIView *)theView;

@end
