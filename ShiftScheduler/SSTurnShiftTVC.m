//
//  SSTurnShiftTVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSTurnShiftTVC.h"
#import "SCViewController.h"
#import "SCModalPickerView.h"

@interface SSTurnShiftTVC()
{
    UIPickerView *picker;
    UIDatePicker *datePicker;
    NSArray *itemsArray;
    NSDateFormatter *dateFormatter;
    NSIndexPath *firstChooseIndexPath; // the indexPath use choose when enter this UI.

    SCModalPickerView *modalPickerView;
    SCModalPickerView *modalDatePickerView;
    OneJob *theJob;
}

@end

@implementation SSTurnShiftTVC

@synthesize picker, theJob, firstChooseIndexPath;

#define WORKLEN_ITEM_STRING   NSLocalizedString(@"Work Length", "how long work days")
#define RESTLEN_ITEM_STRING   NSLocalizedString(@"Rest Length", "how long rest days")

enum {
    WORKLEN_ITEM = 0,
    RESETLEN_ITEM,
};

+ (NSArray *) returnItemsArray
{
    return  [[NSArray alloc] initWithObjects:
             WORKLEN_ITEM_STRING,
             RESTLEN_ITEM_STRING,
             nil];
}

- (NSArray *) itemsArray
{
    if (!itemsArray) {
        itemsArray = [[self class] returnItemsArray];
    }
    return itemsArray;
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

+ (BOOL) isItemInThisViewController: (NSString *) item
{
    for (id i  in [SSTurnShiftTVC returnItemsArray]) {
        if ([i isKindOfClass: [NSString class]]) {
            NSString *str = i;
            if ([str isEqualToString:item])
                return YES;
        }
            
    }
    return NO;
}

#pragma mark - View lifecycle



- (void) showUserChoosenSection
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.firstChooseIndexPath.row inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.firstChooseIndexPath.row inSection:0]];
}


- (void) showFirstSection
{
///    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.allowsSelectionDuringEditing = YES;
    picker.delegate = self;
    picker.dataSource = self;
    modalPickerView = [[SCModalPickerView alloc] init];
    
    self.title = self.theJob.jobShiftTypeString;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.picker = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.editing = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // [self showUserChoosenSection];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self itemsArray].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        NSString *descrption = [NSString stringWithFormat:@"%@ \n%@",
                                NSLocalizedString(@"You can change the shift days by click each item\n", "tips"),
                                 NSLocalizedString(@"___HELP___", "help")];
        return descrption;
    }
    return  [NSString string] ;
    
}

- (NSString *)returnItemByIndexPath: (NSIndexPath *)indexPath
{
    NSString *item;
    item = [self.itemsArray objectAtIndex:indexPath.row];
    return item;
}

+ (void) configureTimeCell: (UITableViewCell *)cell indexPath: (NSIndexPath *)indexPath Job: (OneJob *)theJob dateFormatter:(NSDateFormatter *)dateFormatter
{
    if (indexPath.row == WORKLEN_ITEM)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [theJob.jobOnDays intValue]];
    else if (indexPath.row == RESETLEN_ITEM)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [theJob.jobOffDays intValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForTurnShiftTVC";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    NSString *item;
    item =  [self returnItemByIndexPath:indexPath];
    cell.textLabel.text = item;
    
    [SSTurnShiftTVC configureTimeCell:cell indexPath:indexPath Job:self.theJob dateFormatter:self.dateFormatter];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Shift Detail", "Shift detail title");
}

#pragma mark - Table view delegate

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];

    if (!editing)
    {
        [self.navigationController popViewControllerAnimated:animate];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void) showPickerView:(UIPickerView *)pPickerView
{
    //__block UIPickerView *tPickerView = pPickerView;
    [modalPickerView setPickerView:pPickerView];
    __block OneJob *job = self.theJob;
    NSIndexPath *pChoosedIndexPath = [self.tableView indexPathForSelectedRow];
    __block UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:pChoosedIndexPath];

    [modalPickerView setCompletionHandler:^(SCModalPickerViewResult result){
        if (result == SCModalPickerViewResultDone)
        { 
            int value = [pPickerView selectedRowInComponent:0] + 1;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", value];
            [cell setSelected:YES];

            if (pPickerView.tag == WORKLEN_ITEM) // on day
                job.jobOnDays = [NSNumber numberWithInt:value];
            
            if (pPickerView.tag == RESETLEN_ITEM) //off day
                job.jobOffDays = [NSNumber numberWithInt:value];
        }
    }];
    
    [modalPickerView show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *item = [self returnItemByIndexPath:indexPath];

    if ([item isEqualToString:WORKLEN_ITEM_STRING] || [item isEqualToString:RESTLEN_ITEM_STRING]) {
        NSInteger n  =  [targetCell.detailTextLabel.text intValue];
        [self.picker selectRow:(n - 1) inComponent:0 animated:YES];
        self.picker.tag = 
        ([item isEqualToString:WORKLEN_ITEM_STRING])  ? WORKLEN_ITEM : RESETLEN_ITEM;
        [self showPickerView:self.picker];
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
    return 46;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
