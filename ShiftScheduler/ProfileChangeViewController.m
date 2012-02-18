//
//  ProfileChangeViewController.m
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProfileChangeViewController.h"
#import "UIColor+HexCoding.h"
#import "InfColorPicker.h"
#import "SSTurnShiftTVC.h"
#import "SSProfileTimeAndAlarmVC.h"

@implementation ProfileChangeViewController

@synthesize itemsArray, saveButton, dateFormatter, cancelButton;
@synthesize theJob, viewMode;
@synthesize managedObjectContext, profileDelegate, iconDateSource, colorEnableSwitch;
@synthesize  nameField, timeItemsArray;


#pragma mark - "init values"

#define NAME_ITEM_STRING  NSLocalizedString(@"Job Name", "job name")
#define ICON_ITEM_STRING  NSLocalizedString(@"Change Icon", "choose a icon")
#define COLOR_ENABLE_STRING NSLocalizedString(@"Enable color icon", "enable color icon")
#define COLOR_PICKER_STRING NSLocalizedString(@"Change Color", "choose a color to show icon")
#define WORKLEN_ITEM_STRING NSLocalizedString(@"Work Length", "how long work days")
#define RESTLEN_ITEM_STRING NSLocalizedString(@"Rest Length", "how long rest days")
#define STARTWITH_ITEM_STRING NSLocalizedString(@"Start With", "start with this date")

- (NSArray *) itemsArray
{
    
    if (!itemsArray) {
        itemsArray = [[NSArray alloc] initWithObjects:
					  NAME_ITEM_STRING,
				      ICON_ITEM_STRING,
				      
//                      COLOR_ENABLE_STRING,
				      COLOR_PICKER_STRING,
				      WORKLEN_ITEM_STRING,
				      RESTLEN_ITEM_STRING,
				      STARTWITH_ITEM_STRING ,
				      nil];
    }
    return itemsArray;
}

- (NSArray *) timeItemsArray
{
    if (!timeItemArray) {
	timeItemArray = [[NSArray alloc] initWithObjects:
					     FROM_ITEM_STRING,
					 HOURS_ITEM_STRING,
					 REMIND_BEFORE_WORK,
					 REMIND_BEFORE_CLOCK_OFF,
					 nil];
    }
    return timeItemArray;
}

- (UIBarButtonItem *)saveButton
{
    if (!saveButton)
        saveButton = [[UIBarButtonItem alloc] 
                      initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                      target  :self
                      action:@selector(saveProfile:)];
    return saveButton;
}

- (UIBarButtonItem *)cancelButton
{
    if (!cancelButton)
        cancelButton = [[UIBarButtonItem alloc]
			   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
						target:self
						action:@selector(cancel:)];
    return cancelButton;
}

- (NSDateFormatter *) dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;
}

- (ProfileIconPickerDataSource *) iconDateSource
{
    if (!iconDateSource) {
        iconDateSource = [[ProfileIconPickerDataSource alloc] init];
    }
    return  iconDateSource;
}

#define kTextFieldWidth	130.0
// for general screen
#define kLeftMargin             150.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0
#define kViewTag 1
- (UITextField *)nameField
{
	if (nameField == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin, 8.0, kTextFieldWidth, kTextFieldHeight);
		nameField = [[UITextField alloc] initWithFrame:frame];
		nameField.textColor = [UIColor blackColor];
		nameField.placeholder = NSLocalizedString(@"Name of Job", nil);
		nameField.autocorrectionType = UITextAutocorrectionTypeDefault;	// no auto correction support
		
		nameField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		nameField.returnKeyType = UIReturnKeyDone;
		nameField.borderStyle = UITextBorderStyleNone;
        //		nameField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
        nameField.clearButtonMode = UITextFieldViewModeNever;
		nameField.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
        nameField.textAlignment = UITextAlignmentRight;
	}	
	return nameField;
}

-(BOOL)textFieldShouldReturn:(UITextField*)sender
{
    if (self.theJob.jobName.length > 0) {
       [self.nameField resignFirstResponder];
        return YES;
    } else
        return  NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
        return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // update the name every tpying.
    self.theJob.jobName = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.theJob.jobName = textField.text;
    [textField resignFirstResponder];
}


