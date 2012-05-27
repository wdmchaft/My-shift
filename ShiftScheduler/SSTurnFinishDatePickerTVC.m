//
//  SSTurnFinishDatePickerTVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSTurnFinishDatePickerTVC.h"
#import "NSDateAdditions.h"

@interface SSTurnFinishDatePickerTVC ()
{
    NSArray  *items;
    NSDateFormatter *dateFormatter;
    OneJob *job;
}

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end


@implementation SSTurnFinishDatePickerTVC

@synthesize items;
@synthesize dateFormatter;
@synthesize job;


#define REPEAT_ITEM_STRING    NSLocalizedString(@"Repeat Until", "finish at this date")
#define REPEAT_FOREVER_STRING NSLocalizedString(@"Repeat forever", "repeart forever string")

- (NSArray *) items {
    if (items == nil) {
        items = [NSArray arrayWithObjects:
                 REPEAT_ITEM_STRING,
                 REPEAT_FOREVER_STRING,
                 nil];
    }
    return items;
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSAssert(self.job, @"job much be set");
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;

    self.job.jobFinishDate = [self minValildDate];
 }

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 325, 250)];
    
    CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerSize.height - 65, pickerSize.width, pickerSize.height);
    datePicker.frame = pickerRect;
    [self.view addSubview: datePicker];
    
    datePicker.minimumDate = [self minValildDate];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self
		   action:@selector(changeDateInLabel:)
	 forControlEvents:UIControlEventValueChanged];

    datePicker.hidden = NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];

    if (!editing)
	[self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSDate *)minValildDate
{
    NSDate *date = [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.job.jobStartDate];
    
    // min at least 1 day
    //    return [date cc_dateByMovingToNextOrBackwardsFewDays:[self.job shiftTotalCycle].intValue
    //                                      withCalender:[NSCalendar currentCalendar]];
    return [date cc_dateByMovingToNextOrBackwardsFewDays:1 withCalender:[NSCalendar currentCalendar]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = REPEAT_ITEM_STRING;
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.job.jobFinishDate];
    }
    
    if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = REPEAT_FOREVER_STRING;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.job.jobFinishDate = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) changeDateInLabel: (id) sender
{
    UIDatePicker *picker = sender;
    self.job.jobFinishDate = picker.date;
    [self.tableView reloadData];
}

@end
