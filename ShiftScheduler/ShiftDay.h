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

@property (nonatomic, strong) NSDate * shiftFromDay;
@property (nonatomic, strong) NSDate * shiftToDay;
@property (nonatomic, strong) NSNumber * otherInfo;
@property (nonatomic, strong) NSString * notes;

@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) OneJob *whatJob;

+ (NSString *) returnStringForType:(NSNumber *)type;


#define TYPE_EXCAHNGE 0
#define TYPE_OVERWORK 1
#define TYPE_VACATION 2


@end
