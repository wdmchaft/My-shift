//
//  UIImage+MonoImage.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MonoImage)

+ (UIImage *) generateMonoImage: (UIImage *)icon withColor:(UIColor *)color;
@end
