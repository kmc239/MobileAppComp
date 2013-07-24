//
//  GPCreateNewEntryController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 1/27/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import "GPCreateNewEntryController.h"
#import <QuartzCore/QuartzCore.h>

@interface GPCreateNewEntryController ()

- (void)captureImageAnimated:(BOOL)animated;

@end

@implementation GPCreateNewEntryController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Launch camera immediately
  [self captureImageAnimated:YES];
  
  // Style the photo and textview views
  self.capturedImage.layer.cornerRadius = 8.0;
  self.capturedImage.layer.masksToBounds = YES;
  
  self.entryDetails.layer.cornerRadius = 8.0;
  self.entryDetails.layer.masksToBounds = YES;
  self.entryDetails.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.entryDetails.layer.borderWidth = 1.0;
  
  // Setup scrollView
  [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 26)];
  [self.scrollView setScrollEnabled:YES];
}

#pragma mark - Actions

- (IBAction)createEntry:(id)sender
{

}

- (IBAction)retakeImage:(id)sender
{
  [self captureImageAnimated:YES];
}

#pragma mark - UIImagePickerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  
  [self.capturedImage setImage:image];
  [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Private methods

- (void)captureImageAnimated:(BOOL)animated
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
  {
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    [imagePicker setAllowsEditing:YES];
  }
  else
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Unavailable", nil)
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
  }
  [imagePicker setDelegate:self];
  [self presentViewController:imagePicker animated:animated completion:nil];
}

@end
