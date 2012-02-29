//
//  SSSettingTVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSSettingTVC : UITableViewController <NSURLConnectionDelegate>
{
    NSArray *itemsArray;
    NSURL *iTunesURL;
    NSArray * alarmSettingsArray;
}


@property (strong, nonatomic, readonly) NSArray *itemsArray;
@property (strong, nonatomic, readonly) NSArray *alarmSettingsArray;
@property (nonatomic, strong) NSURL *iTunesURL;


@end
