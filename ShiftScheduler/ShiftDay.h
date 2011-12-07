//
//  ShiftDay.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class OneJob;
@interface ShiftDay : NSManagedObject

@property (nonatomic, retain) NSDate * shiftFromDay;
@property (nonatomic, retain) NSDate * shiftToDay;
@property (nonatomic, retain) NSNumber * otherInfo;
@property (nonatomic, retain) NSString * notes;

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) OneJob *whatJob;

@end
