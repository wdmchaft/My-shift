//
//  UIColor+HexCoding.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-1-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexCoding)

- (NSString *) hexStringFromColor;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert withAlpha: (float) alpha;



@end