- (UISwitch *)colorEnableSwitch
{
    if (colorEnableSwitch == nil) 
    {
        CGRect frame = CGRectMake(200, 8.0, 120.0, 27.0);
        colorEnableSwitch = [[UISwitch alloc] initWithFrame:frame];
        [colorEnableSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        colorEnableSwitch.backgroundColor = [UIColor clearColor];
		
		[colorEnableSwitch setAccessibilityLabel:NSLocalizedString(@"Color Enable Switch", @"")];
		
		colorEnableSwitch.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
    }
    return colorEnableSwitch;
}

- (void)switchAction:(id)sender
{
	// NSLog(@"switchAction: value = %d", [sender isOn]);
    self.theJob.jobOnIconColorOn = [NSNumber numberWithInt:[sender isOn]];
    [self.tableView reloadData];
    
    // TODO: make choose color cell disappear.
}


#pragma mark - "controller start init"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
 
    if (self.viewMode == PCVC_ADDING_MODE) {
        self.navigationItem.rightBarButtonItem = self.saveButton;
    } else {
        // not support profile editing yet!
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    if (self.viewMode == PCVC_ADDING_MODE) 
        self.navigationItem.leftBarButtonItem = self.cancelButton;
    // in editing mode, only show return.
    
    [self.colorEnableSwitch setOn:self.theJob.jobOnIconColorOn.intValue];
//    [self setUpUndoManager];
    
    // default value configure
    if (self.viewMode == PCVC_ADDING_MODE)
        [self defaultValueConfigure];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cancelButton = nil;
    // Release any retained subviews of the main view.
//    [self cleanUpunDoManager];
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self setEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index <= 2) {
        return  0;
    } else {
        return  1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"Name and Icon", "name and icon title");
    else if (section == 1)
        return  NSLocalizedString(@"Shift Detail", "Shift detail title");
    else if (section == 2)
        return NSLocalizedString(@"Time and Remind", "time and remind title");
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
#if 0
        return  self.editing ? 3 : 1;
#else
        return 3;
#endif
    else if (section == 1)
        return [self.itemsArray count] - 3;
    else if (section == 2)
        return self.timeItemsArray.count;
    
    return 0;
}

- (NSString *) returnItemByIndexPath: (NSIndexPath *)indexPath
{
    NSString *item;
    if (indexPath.section == 0)
        item = [self.itemsArray objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        item = [self.itemsArray objectAtIndex:(indexPath.row + 3)];
    else if (indexPath.section == 2)
        item = [self.timeItemsArray objectAtIndex:indexPath.row];
    return item;
}

- (void) defaultValueConfigure
{
        self.theJob.jobOnDays = [NSNumber numberWithInt:PCVC_DEFAULT_ON_DAYS];
        self.theJob.jobOffDays = [NSNumber numberWithInt:PCVC_DEFAULT_OFF_DAYS];
        self.theJob.jobStartDate = [NSDate date];
        NSDateComponents *defaultOnTime = [[NSDateComponents alloc] init];
        [defaultOnTime setHour:8];
        [defaultOnTime setMinute:0];
        self.theJob.jobEverydayStartTime =  [[NSCalendar currentCalendar] dateFromComponents:defaultOnTime];
        self.theJob.jobEveryDayLengthSec = [NSNumber numberWithInt:60 * 60 * 8]; // 8 hour a day default
        self.theJob.jobRemindBeforeOff = [NSNumber numberWithInt:0];
        self.theJob.jobRemindBeforeWork = [NSNumber numberWithInt:10];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProfileCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell;
    //    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    } else {
    //        [cell prepareForReuse];
    //    }
    

    
    // setup cell text by index path
    NSString *item;
    item =  [self returnItemByIndexPath:indexPath];
    cell.textLabel.text = item;
    cell.imageView.image = nil;
    
   
    // the default value should configure when ViewWas loaded.
    
//    if ([item isEqualToString:COLOR_ENABLE_STRING]) {
//        [cell.contentView addSubview:self.colorEnableSwitch];
//    }
    
    if ([item isEqualToString:NAME_ITEM_STRING]) {
        cell.imageView.image = self.theJob.iconImage;
        
        self.nameField.delegate = self;
        [self.nameField setText:self.theJob.jobName];
        [cell.contentView addSubview:self.nameField];

    } else if ([item isEqualToString:WORKLEN_ITEM_STRING]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [self.theJob.jobOnDays intValue]];
    } else if ([item isEqualToString:RESTLEN_ITEM_STRING]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [self.theJob.jobOffDays intValue]];
        
    } else if ([item isEqualToString:STARTWITH_ITEM_STRING]) {
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.theJob.jobStartDate];
    }
    
    if ([item isEqualToString:FROM_ITEM_STRING]
        || [item isEqualToString:HOURS_ITEM_STRING]
        || [item isEqualToString:REMIND_BEFORE_WORK]
        || [item isEqualToString:REMIND_BEFORE_CLOCK_OFF])
    {
        [SSProfileTimeAndAlarmVC configureTimeCell:cell indexPath:indexPath Job:self.theJob];
    }

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0 && indexPath.row == 0) // can't edit name ?
        return NO; 
    return YES;

}

#pragma mark - Table view delegate

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];

    if (!editing)
    {
        NSError *error;
        [self.managedObjectContext save:&error];
        [self.nameField resignFirstResponder];
    }
    
    // hide the color picker and icon picker.


