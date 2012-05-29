//
//  FreeJumpProfileConfigTVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FreeJumpProfileConfigTVC.h"
#import "SCViewController.h"
#import "SCModalPickerView.h"


@interface FreeJumpProfileConfigTVC ()
{
    OneJob *job_;
    SCModalPickerView *modalPickerView;
    UIPickerView *picker;

    NSMutableArray *shiftStateArray;
}

@end

@implementation FreeJumpProfileConfigTVC

@synthesize theJob=job_;


#define LENGTH_OF_CYCLE NSLocalizedString(@"Cycle length", "length of cycle")
#define CHOOSE_ON_OFF_DAY NSLocalizedString(@"Choose On/Off Days", "choose on/off days")



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

    shiftStateArray = [[NSMutableArray alloc] initWithCapacity:100];
    
    for (int i = 0; i < 100; i++) {
        [shiftStateArray addObject:[NSNumber numberWithBool:0]];
    }
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
  
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;



    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 250, 325, 250)];
    
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerSize.height - 65, pickerSize.width, pickerSize.height);
    picker.frame = pickerRect;

    picker.hidden = NO;
    picker.delegate = self;
    picker.dataSource = self;
    modalPickerView = [[SCModalPickerView alloc] init];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 2;
    else if (section == 1)
        return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FreeJumpCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

            cell.textLabel.text = LENGTH_OF_CYCLE;
            cell.detailTextLabel.text = (self.theJob.jobFreeJumpCycle == nil) ? @"No Cycle" : ([NSString stringWithFormat:@"%@", self.theJob.jobFreeJumpCycle]);
        }
        else if (indexPath.row == 1)
            cell.textLabel.text = CHOOSE_ON_OFF_DAY;
    }

    if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
        cell.detailTextLabel.text = 0;
        
        if ([self checkShiftDayState:indexPath.row])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

/*
// Override to support editing the table view.
if (- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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

- (BOOL) checkShiftDayState: (int) index
{
    int v = [[shiftStateArray objectAtIndex:index] intValue];
    return v;
}

- (void) toggleShiftDayState: (int) index
{
    int v = [[shiftStateArray objectAtIndex:index] intValue];
    v = (v == 0)  ? 1 : 0;
    [shiftStateArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:v]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self showPickerView:picker];
        }
    }
    
    else if (indexPath.section == 1) {
        [self toggleShiftDayState:indexPath.row];
    }
    
    [self.tableView reloadData];
        
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

                    job.jobFreeJumpCycle = [NSNumber numberWithInt:value];
            
                }
        }];
    
    [modalPickerView show];
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
    
    componentWidth = 40.0;      // first column size is wider to hold names
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
