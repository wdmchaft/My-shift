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
#import "SSProfileReminderDateSource.h"

enum {
    CLOCK_IN_ITEM = 0,
    HOURS_ITEM,
    REMIND_BEFORE_WORK_ITEM,
    REMIND_BEFORE_OFF_ITEM,
};

#define PICKER_VIEW_BEFORE_WORK 2
#define PICKER_VIEW_BEFORE_OFF 3

@implementation SSProfileTimeAndAlarmVC

@synthesize dateFormatter, theJob, datePicker, picker, firstChooseIndexPath;

+ (NSArray *) returnItemArray {
    return [[NSArray alloc] initWithObjects:
            FROM_ITEM_STRING,
            HOURS_ITEM_STRING,
            REMIND_BEFORE_WORK,
            REMIND_BEFORE_CLOCK_OFF,
            nil];
}

//- (UIPickerView *) picker
//{
//    if (picker == nil) {
//        picker = [[UIPickerView alloc] init];
//        SSProfileReminderDateSource *dateSource = [[SSProfileReminderDateSource alloc] init];
//        picker.dataSource = dateSource;
//    }
//    return picker;
//}

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
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    return dateFormatter;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.timeZone = [NSTimeZone defaultTimeZone];
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 200.0f, 320.0f, 216.0f)];
        self.picker.showsSelectionIndicator = YES;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        [self.picker reloadAllComponents];
        
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

    
//
//    
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

+ (NSString *)jobWorkHourCellStringwithJob: (OneJob *)theJob
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##0.#"];
    float a = theJob.jobEveryDayLengthSec.floatValue / (60.f * 60.f);
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.timeStyle = NSDateFormatterShortStyle;
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:a]];
    
    NSString *dateString = [theJob jobEverydayOffTimeWithFormatter:dateformatter];
    NSString *resultString = [NSString stringWithFormat:@"%@ %@ (%@)", 
                               formattedNumberString,
                               NSLocalizedString(@"Hours", "hours"),
                               dateString];
    return resultString;
}

