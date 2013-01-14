//
//  GPOverlayViewController.m
//  GrowingPains
//
//  Created by Taylor McGann on 12/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPOverlayViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GPCreateEntryViewController.h"

@implementation GPOverlayViewController

@synthesize imagePicker = _pickerReference;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (IBAction)cancelPhoto:(id)sender
{
  [self imagePickerControllerDidCancel:self.imagePicker];
}

- (IBAction)capturePhoto:(id)sender
{
  [self.imagePicker takePicture];
}

- (IBAction)changeCamera:(UIButton *)sender
{
  UIButton *flashButton = ((UIButton *)[self.view viewWithTag:1]);
  
  if (self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
  {
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    flashButton.enabled = YES;
    [flashButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
  }
  else
  {
    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    flashButton.enabled = NO;
    [flashButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
  }
}

- (IBAction)changeFlash:(UIButton *)sender
{
  if (self.imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto)
  {
    self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    [sender setTitle:@"ON" forState:UIControlStateNormal];
  }
  else if (self.imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn)
  {
    self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    [sender setTitle:@"OFF" forState:UIControlStateNormal];
  }
  else
  {
    self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    [sender setTitle:@"AUTO" forState:UIControlStateNormal];
  }
}

- (IBAction)showLibrary:(id)sender
{
  self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)setEntryPreviewImage:(UIImage *)finalImage
{
//  [self.createEntryControllerReference.takePictureButton setBackgroundImage:finalImage forState:UIControlStateNormal];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	UIImage *originalImage, *editedImage;
	
	// Handle a still image capture
	if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
		
		editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
		originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
		
		// Replace the default image (or current photo) with the edited image
		// If no edited image exists, use a cropped version of the original photo
		if (editedImage)
		{
			// Save the new image (original or edited) to the Camera Roll
			UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
			
			[self setEntryPreviewImage:editedImage];
		}
		else
		{
			CGFloat width = originalImage.size.width;
			CGFloat height = originalImage.size.height;
			CGFloat photoRatio = 4.0/3.0;
			
			// Crop photo album images as long as they are standard iPhone images with standard 4:3 or 3:4 ratio
			if (width <= 3264 && height <= 3264 && ((width / height) == photoRatio || (height / width) == photoRatio))
			{
				if (width > height)
				{
					// 'x' is half the distance of the difference between the width and the height
					CGFloat x = (width - height) / 2;
					
					// Make a new bounding rectangle including our crop
					CGRect newSize = CGRectMake(x, 0, height, height);
					
					editedImage = [self cropImage:originalImage toRect:newSize];
				}
				else if (height > width)
				{
					// 'y' is half the distance of the difference between the height and the width
					CGFloat y = (height - width) / 2;
					
					// Make a new bounding rectangle including our crop
					CGRect newSize = CGRectMake(0, y, width, width);
					
					editedImage = [self cropImage:originalImage toRect:newSize];
				}
				else
				{
					editedImage = originalImage;
				}
				
				[self setEntryPreviewImage:editedImage];
			}
		}
	}
	
	[self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Manipulation

- (UIImage *)cropImage:(UIImage *)originalImage toRect:(CGRect)newSize
{
  // Create a new image in quartz with our new bounds and original image
  CGImageRef tmp = CGImageCreateWithImageInRect([originalImage CGImage], newSize);
  
  // Pump our cropped image back into a UIImage object
  UIImage *croppedImage = [UIImage imageWithCGImage:tmp];
  
  return croppedImage;
}

@end
