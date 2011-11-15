//
//  ProfileChangeViewController.m
//  WhenWork
//
//  Created by Zhang Jiejing on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProfileChangeViewController.h"

@implementation ProfileChangeViewController

@synthesize datePicker, picker;
@synthesize itemsArray, doneButton, saveButton, dateFormatter;
@synthesize theJob, viewMode;
@synthesize managedObjectContext, profileDelegate;


#pragma mark - "init values"

#define NAME_ITEM_STRING @"Name"
#define WORKLEN_ITEM_STRING @"Work Length"
#define RESTLEN_ITEM_STRING @"Rest Length"
#define STARTWITH_ITEM_STRING @"Start With"

- (NSArray *) itemsArray
{
    
    if (!itemsArray) {
        itemsArray = [[NSArray alloc] initWithObjects:NAME_ITEM_STRING, WORKLEN_ITEM_STRING, RESTLEN_ITEM_STRING, STARTWITH_ITEM_STRING , nil];
    }
    return itemsArray;
}

 - (UIBarButtonItem *)saveButton
{
    if (!saveButton)
        saveButton = [[UIBarButtonItem alloc] 
                      initWithTitle:NSLocalizedString(@"Save", @"save profile") 
                      style:UIBarButtonItemStyleDone target:self action:@selector(saveProfile)];
    return saveButton;
}

- (UIBarButtonItem *) doneButton
{
    if (!doneButton) {

    }
    return doneButton;
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

- (void) dealloc 
{
    [itemsArray release];
    [saveButton release];
    [doneButton release];
    [dateFormatter release];
    [super dealloc];
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
 
    if (self.viewMode == PCVC_ADDING_MODE) {
        self.navigationItem.rightBarButtonItem = self.saveButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    picker.delegate = self;
    picker.dataSource = self;
    
    [self setUpUndoManager];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.picker = nil;
    self.datePicker = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.picker removeFromSuperview];
    [self.datePicker removeFromSuperview];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    NSString *item = [self.itemsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    if ([item isEqualToString:NAME_ITEM_STRING]) {
        if (self.viewMode == PCVC_EDITING_MODE 
            && self.theJob.jobName == nil)
            cell.detailTextLabel.text = @"No Name";
        else
            cell.detailTextLabel.text = self.theJob.jobName;
    } else if ([item isEqualToString:WORKLEN_ITEM_STRING]) {
        if (self.viewMode == PCVC_ADDING_MODE 
            && self.theJob.jobOnDays == [NSNumber numberWithInt:0])  {
            // change default value ony if not changed.
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", PCVC_DEFAULT_ON_DAYS];
            self.theJob.jobOnDays = [NSNumber numberWithInt:PCVC_DEFAULT_ON_DAYS];
        }
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [self.theJob.jobOnDays intValue]];
    } else if ([item isEqualToString:RESTLEN_ITEM_STRING]) {
        if (self.viewMode == PCVC_ADDING_MODE 
            && [self.theJob jobOffDays] == [NSNumber numberWithInt:0]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", PCVC_DEFAULT_OFF_DAYS];
            self.theJob.jobOffDays = [NSNumber numberWithInt:PCVC_DEFAULT_OFF_DAYS];
        } else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [self.theJob.jobOffDays intValue]];
    } else if ([item isEqualToString:STARTWITH_ITEM_STRING]) {
        if (self.viewMode == PCVC_ADDING_MODE) {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            self.theJob.jobStartDate = [NSDate date];
        } else
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.theJob.jobStartDate];
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (self.viewMode == PCVC_ADDING_MODE)
        return NO;

    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewMode == PCVC_ADDING_MODE)
        return indexPath;
    return (self.editing) ? indexPath : nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override tso support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    
    // name
    if (indexPath.row == 0) {
        EditingViewController *evc = [[EditingViewController alloc]initWithNibName:@"EditingView" bundle:nil];
        evc.editedFieldKey = @"jobName";
        evc.editedObject = self.theJob;
        evc.editedFieldName = NSLocalizedString(@"title", @"name of the job");
        evc.editingDate = NO;
        [self.navigationController pushViewController:evc animated:YES];
        [evc release];
    }
    
    if (indexPath.row == PICKER_VIEW_ON || indexPath.row == PICKER_VIEW_OFF) {
        lastChoosePicker = indexPath.row;
        [self.datePicker removeFromSuperview];
        NSInteger n  =  [targetCell.detailTextLabel.text intValue];
        if (self.picker.superview == nil) {
            CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                           pickerSize.width,
                                           pickerSize.height);
            
            self.picker.frame = pickerRect;
            self.picker.hidden = NO;
            [self.view.window addSubview: self.picker];
        }
        // since picker already +1 to the row number;
        [self.picker selectRow:n-1 inComponent:0 animated:YES];
    } else
        [self.picker removeFromSuperview];

    if (indexPath.row == 3) {
        [self.picker removeFromSuperview];
        self.datePicker.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
        
        if (self.datePicker.superview == nil) {
            CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                           pickerSize.width,
                                           pickerSize.height);
            
            self.datePicker.frame = pickerRect;
            [self.view.window addSubview: self.datePicker];
        } else {
            [self.datePicker removeFromSuperview];
        }
	}

}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
	
	// note: custom picker doesn't care about titles, it uses custom views
    // don't return 0
	returnStr = [[NSNumber numberWithInt:(row + 1)] stringValue];
    
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth = 0.0;
    
	componentWidth = 40.0;	// first column size is wider to hold names
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 30;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

