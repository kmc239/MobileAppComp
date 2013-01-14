//
//  GPCreateEntryViewController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/16/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPCreateEntryViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GPEntry.h"
#import "GPHelpers.h"

#define CREATED_TAG 99

@interface GPCreateEntryViewController ()

@end

@implementation GPCreateEntryViewController

@synthesize scrollView = _scrollView;
@synthesize takePictureButton = _takePictureButton;
@synthesize textView = _textView;
@synthesize dismissKeyboardButton = _dismissKeyboardButton;
@synthesize currentJournalId = _currentJournalId;
@synthesize cameraOverlay = _cameraOverlay;

#define kAcceptableEntryDescriptionLength 140

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Set the back button title
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                 initWithTitle: @"Back"
                                 style: UIBarButtonItemStyleBordered
                                 target: nil action: nil];
  
  [self.navigationItem setBackBarButtonItem: backButton];
  
  // Set custom font for title
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"ENTRY_CREATE", nil) forViewController:self];
  
  // Add keyboard observers
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  // Initialize dismiss keyboard button
  self.dismissKeyboardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
  return length <= kAcceptableEntryDescriptionLength;
}

- (IBAction)createEntryPressed:(UIButton *)sender
{
  // Form validation
  if (![self isAcceptableTextLength:self.textView.text.length])
  {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"DESCRIPTION_TOO_LONG", nil)
                         andHeading:NSLocalizedString(@"GENERIC_ERROR_HEADING", nil)];
  }
  
  // ENTRY POST ATTEMPT
  // Receiving strange "Received authentication challenge" warning
//  // Create entry dictionary with picture, description, journalId
//  GPThumbnail *thumbnail = [[GPThumbnail alloc] init];
//  GPPicture *picture = [[GPPicture alloc] init];
//  picture.thumbnail = thumbnail;
//  NSNumber *journalId = [NSNumber numberWithInt:self.currentJournalId];
//
//  NSMutableDictionary *entry = [[NSMutableDictionary alloc] init];
//  [entry setValue:picture forKey:@"picture"];
//  [entry setValue:self.textView.text forKey:@"description"];
//  [entry setValue:journalId forKey:@"journalId"];
//  
//  // Upload picture
//  RKParams *params = [RKParams params];
//  
//  // Set some simple values -- just like we would with NSDictionary
//  [params setValue:entry forParam:@"entry"];
////  [params setValue:self.textView.text forParam:@"description"];
////  [params setValue:journalId forParam:@"journalId"];
//  
//  // Attach an Image from the App Bundle
//  UIImage *image = [self.takePictureButton backgroundImageForState:UIControlStateNormal];
//  NSData *imageData = UIImageJPEGRepresentation(image, 85.0);
//  [params setData:imageData MIMEType:@"image/jpg" forParam:@"picture"];
////  NSData *imageData = UIImagePNGRepresentation(image);
////  [params setData:imageData MIMEType:@"image/png" forParam:@"picture"];
//  
//  // Let's examine the RKRequestSerializable info...
//  NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
//  NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
//  
//  // Send a Request!
//  [[RKClient sharedClient] post:@"/entries" params:params delegate:self];

  // Creates a new entry, however this does not post the image
  GPEntry *newEntry = [[GPEntry alloc] init];
  newEntry.description = self.textView.text;
  newEntry.journalId = self.currentJournalId;

  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  [[RKObjectManager sharedManager] postObject:newEntry delegate:self];
}

#pragma mark - Keyboard & TextView Manipulation

- (void)keyboardWasShown:(NSNotification *)notification
{
  // Step 1: Get the size of the keyboard.
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  
//    // Step 3: Scroll the target text field into view. === DOESN'T DO JACK!
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= keyboardSize.height;
//    if (!CGRectContainsPoint(aRect, self.textView.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, self.textView.frame.origin.y - (keyboardSize.height - 15));
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  self.navigationItem.rightBarButtonItem = self.dismissKeyboardButton;
}

- (void)dismissKeyboard:(id)sender
{
  [self.textView resignFirstResponder];
  self.navigationItem.rightBarButtonItem = nil;
}

//#pragma mark - Image Manipulation
//
//- (UIImage *)cropImage:(UIImage *)originalImage toRect:(CGRect)newSize
//{
//  // Create a new image in quartz with our new bounds and original image
//  CGImageRef tmp = CGImageCreateWithImageInRect([originalImage CGImage], newSize);
//  
//  // Pump our cropped image back into a UIImage object
//  UIImage *croppedImage = [UIImage imageWithCGImage:tmp];
//  
//  return croppedImage;
//}

