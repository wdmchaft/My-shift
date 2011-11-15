//
//  WorkdayDataSource.h
//  Holiday
//
//  Created by Zhang Jiejing on 11-10-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Kal.h"
#import "OneJob.h"

@interface WorkdayDataSource : NSObject  <KalDataSource, NSFetchedResultsControllerDelegate>
{
    //WorkDateGenerator *generator;
    //NSArray *jobsArray;
    NSManagedObjectContext * objectContext;
    NSFetchedResultsController * fetchedRequestController;
    NSArray *theJobNameArray;
    NSMutableArray*items;
    id<KalDataSourceCallbacks> callback;
}

@property (retain, nonatomic) NSArray *theJobNameArray;
@property (nonatomic, retain) NSFetchedResultsController
*fetchedRequestController;
- (id) initWithManagedContext:(NSManagedObjectContext *)thecontext;
- (NSArray *) returnArrayBetweenDate: (NSDate *)from toDate:(NSDate *)to;



@end
