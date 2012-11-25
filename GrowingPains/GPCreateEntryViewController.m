//
//  GPCreateEntryViewController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/16/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPCreateEntryViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface GPCreateEntryViewController ()

@end

@implementation GPCreateEntryViewController

@synthesize scrollView = _scrollView;
@synthesize takePictureButton = _takePictureButton;
@synthesize textView = _textView;
@synthesize dismissKeyboardButton = _dismissKeyboardButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark - Image Manipulation

- (UIImage *)cropImage:(UIImage *)originalImage toRect:(CGRect)newSize
{
    // Create a new image in quartz with our new bounds and original image
    CGImageRef tmp = CGImageCreateWithImageInRect([originalImage CGImage], newSize);
    
    // Pump our cropped image back into a UIImage object
    UIImage *croppedImage = [UIImage imageWithCGImage:tmp];
    
    return croppedImage;
}

#pragma mark - Camera UI

- (IBAction)showCameraUI:(UIButton *)sender
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (BOOL)startCameraControllerFromViewController: (UIViewController*) controller
                                  usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    
    BOOL result = YES;
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        result = NO;
    }
    else
    {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        // Only capture still images; add kUTTypeMovie to the array for video
        cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        cameraUI.allowsEditing = YES;
    }
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
    return result;
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
            
            [self.takePictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
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
                
                [self.takePictureButton setBackgroundImage:editedImage forState:UIControlStateNormal];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
