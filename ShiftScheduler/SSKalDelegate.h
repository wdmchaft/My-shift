//
//  KalDelegate.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ProfilesViewController.h"
#import "KalViewController.h"
#import "ShfitChangeList.h"

@interface SSKalDelegate : NSObject <UITableViewDelegate,
					 KalViewControllerDelegate>
{
    
}

- (void) KalViewController: (KalViewController *) sender selectDate: (NSDate *) date;


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
