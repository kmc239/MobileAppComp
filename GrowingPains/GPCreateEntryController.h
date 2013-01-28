//
//  GPCreateEntryViewController.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/16/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPCreateEntryController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, RKRequestDelegate, RKObjectLoaderDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIBarButtonItem *dismissKeyboardButton;
@property NSInteger currentJournalId;

@end
