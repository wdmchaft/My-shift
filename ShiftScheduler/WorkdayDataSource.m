//
//  WorkdayDataSource.m
//  Holiday
//
//  Created by Zhang Jiejing on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WorkdayDataSource.h"
#import "NSDateAdditions.h"

@implementation WorkdayDataSource

#define JOB_CACHE_INDEFITER @"JobNameCache"

@synthesize fetchedRequestController;
@synthesize theJobNameArray;

- (id)init
{
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (id) initWithManagedContext:(NSManagedObjectContext *)thecontext
{
    self = [self init];
    objectContext = thecontext;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OneJob" 
                                              inManagedObjectContext:objectContext];
    [request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor 
                                                        sortDescriptorWithKey:@"jobName"  
                                                        ascending:YES]];
    
    request.predicate = nil;
    request.fetchBatchSize = 20;
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] 
                                       initWithFetchRequest:request 
                                       managedObjectContext:objectContext
                                       sectionNameKeyPath:@"jobName" 
                                       cacheName:JOB_CACHE_INDEFITER];
    NSError *error = 0;
    self.fetchedRequestController = frc;
    [self.fetchedRequestController performFetch:&error];
    if (error)
        NSLog(@"fetch request error:%@", error.userInfo);
    self.fetchedRequestController.delegate = self;

    return  self;
}

//- (NSArray *) theJobNameArray
//{
//    [self.fetchedResultsController performFetch:nil];
//    return self.fetchedResultsController.fetchedObjects;
//}

- (NSArray *)theJobNameArray 
{
    if (theJobNameArray != 0)
        return theJobNameArray;
    
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OneJob" 
                                              inManagedObjectContext:objectContext];
    [request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor 
                                                        sortDescriptorWithKey:
							       @"jobName"  
                                                        ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"jobEnable == YES"];

    request.fetchBatchSize = 20;

    self.theJobNameArray = [objectContext executeFetchRequest:request error:&error];
   if (error) {
        NSLog(@"get job name list failed)");
   }
    return theJobNameArray;
}

#pragma mark UITableViewDataSource protocol conformance

- (OneJob *) jobAtIndexPath:(NSIndexPath *)indexPath
{
    return [items objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
	 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell"];
    if (!cell) {
	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
				      reuseIdentifier:@"WorkCell"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    OneJob *job = [self jobAtIndexPath: indexPath];
    
    cell.textLabel.text = job.jobName;
    cell.imageView.image = job.iconImage;
    return cell;
}
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}


#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate 
		   delegate:(id<KalDataSourceCallbacks>)delegate
{
    [delegate loadedDataSource:self];
    callback = delegate;
}

#define ONE_DAY_SECONDS (60*60*24)
#define HALF_DAY_SECONDS (60*60*12)
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{

//    return [self.generator returnWorkdaysWithInStartDate:fromDate
//    endDate: toDate]; return [[self.jobsArray lastObject]
//    returnWorkdaysWithInStartDate:fromDate endDate:toDate];
    
    // first, use fetchrequest controller get all Job Info
    
    // got the information about all jobs, work or not, each in an array.
    // or each add an generator.
    
    // (have a API to generator, let him know which data will be show,
    // so it needs more calulating more days.
    
    // merge the genrator's result together.

    NSMutableArray *markedDayArray = [[NSMutableArray alloc] init];
    
    for (OneJob *j in self.theJobNameArray) {
        [markedDayArray addObjectsFromArray:[j returnWorkdaysWithInStartDate:fromDate 
								     endDate:toDate]];
        [markedDayArray addObjectsFromArray:[j returnWorkdaysWithInStartDate:fromDate endDate:[toDate dateByAddingTimeInterval:ONE_DAY_SECONDS]]];
    }
    
    //!!!! OFF by one BUG: the last day need be larger, since for some time zone, the last day will lost
    
    
    return  markedDayArray;
}

- (void) loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate toArray: (NSMutableArray *)array
{
    NSDate *nextday;
    for (nextday = fromDate; [nextday timeIntervalSinceDate:toDate] < 0; 
         nextday = 
         [nextday dateByAddingTimeInterval:24*60*60]) {
        for (OneJob *job in self.theJobNameArray) {
            if ([job isDayWorkingDay:nextday]) {
                [array addObject:job];
            }
        }
    }    
}


- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [self loadItemsFromDate:fromDate toDate:toDate toArray:items];
}

- (void)removeAllItems
{
    [items removeAllObjects];
}

#pragma mark - TileViewIconDelegate

// Tile View Icon delegate
- (NSArray *) KalTileDrawDelegate: (KalTileView *) sender getIconDrawInfoWithDate: (NSDate *) date
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tjobArray = [[NSMutableArray alloc] init];
    
    NSDate *from = [date cc_dateByMovingToBeginningOfDay];
    NSDate *to = [date cc_dateByMovingToEndOfDay];
    
    [self loadItemsFromDate:from toDate:to toArray:tjobArray];
    if (tjobArray.count == 0) 
        return nil;
    for (id j in tjobArray) {
        if (j && [j isKindOfClass:[OneJob class]]) {
            OneJob *job = j;
            int drawType;
            if (job.iconColor == nil)
                drawType = KAL_TILE_DRAW_METHOD_COLOR_ICON;
            else
                drawType = KAL_TILE_DRAW_METHOD_MONO_ICON_FILL_COLOR;

            NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys: 
                                   [NSNumber numberWithInt:drawType],  KAL_TILE_ICON_DRAW_TYPE_KEY, 
                                   job.iconImage, KAL_TILE_ICON_IMAGE_KEY, 
                                   job.iconColor, KAL_TILE_ICON_COLOR_KEY, nil];
            [resultArray addObject:entry];
        }
    }
    return resultArray;   
}

#pragma mark - FetchedResultController 

/**
 Delegate methods of NSFetchedResultsController to respond to
 additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change
	// notifications, so prepare the table view for updates.
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [NSFetchedResultsController deleteCacheWithName:JOB_CACHE_INDEFITER];
    self.theJobNameArray = nil;
	[callback loadedDataSource:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    [callback loadedDataSource:self];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change
	// notifications, so tell the table view to process all
	// updates.
    
    
}

@end