#pragma mark - "Date/Number Picker Save events"

- (IBAction)datePickerValueChanged:(id)sender
{
    UIDatePicker *p = sender;
    self.theJob.jobStartDate = p.date;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.theJob.jobStartDate];
    NSLog(@"date changed: %@", [self.dateFormatter stringFromDate:p.date]);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	// If the user chooses a new row, update the label accordingly.
    NSAssert((lastChoosePicker == PICKER_VIEW_ON || lastChoosePicker == PICKER_VIEW_OFF),
             @"last Choose Picker in wrong state!");
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    int value = row + 1;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", value];
    [cell setSelected:YES];

    if (indexPath.row == 1) // on day
        self.theJob.jobOnDays = [NSNumber numberWithInt:value];
    
    if (indexPath.row == 2) //off day
        self.theJob.jobOffDays = [NSNumber numberWithInt:value];
}

- (IBAction)jobNameEditingDone:(id)sender
{
    [self.tableView reloadData];
}

- (void)saveProfile:(id) sender
{
//    OneJob *job = [NSEntityDescription insertNewObjectForEntityForName:@"OneJob" /inManagedObjectContext:self.managedObjectContext];
//    job.jobName = self.theJob.jobName;
//    job.jobOffDays = self.theJob.jobOffDays;
//    job.jobOnDays = self.theJob.jobOnDays;
//    job.jobStartDate = self.theJob.jobStartDate;

    if (self.theJob.jobName == nil || self.theJob.jobName.length == 0) {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Input Job Name", "alart title in editing profile view") message:NSLocalizedString(@"Please input Job Name", "alert string in editing profile view to let user input job name") delegate:self cancelButtonTitle:NSLocalizedString(@"I Know", @"I Know") otherButtonTitles:nil, nil] autorelease] show];
        return;
    }
    NSError *error = nil;
    if (self.theJob.jobStartDate == nil)
        self.theJob.jobStartDate = [NSDate date];
    
    [self.profileDelegate didChangeProfile];
    [self.managedObjectContext save:&error];

    if (error != nil) {
        NSLog(@"save error happens when save profile: %@", [error userInfo]);
    }
    [self.navigationController popViewControllerAnimated:YES];
   // NSLog(@"have new profile %@", job.jobName);
}

@end