#pragma mark - Camera UI

- (IBAction)showCameraUI:(UIButton *)sender
{
  // Instantiate camera overlay
  self.cameraOverlay = [[GPOverlayViewController alloc] initWithNibName:@"GPOverlayView" bundle:nil];
  
  [self startCameraControllerFromViewController:self usingDelegate:self.cameraOverlay];
}

- (BOOL)startCameraControllerFromViewController: (UIViewController*) controller
                                  usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    
  BOOL result = YES;
  
  // Setup the image picker
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.delegate = delegate;
  ((GPOverlayViewController *) delegate).imagePicker = imagePicker;
  
  // Check camera availability; load photo library if not available
  if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
  {
    // Set source to photo library
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    result = NO;
  }
  else
  {
    // Set source to camera
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.showsCameraControls = NO;
    imagePicker.navigationBarHidden = YES;
    imagePicker.toolbarHidden = YES;
    imagePicker.wantsFullScreenLayout = YES;
    
    // Only capture still images; add kUTTypeMovie to the array for video
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    imagePicker.allowsEditing = YES;
  }
  
  [controller presentViewController:imagePicker animated:YES completion:^{
    imagePicker.cameraOverlayView = ((GPOverlayViewController *) delegate).view;
  }];
//  [controller presentViewController:imagePicker animated:YES completion:nil];
  
  return result;
}

//#pragma mark - UIImagePickerControllerDelegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//	UIImage *originalImage, *editedImage;
//	
//	// Handle a still image capture
//	if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
//		
//		editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
//		originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
//		
//		// Replace the default image (or current photo) with the edited image
//		// If no edited image exists, use a cropped version of the original photo
//		if (editedImage)
//		{
//			// Save the new image (original or edited) to the Camera Roll
//			UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
//			
//			[self.takePictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
//		}
//		else
//		{
//			CGFloat width = originalImage.size.width;
//			CGFloat height = originalImage.size.height;
//			CGFloat photoRatio = 4.0/3.0;
//			
//			// Crop photo album images as long as they are standard iPhone images with standard 4:3 or 3:4 ratio
//			if (width <= 3264 && height <= 3264 && ((width / height) == photoRatio || (height / width) == photoRatio))
//			{
//				if (width > height)
//				{
//					// 'x' is half the distance of the difference between the width and the height
//					CGFloat x = (width - height) / 2;
//					
//					// Make a new bounding rectangle including our crop
//					CGRect newSize = CGRectMake(x, 0, height, height);
//					
//					editedImage = [self cropImage:originalImage toRect:newSize];
//				}
//				else if (height > width)
//				{
//					// 'y' is half the distance of the difference between the height and the width
//					CGFloat y = (height - width) / 2;
//					
//					// Make a new bounding rectangle including our crop
//					CGRect newSize = CGRectMake(0, y, width, width);
//					
//					editedImage = [self cropImage:originalImage toRect:newSize];
//				}
//				else
//				{
//					editedImage = originalImage;
//				}
//				
//				[self.takePictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
//			}
//		}
//	}
//	
//	[self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//  [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == CREATED_TAG) {
//    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark - RestKit Request Delegate Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  if ([request isPOST]) {
    if ([response statusCode] == 201) {
      UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ENTRY_CREATED_HEADING", nil)
                                                            message:NSLocalizedString(@"ENTRY_CREATED_MESSAGE", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TITLE", nil)
                                                  otherButtonTitles:nil];
      [successAlert setTag:CREATED_TAG];
      [successAlert show];
    }
    else {
      [GPHelpers showAlertWithMessage:[NSString stringWithFormat:@"Unexpected Response %i", [response statusCode]] andHeading:NSLocalizedString(@"ENTRY_NOT_CREATED_HEADING", nil)];
    }
  }

}

// Sent when a request has failed due to an error
- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	int test = [error code];
	if (test == RKRequestBaseURLOfflineError)
  {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_CONNECTION_ERROR", nil) andHeading:NSLocalizedString(@"RK_CONNECTION_ERROR_HEADING", nil)];
		return;
	}
}

// Sent to the delegate when a request has timed out
- (void)requestDidTimeout:(RKRequest*)request
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_REQUEST_TIMEOUT", nil) andHeading:NSLocalizedString(@"RK_OPERATION_FAILED", nil)];
}

#pragma mark - RestKit objectLoader

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader loaded an object");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader failed with error: %@", error);
}

@end
