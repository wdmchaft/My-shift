//
//  OneJobModuleTest.h
//  OneJobModuleTest
//
//  Created by 洁靖 张 on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OneJob.h"


@interface OneJobModuleTest : SenTestCase {
    
    NSManagedObjectContext *moc;
    OneJob *onOffJob;
    NSCalendar *calender;
    NSDateFormatter *formatter;
    
}

@property (nonatomic,retain) NSManagedObjectContext *moc;


@end
