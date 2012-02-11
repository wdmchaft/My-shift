//
//  ProfileIconPickerDataSource.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-1-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProfileIconPickerDataSource.h"

@implementation ProfileIconPickerDataSource

@synthesize iconList;

- (id)init
{
    self = [super init];
    
    return self;
}

- (NSArray *) iconList
{
    if (iconList == nil) {
        iconList = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"jobicons.bundle"];
    }
    NSLog(@"%@", iconList);
    return iconList;
}

- (NSInteger)numberOfImagesInImagePicker:(JPImagePickerController *)picker
{
    return  [self.iconList count];
}

- (UIImage *)imagePicker:(JPImagePickerController *)picker thumbnailForImageNumber:(NSInteger)imageNumber
{
    return [UIImage imageWithContentsOfFile: [self.iconList objectAtIndex:imageNumber]];
}

- (UIImage *)imagePicker:(JPImagePickerController *)picker imageForImageNumber:(NSInteger)imageNumber
{
    return [UIImage imageWithContentsOfFile:[self.iconList objectAtIndex:imageNumber]];
}

@end
