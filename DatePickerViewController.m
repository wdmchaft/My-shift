//
//  DatePickerViewController.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"

@implementation DatePickerViewController

@synthesize dateNameList, resultList, datePicker, typeList, dateFormatter, placeholderStringList, delegateToDatePicker;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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


- (id)initWithDateNameList: (NSArray *) nameArray withTypeList:(NSArray *) ptypeList; 
{
    self = [self initWithNibName:@"DatePickerViewController" bundle:nil];
    self.dateNameList = nameArray;
    self.typeList = ptypeList;
    
    self.resultList = [[NSMutableArray alloc] initWithObjects:nil count:dateNameList.count];
    return self;
}

- (void) cancelBarButtonClicked 
{
    [self.delegateToDatePicker DatePickerController:self finishDatePicker:NO withResults:nil withAlert:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doneBarButtonClicked
{
    UIAlertView *alert = [UIAlertView alloc];
        
    if ([self.delegateToDatePicker DatePickerController:self finishDatePicker:YES withResults:self.resultList withAlert:alert] == NO) {
            // result is not acceptable
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonClicked)];
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
    return dateNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [dateNameList objectAtIndex:indexPath.row];
    NSDate *d;
    if (self.resultList.count > indexPath.row)  {
        d = [resultList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:d];
        cell.detailTextLabel.alpha = 1;
    } else {
        if (self.placeholderStringList.count > indexPath.row) {
            cell.detailTextLabel.text = [self.placeholderStringList objectAtIndex:indexPath.row];
            cell.detailTextLabel.alpha = 0.3;
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.resultList objectAtIndex:indexPath.row] != nil)
        [self.datePicker setDate:[self.resultList objectAtIndex:indexPath.row] animated:YES];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    UIDatePicker *picker = sender;
    NSDate *d = picker.date;
    
    [self.resultList replaceObjectAtIndex:[self.tableView indexPathForSelectedRow].row withObject:d];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.tableView indexPathForSelectedRow]] 
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
