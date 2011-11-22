//
//  SSAppDelegate.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilesViewController.h"
#import "KalViewController.h"


@interface SSAppDelegate : UIResponder <UIApplicationDelegate, 
UITableViewDelegate, 
ProfileEditFinishDelegate>
{
    UINavigationController *navController;
    UINavigationController *profileNVC;
    KalViewController *kal;
    ProfilesViewController *profileView;
    UITabBarController *tabBarVC;

    id dataSource;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


// --
@property (strong) UINavigationController *navController;				
@property (nonatomic, retain) ProfilesViewController *profileView;
@property (nonatomic, retain) UINavigationController *profileNVC;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) didFinishEditingSetting;

@end
