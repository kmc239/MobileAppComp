//
//  GPLoginViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPLoginViewController : UIViewController <RKRequestDelegate, RKObjectLoaderDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UITextField *_email;
@property (strong, nonatomic) IBOutlet UITextField *_password;
@property (strong, nonatomic) IBOutlet UILabel *_titleLabel;

- (IBAction)loginPressed:(id)sender;
- (IBAction)signupPressed:(id)sender;

@end
