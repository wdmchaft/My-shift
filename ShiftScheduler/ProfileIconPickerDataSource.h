//
//  ProfileIconPickerDataSource.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-1-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPImagePickerController.h"

@interface ProfileIconPickerDataSource : NSObject <JPImagePickerControllerDataSource>
{
    NSArray *iconList;
}

@property (nonatomic, strong) NSArray *iconList;

/*!
 @method numberOfImagesInImagePicker:
 @abstract Should return the number of images.
 @discussion This method should return the number of images which the
 picker should display.
 @param picker The picker which called this method.
 */
- (NSInteger)numberOfImagesInImagePicker:(JPImagePickerController *)picker;

/*!
 @method imagePicker:thumbnailForImageNumber:
 @abstract Asks the data source for a thumbnail to insert in a particular location
 the image picker.
 @discussion This method should return a UIImage thumbnail for a image at the
 image number position. The image should have the width of kJPImagePickerControllerThumbnailWidth
 and height of kJPImagePickerControllerThumbnailWidth. If it is not that size the
 image picker will resize it so it fits.
 @param picker A picker-object requesting the thumbnail.
 @param imageNumber A image number locating the image in the picker.
 */
- (UIImage *)imagePicker:(JPImagePickerController *)picker thumbnailForImageNumber:(NSInteger)imageNumber;

/*!
 @method imagePicker:imageForImageNumber:
 @abstract Asks the data source for a image to show in a preview.
 @discussion This method should return a UIImage image for the preview at
 the image number position. The image should have the width of kJPImagePickerControllerPreviewImageWidth
 and height of kJPImagePickerControllerPreviewImageWidth. If it is not that size the
 image picker will resize it so it fits.
 @param picker A picker-object requesting the image.
 @param imageNumber A image number locating the image in the picker.
 */
- (UIImage *)imagePicker:(JPImagePickerController *)picker imageForImageNumber:(NSInteger)imageNumber;


@end