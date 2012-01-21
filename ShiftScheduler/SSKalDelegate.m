//
//  KalDelegate.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SSKalDelegate.h"

@implementation SSKalDelegate

#pragma mark - KalViewControllerDelegate protocol.
- (void) KalViewController:(KalViewController *)sender selectDate:(NSDate *)date
{
}

#pragma mark UITableViewDelegate protocol conformance

// Display a details screen for the selected holiday/row.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
