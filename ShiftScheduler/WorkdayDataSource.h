//
//  WorkdayDataSource.h
//  Holiday
//
//  Created by Zhang Jiejing on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Kal.h"
#import "OneJob.h"

@interface WorkdayDataSource : NSObject  <KalDataSource, NSFetchedResultsControllerDelegate, KalTileIconDelegate>
{
    //WorkDateGenerator *generator;
    //NSArray *jobsArray;
    NSManagedObjectContext * objectContext;
    NSFetchedResultsController * fetchedRequestController;
    NSArray *theJobNameArray;
    NSMutableArray*items;
    NSDateFormatter *timeFormatter;
    id<KalDataSourceCallbacks> callback;
}

@property (strong, nonatomic) NSArray *theJobNameArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedRequestController;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (strong, nonatomic)     NSManagedObjectContext * objectContext;


- (id) initWithManagedContext:(NSManagedObjectContext *)thecontext;

// Tile View Icon delegate
- (NSArray *) KalTileDrawDelegate: (KalTileView *) sender getIconDrawInfoWithDate: (NSDate *) date;




@end