+ (void) configureTimeCell: (UITableViewCell *)cell indexPath: (NSIndexPath *)indexPath Job: (OneJob *)theJob
{
    
    if (indexPath.row == CLOCK_IN_ITEM) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:theJob.jobEverydayStartTime];
    } else if (indexPath.row == HOURS_ITEM) {
        cell.detailTextLabel.text = [SSProfileTimeAndAlarmVC jobWorkHourCellStringwithJob:theJob];
    } else if (indexPath.row == REMIND_BEFORE_WORK_ITEM) {
        cell.detailTextLabel.text = [SSProfileTimeAndAlarmVC convertTimeIntervalToString:theJob.jobRemindBeforeWork];
        //        cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 0];
    } else if (indexPath.row == REMIND_BEFORE_OFF_ITEM) {
        cell.detailTextLabel.text = [SSProfileTimeAndAlarmVC convertTimeIntervalToString:theJob.jobRemindBeforeOff];
        //        cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 0];
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

- (void) showPickerView:(UIPickerView *)pPickerView
{
    __block UIPickerView *tPickerView = pPickerView;
    SCModalPickerView *modalPickerView  = [[SCModalPickerView alloc] init];
    [modalPickerView setPickerView:tPickerView];
    __block OneJob *job = self.theJob;
    __block NSIndexPath *pChoosedIndexPath = [self.tableView indexPathForSelectedRow];
    //__block UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:pChoosedIndexPath];
    //b__block NSArray *premindItemsArray = self.remindItemsArray;
    __block SSProfileTimeAndAlarmVC *safeSelf = self;
    [modalPickerView setCompletionHandler:^(SCModalPickerViewResult result){
        if (result == SCModalPickerViewResultDone)
        { 
            NSTimeInterval i = [SSProfileTimeAndAlarmVC convertRemindItemToTimeInterval:[tPickerView selectedRowInComponent:0]];
            if (pChoosedIndexPath.row == PICKER_VIEW_BEFORE_WORK) {
                job.jobRemindBeforeWork = [NSNumber numberWithInt:i];
            } else if (pChoosedIndexPath.row == PICKER_VIEW_BEFORE_OFF) {
                job.jobRemindBeforeOff = [NSNumber numberWithInt:i];
            }
            [safeSelf.tableView reloadData];
        }
    }];
    
    [modalPickerView show];
}

- (void) showDatePickerView:(UIDatePicker *)pdatePicker
{
    __block UIDatePicker *tdatePicker = pdatePicker;
    
    SCModalPickerView *modalPickerView = [[SCModalPickerView alloc] init];
    [modalPickerView setPickerView:tdatePicker];
    __block OneJob *job = self.theJob;
    
    NSIndexPath *pChoosedIndexPath = [self.tableView indexPathForSelectedRow];
    __block NSDateFormatter *pDateFormatter = self.dateFormatter;
    __block SSProfileTimeAndAlarmVC *safeSelf = self;
    [modalPickerView setCompletionHandler:^(SCModalPickerViewResult result){
        if (result == SCModalPickerViewResultDone)
        { 
            if (pChoosedIndexPath.row == CLOCK_IN_ITEM) {
                job.jobEverydayStartTime = tdatePicker.date;
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
        self.datePicker.date = self.theJob.jobEverydayStartTime;
        [self showDatePickerView:self.datePicker];
    } else if (indexPath.row == HOURS_ITEM) {
        self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        self.datePicker.minuteInterval = 10;
        self.datePicker.countDownDuration = [self.theJob.jobEveryDayLengthSec intValue];
        [self showDatePickerView:self.datePicker];
    } else if (indexPath.row == REMIND_BEFORE_WORK_ITEM) {
        NSTimeInterval i = [self.theJob.jobRemindBeforeWork doubleValue];
        int row = [SSProfileTimeAndAlarmVC convertTimeIntervalToRemindItem:i];
        [self.picker selectRow:row inComponent:0 animated:YES];
        [self showPickerView:self.picker];
    } else if (indexPath.row == REMIND_BEFORE_OFF_ITEM) {
        NSTimeInterval i = [self.theJob.jobRemindBeforeOff doubleValue];
        int row = [SSProfileTimeAndAlarmVC convertTimeIntervalToRemindItem:i];
        [self.picker selectRow:row inComponent:0 animated:YES];
        [self showPickerView:self.picker];
    }
}

#pragma mark - PickerView Data Source

// the event should be: NO, Just happen, 5 Minutes, 15 Minutes, 30 Minutes, 1 Hour, 2 Hours,

+ (NSDictionary *) returnRemindDict
{
    NSArray *objectArray = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:-1],
                            [NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:5 * 60],
                            [NSNumber numberWithInt:15 * 60],
                            [NSNumber numberWithInt:30 * 60],
                            [NSNumber numberWithInt:60 * 60],
                            [NSNumber numberWithInt:2 *60 * 60],
                            nil];
    NSArray *keysArray = [NSArray arrayWithObjects: [NSNumber numberWithInt:REMIND_NO_ITEM],
                          [NSNumber numberWithInt:REMIND_JUST_HAPPEN_ITEM],
                          [NSNumber numberWithInt:REMIND_5_MIN_ITEM],
                          [NSNumber numberWithInt:REMIND_15_MIN_ITEM],
                          [NSNumber numberWithInt:REMIND_30_MIN_ITEM],
                          [NSNumber numberWithInt:REMIND_1_HOUR_ITEM],
                          [NSNumber numberWithInt:REMIND_2_HOUR_ITEM],
                          nil];
    return [[NSDictionary alloc] initWithObjects:objectArray forKeys:keysArray];
}

+ (NSTimeInterval) convertRemindItemToTimeInterval:(int) item
{
    return [[[SSProfileTimeAndAlarmVC returnRemindDict] objectForKey:[NSNumber numberWithInt:item]] intValue];
}

+ (int) convertTimeIntervalToRemindItem: (NSTimeInterval) time
{
    return [[[[SSProfileTimeAndAlarmVC returnRemindDict] allKeysForObject:[NSNumber numberWithInt:time]] lastObject] intValue];
}

+ (NSArray *) returnRemindItemArray
{
    return [[NSArray alloc] initWithObjects:
    REMIND_NO_ITEM_STR,
    REMIND_JUST_HAPPEN_ITEM_STR,
    REMIND_5_MIN_ITEM_STR,
    REMIND_15_MIN_ITEM_STR,
    REMIND_30_MIN_ITEM_STR,
    REMIND_1_HOUR_ITEM_STR,
    REMIND_2_HOUR_ITEM_STR, 
    nil];

}

+ (NSString *) convertTimeIntervalToString: (NSNumber *) time
{
    return [[SSProfileTimeAndAlarmVC returnRemindItemArray] objectAtIndex: 
            [SSProfileTimeAndAlarmVC convertTimeIntervalToRemindItem:[time intValue]]];
}

- (NSArray *) remindItemsArray
{
    if (remindItemsArray == nil) {
        remindItemsArray = [SSProfileTimeAndAlarmVC returnRemindItemArray];	    
    }
    return remindItemsArray;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
	
    // note: custom picker doesn't care about titles, it uses custom views
    // don't return 0
    returnStr = [remindItemsArray objectAtIndex:row];
    
    return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 180;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.remindItemsArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}




@end
