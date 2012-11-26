//
//  GPCreateEntryViewController.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/16/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCreateEntryViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIBarButtonItem *dismissKeyboardButton;

@end
