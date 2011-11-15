//
//  ProfilesViewController.h
//  
//
//  Created by Zhang Jiejing on 11-10-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OneJob.h"

@class ProfileChangeViewController;
@protocol ProfileViewDelegate
- (void) didChangeProfile:(ProfileChangeViewController *) addController
        didFinishWithSave:(BOOL) finishWithSave;
@end


@interface ProfilesViewController : UITableViewController <NSFetchedResultsControllerDelegate, ProfileViewDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *addingManagedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	UIBarButtonItem *addButton;
	UIBarButtonItem *oldLeftItem;
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController
*fetchedResultsController;

- (id)initWithManagedContext:(NSManagedObjectContext *)context;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;

@end


