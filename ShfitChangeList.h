//
//  ShfitChangeList.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShiftChangeAddVC;

@protocol ShiftChangeListDelegate
- (void) didChangeShift :(ShiftChangeAddVC *) addController
       didFinishWithSave:(BOOL) finishWithSave;
@end

@interface ShfitChangeList : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *addingManagedObjectContext;

}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (id)initWithManagedContext:(NSManagedObjectContext *)context;			      
			      
@end
