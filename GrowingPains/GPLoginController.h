//
//  GPLoginViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPLoginController : UIViewController <RKRequestDelegate, RKObjectLoaderDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)loginPressed:(id)sender;
- (IBAction)signupPressed:(id)sender;

@end
