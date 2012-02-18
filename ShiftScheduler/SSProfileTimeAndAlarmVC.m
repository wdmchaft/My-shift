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

@synthesize dateFormatter, theJob, datePicker, firstChooseIndexPath;


+ (NSArray *) returnItemArray {
    return [[NSArray alloc] initWithObjects:
            FROM_ITEM_STRING,
            HOURS_ITEM_STRING,
            REMIND_BEFORE_WORK,
            REMIND_BEFORE_CLOCK_OFF,
            nil];
}

- (NSArray *) itemsArray
{
    if (!itemsArray) {
        itemsArray = [[self class] returnItemArray];
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

+ (BOOL) isItemInThisViewController: (NSString *) item
{
    for (id i  in [SSProfileTimeAndAlarmVC returnItemArray]) {
        if ([i isKindOfClass: [NSString class]]) {
            NSString *str = i;
            if ([str isEqualToString:item])
                return YES;
        }
        
    }
    return NO;
}

- (void) showUserChoosenSection
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.firstChooseIndexPath.row inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.firstChooseIndexPath.row inSection:0]];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    modalPickerView = [[SCModalPickerView alloc] init];
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
    [self showUserChoosenSection];
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

#pragma mark - Table view delegate

- (void) showDatePickerView:(UIDatePicker *)pdatePicker
{
    __block UIDatePicker *tdatePicker = pdatePicker;
    
    [modalPickerView setPickerView:tdatePicker];
    __block OneJob *job = self.theJob;
    
    NSIndexPath *pChoosedIndexPath = [self.tableView indexPathForSelectedRow];
    __block NSDateFormatter *pDateFormatter = self.dateFormatter;
    __block SSProfileTimeAndAlarmVC *safeSelf = self;
    [modalPickerView setCompletionHandler:^(SCModalPickerViewResult result){
        if (result == SCModalPickerViewResultDone)
        { 
            if (pChoosedIndexPath.row == CLOCK_IN_ITEM) {
                job.jobEverydayStartTime = [[tdatePicker date] cc_convertToUTC];
                NSLog(@"start time every date:%@ with Job:%@", [pDateFormatter stringFromDate:job.jobEverydayStartTime], job.jobName);
            } else if (pChoosedIndexPath.row == HOURS_ITEM) {
                job.jobEveryDayLengthSec =  [NSNumber numberWithInt:tdatePicker.countDownDuration];
                NSLog(@"work every length:%@ with Job:%@", job.jobEveryDayLengthSec, job.jobName);
            }
            
            [safeSelf.tableView reloadData];
        }
    }];
    [modalPickerView show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == CLOCK_IN_ITEM) {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        lastChooseCell = indexPath.row;
        self.datePicker.date = self.theJob.jobEverydayStartTime;
        [self showDatePickerView:self.datePicker];

    } else if (indexPath.row == HOURS_ITEM) {
        self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        self.datePicker.countDownDuration = [self.theJob.jobEveryDayLengthSec intValue];
        lastChooseCell = indexPath.row;
        [self showDatePickerView:self.datePicker];
    } else if (indexPath.row == REMIND_BEFORE_WORK_ITEM) {
        
    } else if (indexPath.row == REMIND_BEFORE_OFF_ITEM) {
        
    }
}
@end
