//
//  ShfitChangeList.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShfitChangeList.h"
#import "ShiftDay.h"
#import "ShiftChangeAddVC.h"

@implementation ShfitChangeList

@synthesize managedObjectContext,addingManagedObjectContext,fetchedResultsController, dateFormatter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithManagedContext:(NSManagedObjectContext *)context
{
    self = [super init];
    self.title = NSLocalizedString(@"Shift Changes", "shift changes list view");
    self.managedObjectContext = context;
    [self.fetchedResultsController fetchRequest];
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


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil) {
	return fetchedResultsController;
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDay"
					      inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"shiftFromDay" ascending:NO]]; // Last in, first out
    request.predicate = nil;
    request.fetchBatchSize = 20;
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"shiftdaycache"];
        // @"whatJob"
    
        //    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
        //					  initWithFetchRequest:request
        //					  managedObjectContext:managedObjectContext
        //					    sectionNameKeyPath:@"whatJob"
		//				    cachedName:@"shiftdaycache"];
    fetchedResultsController = frc;
    return frc;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
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
    
    
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        emptyplaceholder.hidden = YES;
    } else {
        emptyplaceholder.hidden = NO;
    }
    
    NSLog(@"count: %d ", 
          [self.fetchedResultsController.fetchedObjects count]);
    

}


- (void)insertNewShiftChange
{
    ShiftChangeAddVC *addvc = [[ShiftChangeAddVC alloc] initWithNibName:@"ShiftChangeAddVC" bundle:nil];

    // Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    self.addingManagedObjectContext = addingContext;
    [self.addingManagedObjectContext setPersistentStoreCoordinator:[[self.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    
    addvc.managedObjectContext = addingContext;
    addvc.listDelegate = self;

    UINavigationController *navvc = [[UINavigationController alloc] initWithRootViewController:addvc];

    [navvc setToolbarHidden:NO];
    [self.navigationController presentModalViewController:navvc animated:YES];
}

/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        // Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
	[context save:nil];
}



- (void) didChangeShift :(ShiftChangeAddVC *) addController
         didFinishWithSave:(BOOL) finishWithSave
{
    if (finishWithSave) {
            // merge the add context to the main context
            //	[NSFetchedResultsController deleteCacheWithName:PROFILE_CACHE_INDIFITER];
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



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewShiftChange)];
    [self.navigationItem setRightBarButtonItem:button];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home", "")
//									     style:UIBarButtonItemStylePlain
//									    target:self
//									    action:@selector(returnToHome)];
    self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"Home", "home");
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
	NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
    self.fetchedResultsController.delegate = self;
    
    emptyplaceholder = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 640, 100)];
    emptyplaceholder.text = NSLocalizedString(@"No shitf changes...", "no shift changes");
    emptyplaceholder.alpha = 0.2;
    emptyplaceholder.hidden = YES;
    [self.view addSubview:emptyplaceholder];

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
    // Return the number of sections.
    //       return [self.fetchedResultsController.sections count];
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedResultsController.fetchedObjects count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id t = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    if ([t isKindOfClass:[ShiftDay class]]) {
        ShiftDay *day = (ShiftDay *)t;
            //cell.textLabel.text = [[NSDateFormatter alloc] stringFromDate:day.shiftFromDay];
        cell.textLabel.text = [ShiftDay returnStringForType:day.type];
        
        if (day.type.intValue == TYPE_EXCAHNGE) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ -> %@\n %@",
                                         [self.dateFormatter stringFromDate:day.shiftFromDay],
                                         [self.dateFormatter stringFromDate:day.shiftToDay], 
                                         day.notes ? day.notes : @""];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",
                                         [self.dateFormatter stringFromDate:day.shiftFromDay],
                                         day.notes ? day.notes :@""];
        }
        cell.detailTextLabel.numberOfLines = 2;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellShiftChange";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
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
