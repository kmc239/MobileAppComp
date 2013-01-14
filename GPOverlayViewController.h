//
//  GPOverlayViewController.h
//  GrowingPains
//
//  Created by Taylor McGann on 12/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPOverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end
