//
//  ShiftDay.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShiftDay.h"


@implementation ShiftDay

@dynamic shiftFromDay;
@dynamic shiftToDay;
@dynamic otherInfo;
@dynamic type;
@dynamic notes;
@dynamic whatJob;

+ (NSString *) returnStringForType:(NSNumber *)type
{
    if (type.intValue == TYPE_EXCAHNGE)
        return NSLocalizedString(@"Exchange", "Exchange");
    if (type.intValue == TYPE_OVERWORK)
        return NSLocalizedString(@"OverWork", "OverWork");
    if (type.intValue == TYPE_VACATION)
        return NSLocalizedString(@"Vacation", "Vacation");
    return nil;
}

@end
