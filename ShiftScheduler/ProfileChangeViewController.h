//
//  ProfileChangeViewController.h
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"
#import "ProfilesViewController.h"

#define PCVC_EDITING_MODE 0
#define PCVC_ADDING_MODE 1

// default working days and off days when adding new profile.
#define PCVC_DEFAULT_OFF_DAYS 2
#define PCVC_DEFAULT_ON_DAYS 5        

#define PICKER_VIEW_ON 1
#define PICKER_VIEW_OFF 2

@interface ProfileChangeViewController : UITableViewController  <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    int viewMode;
    int lastChoosePicker;
     UIDatePicker *datePicker;
    UITextField *nameField;
    UILabel *nameLable;
     UIPickerView *picker;
    NSArray *itemsArray;
    UIBarButtonItem *saveButton;
    UIBarButtonItem *cancelButton;
    NSDateFormatter *dateFormatter;
    NSManagedObjectContext *managedObjectContext;
    id<ProfileViewDelegate> profileDelegate;
    OneJob *theJob;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSArray *itemsArray;
@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UITextField *nameField;
@property (assign, nonatomic)    id<ProfileViewDelegate> profileDelegate;

@property int viewMode;

@property (retain) OneJob *theJob;

- (IBAction)datePickerValueChanged:(id)sender;
- (void) cancel:(id)sender;
- (void) saveProfile:(id) sender;
@end