#if 0 // will crash if retrun from other view, disable it.
        NSArray *a = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0], nil];
    
    if (editing) {
        showColorAndIconPicker = YES;
        [self.tableView insertRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else {
        showColorAndIconPicker = NO;
        [self.tableView deleteRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationAutomatic];
        // index paths for icon picker and color picker.
    } 
#endif
    
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewMode == PCVC_ADDING_MODE)
        return indexPath;
    return (self.editing) ? indexPath : nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *item = [self returnItemByIndexPath:indexPath];

    if ([self.nameField isFirstResponder]) { // release, in case other need ui.
        [self.nameField resignFirstResponder];
    }
            
    if ([item isEqualToString:NAME_ITEM_STRING]) {
        [self.nameField becomeFirstResponder];
    }
    
    if ([item isEqualToString:ICON_ITEM_STRING]) {
        JPImagePickerController *imagePickerController = [[JPImagePickerController alloc] init];
		
		imagePickerController.delegate = self;
		imagePickerController.dataSource = self.iconDateSource;
		imagePickerController.imagePickerTitle = NSLocalizedString(@"Choose Icon", "title of choose icon view");
        imagePickerController.monoColor = [self.theJob iconColor];
        imagePickerController.monoProcessAllImage = YES;
		
		[self.navigationController presentModalViewController:imagePickerController animated:YES];
    }
    
    if ([item isEqualToString:COLOR_PICKER_STRING]) {
        InfColorPickerController* color_picker = [ InfColorPickerController colorPickerViewController];
        color_picker.delegate = self;
        UIColor *color = self.theJob.iconColor;
        if (color != nil)
            color_picker.sourceColor = self.theJob.iconColor;

        [color_picker presentModallyOverViewController:self];
    }
    
    
    if ([item isEqualToString:WORKLEN_ITEM_STRING]
	|| [item isEqualToString:RESTLEN_ITEM_STRING]
	|| [item isEqualToString:STARTWITH_ITEM_STRING]) 
	{
	    SSTurnShiftTVC *tstvc = [[SSTurnShiftTVC alloc] initWithNibName:@"SSTurnShiftTVC" bundle:nil];
        tstvc.theJob = self.theJob;
        [self.navigationController pushViewController:tstvc animated:YES];
	}

    if ([item isEqualToString:FROM_ITEM_STRING]
	|| [item isEqualToString:HOURS_ITEM_STRING]
	|| [item isEqualToString:REMIND_BEFORE_WORK]
	|| [item isEqualToString:REMIND_BEFORE_CLOCK_OFF])
	{
	    SSProfileTimeAndAlarmVC *taavc = [[SSProfileTimeAndAlarmVC alloc]
						 initWithNibName:@"SSProfileTimeAndAlarmVC" bundle:nil];
	    taavc.theJob = self.theJob;
        [self.navigationController pushViewController:taavc animated:YES];
	}
		 
	       

    
}

- (IBAction)jobNameEditingDone:(id)sender
{
    [self.tableView reloadData];
}

- (void)saveProfile:(id) sender
{
    if (self.theJob.jobName == nil || self.theJob.jobName.length == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Input Job Name", "alart title in editing profile view")
				     message:NSLocalizedString(@"Please input Job Name", "alert string in editing profile view to let user input job name")
				    delegate:self
			   cancelButtonTitle:NSLocalizedString(@"I Know", @"I Know") otherButtonTitles:nil, nil] show];
        return;
    }
    NSError *error = nil;
    if (self.theJob.jobStartDate == nil) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"incomplete input", "alart title start profile view")
                                    message:NSLocalizedString(@"Please choose start date", "alert string in editing profile view let user choose start date")
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"I Know", @"I Know") otherButtonTitles:nil, nil] show];
        return;
    }
        
    
    [self.profileDelegate didChangeProfile:self didFinishWithSave:YES];
    [self.managedObjectContext save:&error];

    if (error != nil) {
        NSLog(@"save error happens when save profile: %@", [error userInfo]);
    }
    [self.navigationController popViewControllerAnimated:YES];
    // NSLog(@"have new profile %@", job.jobName);
}

- (IBAction)cancel:(id)sender {
    [self.profileDelegate didChangeProfile:self didFinishWithSave:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark - ColorPicker

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) color_picker
{
	self.theJob.jobOnColorID = [color_picker.resultColor hexStringFromColor];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma - mark - JPImage Picker Delegate

- (void)imagePicker:(JPImagePickerController *)picker didFinishPickingWithImageNumber:(NSInteger)imageNumber
{

    // only store last path component
    self.theJob.jobOnIconID = [[self.iconDateSource.iconList objectAtIndex:imageNumber] lastPathComponent];
    NSLog(@"choose icon :%@",self.theJob.jobOnIconID);
    
    [self.tableView reloadData];
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerDidCancel:(JPImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];   
}

@end
