//
//  GPSignUpViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPSignUpViewController : UIViewController <UITextFieldDelegate, RKObjectLoaderDelegate, RKRequestDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *_firstName;
@property (strong, nonatomic) IBOutlet UITextField *_lastName;
@property (strong, nonatomic) IBOutlet UITextField *_email;
@property (strong, nonatomic) IBOutlet UITextField *_userName;
@property (strong, nonatomic) IBOutlet UITextField *_password;
@property (strong, nonatomic) IBOutlet UITextField *_confirmPassword;

- (IBAction)signUpPressed:(id)sender;

@end
