//
//  FreeJumpProfileConfigTVC.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"

@interface FreeJumpProfileConfigTVC : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) OneJob *theJob;
@end
