//
//  SSShiftTypePickerTVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"

@class SSShiftTypePickerTVC;

@protocol SSShiftTypePickerDelegate 

- (void) SSItemPickerChoosewithController: (SSShiftTypePickerTVC *) sender itemIndex: (NSInteger) index;

@end

@interface SSShiftTypePickerTVC : UITableViewController

@property (strong) NSArray *items;
@property (assign, nonatomic)     id<SSShiftTypePickerDelegate> __unsafe_unretained pickDelegate;



@end
