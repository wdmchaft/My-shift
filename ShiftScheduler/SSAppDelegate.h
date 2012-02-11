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
#import "ShfitChangeList.h"
#import "SSKalDelegate.h"
#import "SSSettingTVC.h"


@interface SSAppDelegate : UIResponder <UIApplicationDelegate, 
UIActionSheetDelegate,
ProfileEditFinishDelegate>
{
    UINavigationController *navController;
    UINavigationController *profileNVC;
    KalViewController *kal;
    ProfilesViewController *profileView;
    ShfitChangeList *changelistVC;
    SSKalDelegate *sskalDelegate;
    SSSettingTVC *settingVC;
    UITabBarController *tabBarVC;
    UIActionSheet *rightAS;
    id dataSource;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


// --
@property (strong) UINavigationController *navController;				
@property (nonatomic, strong) ProfilesViewController *profileView;
@property (nonatomic, strong) SSSettingTVC *settingVC;
@property (nonatomic, strong) UINavigationController *profileNVC;
@property (nonatomic, strong) ShfitChangeList *changelistVC;
@property (nonatomic, strong) UIActionSheet *rightAS;
@property (nonatomic, strong) SSKalDelegate *sskalDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) didFinishEditingSetting;
- (void)showRightActionSheet;


@end
