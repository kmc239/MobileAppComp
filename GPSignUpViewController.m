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

@synthesize _firstName, _lastName, _email, _userName, _password, _confirmPassword;

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

  NSLog(@"signing up");
  GPUser *newUser = [[GPUser alloc] init];
  newUser.name = _firstName.text;
  newUser.email = _email.text;
  
  [[RKObjectManager sharedManager] postObject:newUser delegate:self];
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
    NSLog(@"alertview del");
  }
}

#pragma mark - RestKit Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
  if ([request isPOST]) {
    if ([response statusCode] == 201) {
      UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"Account Created"
                                                            message:@"Your account has been successfully created"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RESTKIT CONNECTION ERROR", nil) andHeading:NSLocalizedString(@"RESTKIT CONNECTION HEADING", nil)];
		return;
	}
}

/**
 * Sent to the delegate when a request has timed out. This is sent when a
 * backgrounded request expired before completion.
 */
- (void)requestDidTimeout:(RKRequest*)request {
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RESTKIT LOAD ERROR", nil) andHeading:NSLocalizedString(@"OPERATION FAILED", nil)];
}

#pragma mark - RestKit objectLoader

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  
  NSLog(@"objectLoader loaded an object");
  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
  
  NSLog(@"objectLoader failed with error: %@", error);
  
}

@end
