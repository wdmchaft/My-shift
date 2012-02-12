//
//  UIImage+MonoImage.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MonoImage)

// This function create a Image Context and draw the image with mask
// then clip the context to mask
// then fill the color user choosed.
// that can create a image shape with specify color icon.
+ (UIImage *) generateMonoImage: (UIImage *)icon withColor:(UIColor *)color;
@end
