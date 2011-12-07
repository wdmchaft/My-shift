//
//  ShiftChangeAddVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShiftDay.h"

@protocol ShiftChangeListDelegate;

@interface ShiftChangeAddVC : UITableViewController 
{
    UISegmentedControl *changeShiftSegmentControl;
    NSManagedObjectContext *managedObjectContext;
    id<ShiftChangeListDelegate> listDelegate;
    
    ShiftDay *theShiftChange;
}

@property (nonatomic, strong) UISegmentedControl *changeShiftSegmentControl;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id<ShiftChangeListDelegate> listDelegate;
@property (strong) ShiftDay  *theShiftChange;

@end
