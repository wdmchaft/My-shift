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
#import "ProfileIconPickerDataSource.h"
#import "InfColorPickerController.h"
#import "SSShiftTypePickerTVC.h"


#define PCVC_EDITING_MODE 0
#define PCVC_ADDING_MODE 1

// default working days and off days when adding new profile.

@interface ProfileChangeViewController : 
UITableViewController  
<UITextFieldDelegate, JPImagePickerControllerDelegate, InfColorPickerControllerDelegate, SSShiftTypePickerDelegate>

@property (nonatomic, strong) UISwitch *colorEnableSwitch;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *timeItemsArray;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) ProfileIconPickerDataSource *iconDateSource;
@property int viewMode;
@property (nonatomic, strong) OneJob *theJob;

@property (assign, nonatomic)    id<ProfileViewDelegate> profileDelegate;

- (IBAction) cancel:(id)sender;
- (void) saveProfile:(id) sender;

- (void)textFieldDidEndEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField*)sender;

@end
