//
//  ShiftChangeAddVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShiftDay.h"
#import "ShiftPickerDataSource.h"
@protocol ShiftChangeListDelegate;

@interface ShiftChangeAddVC : UITableViewController <UIPickerViewDelegate, UITextFieldDelegate>
{
    UISegmentedControl *changeShiftSegmentControl;
    NSManagedObjectContext *managedObjectContext;
    id<ShiftChangeListDelegate> listDelegate;
    UITextField *notesTextFiled;
    UIPickerView *shiftPicker;
    IBOutlet UIDatePicker *datePicker;
    ShiftPickerViewDataSource *shiftPickerDataSource;
    ShiftDay *theShiftChange;
    NSDateFormatter *dateFormatter;
    NSIndexPath *choosenIndex;
}

@property (nonatomic, strong) UISegmentedControl *changeShiftSegmentControl;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)   id<ShiftChangeListDelegate> listDelegate;
@property (strong) ShiftDay  *theShiftChange;
@property (nonatomic, strong) UITextField *notesTextFiled;
@property (nonatomic, strong) UIPickerView *shiftPicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (IBAction)datePickerValueChanged:(id)sender;
- (void) shiftPickerShow:(BOOL)show;
- (void) datePickerShow:(BOOL) show;


@end
