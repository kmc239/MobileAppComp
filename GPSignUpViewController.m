//
//  GPSignUpViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPSignUpViewController.h"
#import "GPModels.h"
#import "GPHelpers.h"

#define CREATED_TAG 99

@interface GPSignUpViewController ()

@end

@implementation GPSignUpViewController

@synthesize _name, _email, _password, _confirmPassword;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpPressed:(id)sender {

  // Form validation
  if (![GPHelpers isValidName:_name.text]) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"INVALID_NAME", nil)
                         andHeading:NSLocalizedString(@"ACCOUNT_NOT_CREATED_HEADING", nil)];
  }
  else if (![GPHelpers isValidEmail:_email.text]) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"INVALID_EMAIL", nil)
                         andHeading:NSLocalizedString(@"ACCOUNT_NOT_CREATED_HEADING", nil)];
  }
  else if (![GPHelpers isValidPassword:_password.text]) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"INVALID_PASSWORD", nil)
                         andHeading:NSLocalizedString(@"ACCOUNT_NOT_CREATED_HEADING", nil)];
  }
  else if (![_password.text isEqualToString: _confirmPassword.text]) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"INVALID_CONFIRM_PASSWORD", nil)
                         andHeading:NSLocalizedString(@"ACCOUNT_NOT_CREATED_HEADING", nil)];
  }
  else {
    
    // If all the required constraints are met, create the new user
    GPUser *newUser = [[GPUser alloc] init];
    newUser.name = _name.text;
    newUser.email = _email.text;
    newUser.password = _password.text;
    
    NSLog(@"signing up new user");

    // Save Singleton Object
    GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
    [sharedUser setUser:newUser];
    
    [[RKObjectManager sharedManager] postObject:newUser delegate:self];
  }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField setUserInteractionEnabled:YES];
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == CREATED_TAG) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark - RestKit Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
  if ([request isPOST]) {
    if ([response statusCode] == 201) {
      UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ACCOUNT_CREATED_HEADING", nil)
                                                            message:NSLocalizedString(@"ACCOUNT_CREATED_MESSAGE", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TITLE", nil)
                                                  otherButtonTitles:nil];
      [successAlert setTag:CREATED_TAG];
      [successAlert show];
    }
    else {
      [GPHelpers showAlertWithMessage:[NSString stringWithFormat:@"Unexpected Response %i", [response statusCode]] andHeading:@"Account Not Created"];
    }
  }
}

// Sent when a request has failed due to an error
- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error {
	int test = [error code];
	if (test == RKRequestBaseURLOfflineError) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_CONNECTION_ERROR", nil) andHeading:NSLocalizedString(@"RK_CONNECTION_ERROR_HEADING", nil)];
		return;
	}
}

/**
 * Sent to the delegate when a request has timed out. This is sent when a
 * backgrounded request expired before completion.
 */
- (void)requestDidTimeout:(RKRequest*)request {
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_REQUEST_TIMEOUT", nil) andHeading:NSLocalizedString(@"OPERATION FAILED", nil)];
}

#pragma mark - RestKit objectLoader

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  
  NSLog(@"objectLoader loaded an object");
  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
  
  NSLog(@"objectLoader failed with error: %@", error);
  
}

@end
