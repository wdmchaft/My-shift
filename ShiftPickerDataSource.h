//
//  ShiftPickerView.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneJob.h"

@interface ShiftPickerViewDataSource :NSObject <UIPickerViewDataSource> {
    NSArray *fetchResults;
    NSManagedObjectContext *managedcontext;
    
}

@property (nonatomic, strong) NSArray *fetchResults;
- initWithContext:(NSManagedObjectContext *)context;
- (NSInteger) count;
- (OneJob *) retrunOneJob;
- (OneJob *) returnJobAt:(NSInteger) n;

@end
