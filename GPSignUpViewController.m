//
//  GPSignUpViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPSignUpViewController.h"
#import "GPUserSingleton.h"
#import "GPModels.h"
#import "GPHelpers.h"

#define CREATED_TAG 99

@interface GPSignUpViewController ()

@end

@implementation GPSignUpViewController

@synthesize _name, _email, _password, _confirmPassword;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"APP_NAME", nil) forViewController:self];
  
  // Close keyboard when user taps outside of a UITextField
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
}

#pragma mark - Dismiss Keyboard

- (void)dismissKeyboard
{
  DLog(@"dismiss keyboard");
  
  if ([self._name isFirstResponder]) {
    [self._name resignFirstResponder];
  }
  else if ([self._email isFirstResponder]) {
    [self._email resignFirstResponder];
  }
  else if ([self._password isFirstResponder]) {
    [self._password resignFirstResponder];
  }
  else if ([self._confirmPassword isFirstResponder]) {
    [self._confirmPassword resignFirstResponder];
  }
}

#pragma mark - Actions

- (IBAction)signUpPressed:(id)sender
{

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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[RKObjectManager sharedManager] postObject:newUser delegate:self];
  }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self._name) {
    [self._email becomeFirstResponder];
  }
  if (textField == self._email) {
    [self._password becomeFirstResponder];
  }
  if (textField == self._password) {
    [self._confirmPassword becomeFirstResponder];
  }
  else if (textField == self._confirmPassword) {
    [textField resignFirstResponder];
    [self signUpPressed:nil];
  }
  return YES;
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == CREATED_TAG) {
    [self performSegueWithIdentifier:@"Login After Signup" sender:self];
  }
}

#pragma mark - RestKit Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
      [GPHelpers showAlertWithMessage:[NSString stringWithFormat:@"Unexpected Response %i", [response statusCode]] andHeading:NSLocalizedString(@"ACCOUNT_NOT_CREATED_HEADING", nil)];
    }
  }
}

// Sent when a request has failed due to an error
- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	int test = [error code];
	if (test == RKRequestBaseURLOfflineError) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_CONNECTION_ERROR", nil) andHeading:NSLocalizedString(@"RK_CONNECTION_ERROR_HEADING", nil)];
		return;
	}
}

// Sent to the delegate when a request has timed out
- (void)requestDidTimeout:(RKRequest*)request
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_REQUEST_TIMEOUT", nil) andHeading:NSLocalizedString(@"OPERATION FAILED", nil)];
}

#pragma mark - RestKit objectLoader

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader loaded an object");
  
  // Store user object in preparation to send user to home screen
  if ([[objects objectAtIndex:0] isKindOfClass:[GPUser class]]) {
    
    GPUser *loggedInUser = [objects objectAtIndex:0];
    NSLog(@"The user's name is %@", loggedInUser.name);
    
    // Set RestKit shared client to store creds for this session
    // The API requires all users to be logged in for every API call,
    // with the exception of create user and login
    [[RKClient sharedClient] setUsername:_email.text];
    [[RKClient sharedClient] setPassword:_password.text];
    
    // Save Singleton Object
    GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
    [sharedUser setUser:loggedInUser];
  }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader failed with error: %@", error);
}

@end
