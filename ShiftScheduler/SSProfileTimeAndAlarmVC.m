//
//  SSProfileTimeAndAlarmVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSProfileTimeAndAlarmVC.h"
#import "NSDateAdditions.h"
#import "SSTurnShiftTVC.h"

enum {
    CLOCK_IN_ITEM = 0,
    HOURS_ITEM,
    REMIND_BEFORE_WORK_ITEM,
    REMIND_BEFORE_OFF_ITEM,
};

@implementation SSProfileTimeAndAlarmVC

@synthesize dateFormatter, theJob, datePicker;

- (NSArray *) itemsArray
{
    if (!itemsArray) {
        itemsArray = [[NSArray alloc] initWithObjects:
					  FROM_ITEM_STRING,
				      HOURS_ITEM_STRING,
				      REMIND_BEFORE_WORK,
				      REMIND_BEFORE_CLOCK_OFF,
				      nil];
    }
    return itemsArray;
}

- (NSDateFormatter *) dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return dateFormatter;
}


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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

+ (void) configureTimeCell: (UITableViewCell *)cell indexPath: (NSIndexPath *)indexPath Job: (OneJob *)theJob
{
    
    if (indexPath.row == CLOCK_IN_ITEM) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:theJob.jobEverydayStartTime];
    } else if (indexPath.row == HOURS_ITEM) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"##0.#"];
        float a = theJob.jobEveryDayLengthSec.floatValue / (60.f * 60.f);
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:a]];
        cell.detailTextLabel.text = formattedNumberString;
    } else if (indexPath.row == REMIND_BEFORE_WORK_ITEM) {
        
    } else if (indexPath.row == REMIND_BEFORE_OFF_ITEM) {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString *item;
    item = [self.itemsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    
    [[self class] configureTimeCell:cell indexPath:indexPath Job:self.theJob];
            
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
// Override to support rearranging the table view.
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
    
    if (indexPath.row == CLOCK_IN_ITEM) {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        lastChooseCell = indexPath.row;
        self.datePicker.date = self.theJob.jobEverydayStartTime;
        [SSTurnShiftTVC showOrHideDatePickerView:YES datePicker:self.datePicker view:self.view];
    } else if (indexPath.row == HOURS_ITEM) {
        self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        self.datePicker.countDownDuration = [self.theJob.jobEveryDayLengthSec intValue];
        lastChooseCell = indexPath.row;
        [SSTurnShiftTVC showOrHideDatePickerView:YES datePicker:self.datePicker view:self.view];
    } else if (indexPath.row == REMIND_BEFORE_WORK_ITEM) {
        
    } else if (indexPath.row == REMIND_BEFORE_OFF_ITEM) {
        
    }
}

- (IBAction)datePickerValueChanged:(id)sender
{
    UIDatePicker *picker = sender;
    if (lastChooseCell == CLOCK_IN_ITEM) {
        self.theJob.jobEverydayStartTime = [[picker date] cc_convertToUTC];
        NSLog(@"start time every date:%@ with Job:%@", [self.dateFormatter stringFromDate:self.theJob.jobEverydayStartTime], self.theJob.jobName);
    } else if (lastChooseCell == HOURS_ITEM) {
        self.theJob.jobEveryDayLengthSec =  [NSNumber numberWithInt:picker.countDownDuration];
        NSLog(@"work every length:%@ with Job:%@", self.theJob.jobEveryDayLengthSec, self.theJob.jobName);
    }
    
    [self.tableView reloadData];
}

@end
