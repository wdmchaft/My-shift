//
//  SSProfileReminderDateSource.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    REMIND_NO_ITEM = 0,
    REMIND_JUST_HAPPEN_ITEM,
    REMIND_5_MIN_ITEM,
    REMIND_15_MIN_ITEM,
    REMIND_30_MIN_ITEM,
    REMIND_1_HOUR_ITEM,
    REMIND_1_5_HOUR_ITEM,
    REMIND_2_HOUR_ITEM,
};

#define REMIND_NO_ITEM_STR NSLocalizedString(@"None", "no")
#define REMIND_JUST_HAPPEN_ITEM_STR NSLocalizedString(@"At time of event", "just happen")
#define REMIND_5_MIN_ITEM_STR NSLocalizedString(@"5 minutes before", "5 Minutes")
#define REMIND_15_MIN_ITEM_STR NSLocalizedString(@"15 minutes before", "15 Minutes")
#define REMIND_30_MIN_ITEM_STR NSLocalizedString(@"30 minutes before", "30 Minutes")
#define REMIND_1_HOUR_ITEM_STR NSLocalizedString(@"1 hour before", "1 Hour")
#define REMIND_1_5_HOUR_ITEM_STR NSLocalizedString(@"1.5 hour before", "1.5 Hour")
#define REMIND_2_HOUR_ITEM_STR NSLocalizedString(@"2 hour before", "2 Hour")

