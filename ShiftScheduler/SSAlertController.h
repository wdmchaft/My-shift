//
//  SSAlertController.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

// this class have below function.
// * badge number controll.* 
// 1. clear the badge number when user enter Application or User Click the alert "view detail"
// 2. add the badge number when user ignore the notify.

// * alert control *
// 1. setup up the notify for each job's on and off day per their settings.
// 2. when the application going to background, extend the exsiting badge number controll to more days.

@interface SSAlertController : NSObject <NSFetchedResultsControllerDelegate>
{
	NSArray *jobArray;
	NSArray *arrayedAlert;
	NSManagedObjectContext *managedcontext;
	NSFetchedResultsController *frc;
    
    SystemSoundID alertSoundID;
    NSURL *alert_sound_url;
}

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSManagedObjectContext *managedcontext;
@property (nonatomic, strong) NSArray *jobArray;

- (id) initWithManagedContext: (NSManagedObjectContext *) thecontext;

- (void) clearBadgeNumber;
- (void) setupAlarm;
- (void) playAlarmSound;

@end
