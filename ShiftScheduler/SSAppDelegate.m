//
//  SSAppDelegate.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SSAppDelegate.h"
#import "WorkdayDataSource.h"
#import "SSKalDelegate.h"
#import "Kal.h"

@implementation SSAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

// --
@synthesize profileView;
@synthesize navController;
@synthesize profileNVC, rightAS, changelistVC, sskalDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    /*
     *    Kal Initialization
     *
     * When the calendar is first displayed to the user, Kal will automatically select today's date.
     * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
     * instead of -[KalViewController init].
     */
    kal = [[KalViewController alloc] init];
    kal.title = NSLocalizedString(@"Job Scheduer", "application title");
    
    kal.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle:NSLocalizedString (@"Today", "today") 
                                              style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)];

    SSKalDelegate *kalDelegate = [[SSKalDelegate alloc] init];
    self.sskalDelegate = kalDelegate;
    kal.delegate = self.sskalDelegate;
    kal.vcdelegate = self.sskalDelegate;
    WorkdayDataSource *wds = [[WorkdayDataSource alloc] initWithManagedContext:self.managedObjectContext];
    dataSource  = wds;
    kal.dataSource = dataSource;
    
    self.profileView = [[ProfilesViewController alloc] initWithManagedContext:self.managedObjectContext];
    self.profileView.parentViewDelegate = self;
    
    self.profileNVC = [[UINavigationController alloc] initWithRootViewController:self.profileView];

    // Setup the navigation stack and display it.
    navController = [[UINavigationController alloc] initWithRootViewController:kal];
    self.navController = navController;
    self.navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    // Setup Action Sheet
    self.rightAS = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"More", "more in action sheet") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", "cancel") destructiveButtonTitle:nil 
                                 otherButtonTitles:
               NSLocalizedString(@"change shift" , "change shift"), 
               NSLocalizedString(@"manage shift", "manage shift"),
               NSLocalizedString(@"Setting", "setting in action shift"),
               nil];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"More", "more") style:UIBarButtonItemStylePlain target:self action:@selector(showRightActionSheet)];
    
    [kal.navigationItem setRightBarButtonItem:settingItem];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [self.managedObjectContext save:NULL];
    return YES;
}

- (void)showRightActionSheet
{
    // friendly for iPAD
    [self.rightAS showFromBarButtonItem: kal.navigationItem.rightBarButtonItem animated:YES];
}


- (void)showManageView
{
        //    [self.navController presentModalViewController:self.profileNVC animated:YES];
    [self.navController pushViewController:self.profileView animated:YES];
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
    [kal showAndSelectDate:[NSDate date]];
}

- (ShfitChangeList *)changelistVC
{
    if (changelistVC)
        return changelistVC;
    changelistVC = [[ShfitChangeList alloc] initWithManagedContext:self.managedObjectContext];
    return changelistVC;
}

- (void) showShiftChangeView
{
        //    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self.changelistVC];
        //   [self.navController presentModalViewController:nvc animated:YES];
    [self.navController pushViewController:self.changelistVC animated:YES];
}


- (void)actionSheet:(UIAlertView *)sender clickedButtonAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self showShiftChangeView];
            // change shift
            
            break;
        case 1:
            // manage shift
            [self showManageView];
            break;
        case 2:
            // setting view
            break;
        default:
            break;
    }
}


- (void) didFinishEditingSetting
{
    [self.navController dismissModalViewControllerAnimated:YES];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [self.rightAS dismissWithClickedButtonIndex:self.rightAS.cancelButtonIndex animated:NO];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShiftScheduler" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShiftScheduler.sqlite"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
