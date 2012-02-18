//
//  SSTurnShiftTVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSTurnShiftTVC.h"

@implementation SSTurnShiftTVC

@synthesize datePicker, picker, theJob;

#define WORKLEN_ITEM_STRING NSLocalizedString(@"Work Length", "how long work days")
#define RESTLEN_ITEM_STRING NSLocalizedString(@"Rest Length", "how long rest days")
#define STARTWITH_ITEM_STRING NSLocalizedString(@"Start With", "start with this date")

- (NSArray *) itemsArray
{
    if (!itemsArray) {
        itemsArray = [[NSArray alloc] initWithObjects:
				      WORKLEN_ITEM_STRING,
				      RESTLEN_ITEM_STRING,
				      STARTWITH_ITEM_STRING ,
				      nil];
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

#pragma mark - View lifecycle

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
    self.editing = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        [self showFirstSection];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (NSString *) returnItemByIndexPath: (NSIndexPath *)indexPath
{
    NSString *item;
    item = [self.itemsArray objectAtIndex:indexPath.row];
    return item;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForTurnShiftTVC";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell...
    NSString *item;
    item =  [self returnItemByIndexPath:indexPath];
    cell.textLabel.text = item;

    if ([item isEqualToString:WORKLEN_ITEM_STRING]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [self.theJob.jobOnDays intValue]];
    } else if ([item isEqualToString:RESTLEN_ITEM_STRING]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%2d", [self.theJob.jobOffDays intValue]];
        
    } else if ([item isEqualToString:STARTWITH_ITEM_STRING]) {
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.theJob.jobStartDate];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Shift Detail", "Shift detail title");
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];

    if (!editing)
    {
        [self.datePicker removeFromSuperview];
        [self.picker removeFromSuperview];
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

- (void)showOrHidePickerView:(BOOL) show
{
    if (show) {
        if (self.picker.superview == nil) {
            CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height - 60,
                                           pickerSize.width,
                                           pickerSize.height);
            
            self.picker.frame = pickerRect;
            self.picker.hidden = NO;
            [self.view.superview addSubview: self.picker];
        }
    } else {
        [self.picker removeFromSuperview];
    }
}

+ (void) showOrHideDatePickerView: (BOOL) show datePicker:(UIDatePicker *)datePicker view:(UIView *)theView
{
    if (show) {
        if (datePicker.superview == nil) {
            CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height - 60,
                                           pickerSize.width,
                                           pickerSize.height);
            
            datePicker.frame = pickerRect;
            [theView.superview addSubview: datePicker];
        }
    } else {
        [datePicker removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *item = [self returnItemByIndexPath:indexPath];

    if ([item isEqualToString:WORKLEN_ITEM_STRING] || [item isEqualToString:RESTLEN_ITEM_STRING]) {
        lastChoosePicker = indexPath.row;
        [self.datePicker removeFromSuperview];
        [self showOrHidePickerView:YES];
        NSInteger n  =  [targetCell.detailTextLabel.text intValue];
        // since picker already +1 to the row number;
        [self.picker selectRow:n-1 inComponent:0 animated:YES];
    } else
        [self showOrHidePickerView:NO];

    if ([item isEqualToString:STARTWITH_ITEM_STRING]) {
        [self showOrHidePickerView:NO];
        self.datePicker.date = self.theJob.jobStartDate;
        [[self class ] showOrHideDatePickerView:YES datePicker:self.datePicker view:self.view];
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

    if (indexPath.row == PICKER_VIEW_ON) // on day
        self.theJob.jobOnDays = [NSNumber numberWithInt:value];
    
    if (indexPath.row == PICKER_VIEW_OFF) //off day
        self.theJob.jobOffDays = [NSNumber numberWithInt:value];
}


@end
