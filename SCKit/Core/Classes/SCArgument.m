//
//  SCArgument.m
//  SCKit
//
//  Created by Sebastian Celis on 5/16/11.
//  Copyright 2011 Sebastian Celis. All rights reserved.
//

#import "SCArgument.h"

@implementation SCArgument

@synthesize argumentId = _argumentId;
@synthesize defaultValue = _defaultValue;
@synthesize longFlag = _longFlag;
@synthesize metaName = _metaName;
@synthesize required = _required;
@synthesize returnType = _returnType;
@synthesize shortFlag = _shortFlag;
@synthesize type = _type;
@synthesize variableLength = _variableLength;

#pragma mark - Object Lifecycle

- (id)init
{
    if ((self = [super init]))
    {
        _type = SCArgumentTypeUnknown;
        _returnType = SCVariableTypeString;
    }
    
    return self;
}


@end
