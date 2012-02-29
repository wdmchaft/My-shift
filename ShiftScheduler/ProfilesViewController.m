//
//  ProfilesViewController.m
//  
//
//  Created by Zhang Jiejing on 11-10-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProfilesViewController.h"
#import "ProfileChangeViewController.h"
#import "OneJob.h"
#import "UIColor+HexCoding.h"


#define PROFILE_CACHE_INDIFITER @"ProfileListCache"

@implementation ProfilesViewController

@synthesize managedObjectContext, addingManagedObjectContext, fetchedResultsController;
@synthesize parentViewDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithManagedContext:(NSManagedObjectContext *)context
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    self.title = NSLocalizedString(@"Management Shift", "shift management view");
    self.managedObjectContext = context;
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) returnToHome
{
    [self.parentViewDelegate didFinishEditingSetting];
}

- (NSInteger) profileuNumber
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (void)jobSwitchAction:(id) sender
{
    UISwitch *currentSwitch = sender;
    OneJob *j = [self.fetchedResultsController.fetchedObjects objectAtIndex:currentSwitch.tag];
    j.jobEnable = [NSNumber numberWithBool:currentSwitch.isOn];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}


- (IBAction)insertNewProfile:(id) sender
{
    ProfileChangeViewController *addViewController = [[ProfileChangeViewController alloc] initWithNibName:@"ProfileChangeViewController" bundle:nil];
    addViewController.viewMode = PCVC_ADDING_MODE;
	
    // Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    self.addingManagedObjectContext = addingContext;
    [addingManagedObjectContext setPersistentStoreCoordinator:[[self.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    
    addViewController.managedObjectContext = addingContext;
    // use same manage object context can auto update the frc.
    OneJob *job = [NSEntityDescription insertNewObjectForEntityForName:@"OneJob" inManagedObjectContext:addingContext];
    [job forceDefaultSetting];

    addViewController.theJob = job;
    addViewController.profileDelegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self.navigationController presentModalViewController:navController animated:YES];
}

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController 
{
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OneJob" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"jobName"  ascending:YES]];

    request.predicate = nil;
    request.fetchBatchSize = 20;
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] 
                                       initWithFetchRequest:request 
                                       managedObjectContext:self.managedObjectContext
                                       sectionNameKeyPath:nil 
                                       cacheName:Nil];
    fetchedResultsController = frc;
    return frc;
}


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    for (UISwitch *s in switchArray) {
        [s removeFromSuperview];
    }
    [switchArray removeAllObjects];
    
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
    
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
    
    // update all contexts if same change happens, don't change it if editing 
    if (!self.editing)
        [self.tableView reloadData];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
#if 0
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewProfile:)];
    addButton = button;

//    self.navigationItem.rightBarButtonItem = self.editButtonItem;

//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton,
//                                              self.editButtonItem, nil];
    
    if ([self.navigationItem respondsToSelector:@selector(setRightBarButtonItems:)])
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addButton,nil]];
    else
        [self.navigationItem setRightBarButtonItem:addButton];
#else
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
#endif

        //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home", @"return to home in profile view") style:UIBarButtonItemStylePlain target:self action:@selector(returnToHome)];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
    self.fetchedResultsController.delegate = self;
    
    switchArray = [[NSMutableArray alloc] init];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
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
    return [[self.fetchedResultsController sections] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == [self numberOfSectionsInTableView:self.tableView] - 1) { // last section
        return 1;
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.fetchedResultsController.fetchedObjects count] > 0 && section == 0) {
        return NSLocalizedString(@"Management Shift", "");
    }
    return  [NSString string] ;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ([self.fetchedResultsController.fetchedObjects count] > 0 && section == 0) {
        return NSLocalizedString(@"choose to change shift detail", "");
    }
    return  [NSString string] ;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellOfProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    // Configure the cell...
    if (indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1) { // last section
        cell.textLabel.text = NSLocalizedString(@"Adding new shift...", "add new shift");
        cell.textLabel.textColor = [UIColor colorWithHexString:@"283DA0"];
    } else {
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    
    if (indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1) { // last section
        return  NO;
    } else {
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.fetchedResultsController fetchedObjects] count] <= 0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    
    // hide all UISwitch when edting... since it will affect Detete UI.
    for (id a in switchArray) {
        UISwitch *s = a;
        if (editing) { 
            s.hidden = YES;
            [s setNeedsDisplay];
        }
        else s.hidden = NO;
    }
    
    if (!editing) {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1) { // last section
        [self insertNewProfile:nil];
    } else {
        ProfileChangeViewController *pcvc = [[ProfileChangeViewController alloc] initWithNibName:@"ProfileChangeViewController" bundle:nil];
        pcvc.theJob = [self.fetchedResultsController objectAtIndexPath:indexPath];
        pcvc.profileDelegate = self;
        pcvc.managedObjectContext = self.managedObjectContext;
        pcvc.viewMode = PCVC_EDITING_MODE;
        [self.navigationController pushViewController:pcvc animated:YES];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id t = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    if ([t isKindOfClass:[OneJob class]]) {
        OneJob *j = t;
        cell.textLabel.text = j.jobName;
        cell.imageView.image = j.iconImage;
        
        UISwitch *theSwitch;
        CGRect frame = CGRectMake(200, 8.0, 120.0, 27.0);
        theSwitch = [[UISwitch alloc] initWithFrame:frame];
        [theSwitch addTarget:self action:@selector(jobSwitchAction:) forControlEvents:UIControlEventValueChanged];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        theSwitch.backgroundColor = [UIColor clearColor];
        theSwitch.tag = indexPath.row;
        
        //XXX: for complicate the old job data modole.
        if (j.jobEnable == nil)
            j.jobEnable = [NSNumber numberWithInt:1];

        theSwitch.on = j.jobEnable.boolValue;
		
		[theSwitch setAccessibilityLabel:NSLocalizedString(@"Shift Enable Display on Calender", @"")];
        
        [switchArray addObject:theSwitch];
        [cell.contentView addSubview:theSwitch];
        
    }
}

#pragma mark - Profile View Delegete

/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];
	[context save:nil];
    [self.fetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
}



- (void) didChangeProfile :(ProfileChangeViewController *) addController
				didFinishWithSave:(BOOL) finishWithSave
{
    if (finishWithSave) {
	// merge the add context to the main context
    //cache	[NSFetchedResultsController deleteCacheWithName:PROFILE_CACHE_INDIFITER];
// cache delete maybe don't needed, rfc will controller this

	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
	NSError *error;
	if (![addingManagedObjectContext save:&error]) {
	    // Update to handle the error appropriately.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    exit(-1);  // Fail
	}
	[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
    }
    // Release the adding managed object context.
    self.addingManagedObjectContext = nil;

    // Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}



@end


