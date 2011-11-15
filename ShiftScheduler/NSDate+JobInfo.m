//
//  NSDate+JobInfo.m
//  WhenWork
//
//  Created by 洁靖 张 on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+JobInfo.h"
#import <objc/runtime.h>


static const char *jobColorTag  = "jobColorTag";
static const char *jobTypeTag   = "jobTypeTag";

@implementation NSDate (JobInfo)

@dynamic jobColor;
@dynamic jobType;

- (UIColor *) jobColor
{
    return objc_getAssociatedObject(self, jobColorTag);
    
}

- (void) setJobColor:(UIColor *)jobColor
{
    objc_setAssociatedObject(self, jobColorTag, jobColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int) jobType
{
    NSNumber *number = objc_getAssociatedObject(self, jobTypeTag);
    return [number intValue];
}

- (void) setJobType:(int)jobType
{
    NSNumber *number = [NSNumber numberWithInt:jobType];
    objc_setAssociatedObject(self, jobTypeTag, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
