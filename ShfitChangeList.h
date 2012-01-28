//
//  ShfitChangeList.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE_OLD_ADDVC


@class ShiftChangeAddVC;
@class ShiftChangeAddViewController;

@protocol ShiftChangeListDelegate

#ifdef USE_OLD_ADDVC
- (void) didChangeShift :(ShiftChangeAddVC *) addController
       didFinishWithSave:(BOOL) finishWithSave;
#else

- (void) didChangeShift :(ShiftChangeAddViewController *) addController
       didFinishWithSave:(BOOL) finishWithSave;
#endif
@end

@interface ShfitChangeList : UITableViewController <NSFetchedResultsControllerDelegate, ShiftChangeListDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *addingManagedObjectContext;
    NSDateFormatter * dateFormatter;

    UILabel *emptyplaceholder;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong)     NSDateFormatter * dateFormatter;


- (id)initWithManagedContext:(NSManagedObjectContext *)context;			      
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
			      
@end
