//
//  ShiftChangeAddVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShiftChangeAddVC.h"
#import "ShfitChangeList.h"

@implementation ShiftChangeAddVC

@synthesize changeShiftSegmentControl, managedObjectContext, listDelegate, theShiftChange;

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

#define CHANGE_SHIFT_TYPE_EXCHANGE NSLocalizedString(@"Exchange", "exchange type in shift change")
#define CHANGE_SHIFT_TYPE_OVERWORK NSLocalizedString(@"Overwork", "overwork type in shift change")
#define CHANGE_SHIFT_TYPE_VACATION NSLocalizedString(@"Vacation", "vacation type in shift change")

#define TYPE_EXCAHNGE 0
#define TYPE_OVERWORK 1
#define TYPE_VACATION 2

- (UISegmentedControl *)changeShiftSegmentControl
{
    if (changeShiftSegmentControl)
        return changeShiftSegmentControl;
    NSArray *changeShiftTypes = [[NSArray alloc] initWithObjects:
                                 CHANGE_SHIFT_TYPE_EXCHANGE,
                                 CHANGE_SHIFT_TYPE_OVERWORK,
                                 CHANGE_SHIFT_TYPE_VACATION, nil];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:changeShiftTypes];
    control.selectedSegmentIndex = 0;
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    [control addTarget:self action:@selector(shiftTypeChanged:) 
      forControlEvents:UIControlEventValueChanged];
    changeShiftSegmentControl = control;
    return changeShiftSegmentControl;
}

- (void)shiftTypeChanged: (UISegmentedControl *) sender
{
    // shift change type changed.
    self.theShiftChange.type = [NSNumber numberWithInt:sender.selectedSegmentIndex];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.titleView = self.changeShiftSegmentControl;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
    NSArray *a = [NSArray arrayWithObjects:cancelButton, flexItem, saveButton,nil];
    [self setToolbarItems:a];
    
    self.theShiftChange = [NSEntityDescription insertNewObjectForEntityForName:@"ShiftDay" inManagedObjectContext:self.managedObjectContext];
}

- (void)cancelButtonClicked
{
    [listDelegate didChangeShift:self didFinishWithSave:NO];
}

- (void)doneButtonClicked
{
    [listDelegate didChangeShift:self didFinishWithSave:YES];
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
        //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

    // 3 Sections, 
    //   - Which Shift ?
    //   - Which Date ?
    //   - Notes

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0 && section == 2)
        return 1;
    if (section == 1 && theShiftChange.type == TYPE_EXCAHNGE)
        return 2;
    else
        return 1;
    
    NSLog(@"warnning, return in a no possible case");
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
