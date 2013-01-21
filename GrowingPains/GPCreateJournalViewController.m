//
//  GPCreateJournalViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPCreateJournalViewController.h"
#import "GPUserSingleton.h"
#import "GPModels.h"
#import "GPHelpers.h"

#define CREATED_TAG 99

@interface GPCreateJournalViewController ()

@end

@implementation GPCreateJournalViewController

@synthesize actionSheet = _actionSheet;
@synthesize datePicker = _datePicker;
@synthesize birthdate = _birthdate;
@synthesize gender = _gender;
@synthesize name = _name;
@synthesize whoForLabel = _whoForLabel;
@synthesize delegate;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Set custom fonts
  [self.whoForLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.whoForLabel.font.pointSize]];
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"JOURNAL_CREATE", nil) forViewController:self];
  
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
  
  if ([self.name isFirstResponder]) {
    [self.name resignFirstResponder];
  }
  else if ([self.birthdate isFirstResponder]) {
    [self.birthdate resignFirstResponder];
  }
}

#pragma mark - Actions
- (IBAction)birthdateButton:(id)sender {
  
  [self showPicker];
}

- (IBAction)createJournalButton:(id)sender {
  
  // Form validation
  if (![GPHelpers isValidName:_name.text]) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"JOURNAL_INVALID_NAME", nil)
                         andHeading:NSLocalizedString(@"JOURNAL_NOT_CREATED_HEADING", nil)];
  }
  else if (_birthdate.text.length == 0) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"INVALID_BIRTHDATE", nil)
                         andHeading:NSLocalizedString(@"JOURNAL_NOT_CREATED_HEADING", nil)];
  }
  else {
    
    // If all the required constraints are met, create the new journal
    GPJournal *newJournal = [[GPJournal alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    newJournal.birthDate = [dateFormat dateFromString:self.birthdate.text];
    newJournal.name = self.name.text;
    newJournal.gender = (self.gender.selectedSegmentIndex == 0 ? @"Female" : @"Male");
    newJournal.userId = [GPUserSingleton sharedGPUserSingleton].userId;
    
    NSLog(@"creating a new journal");
    
    //    // Save Singleton Object
    //    GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
    //    [sharedUser setUser:newUser];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[RKObjectManager sharedManager] postObject:newJournal delegate:self];
  }
  
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.name) {
    [self.name resignFirstResponder];
    [self.birthdate becomeFirstResponder];
  }
  return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if (textField == self.birthdate) {
    [self showPicker];
    return NO;  // Hide both keyboard and blinking cursor.
  }
  return YES;
}

#pragma mark - Picker methods

- (void)showPicker
{
  
  _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:nil
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil];
  
  [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
  
  CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
  
  self.datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
  [self.datePicker setDatePickerMode:UIDatePickerModeDate];
  [self.datePicker setMaximumDate:[NSDate date]];
  
  [self.actionSheet addSubview:self.datePicker];
  
  UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
  closeButton.momentary = YES;
  closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
  closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
  closeButton.tintColor = [UIColor blackColor];
  [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
  [_actionSheet addSubview:closeButton];
  
  [_actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  
  [UIView beginAnimations:nil context:nil];
  [_actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
  [UIView commitAnimations];
  
}

- (void)dismissActionSheet:(id)sender{
  // Dismiss the action sheet and set the selected provider
  [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  NSDate *bday = self.datePicker.date;
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MM/dd/YYYY"];
  NSString *dateString = [dateFormat stringFromDate:bday];
  [self.birthdate setText:dateString];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == CREATED_TAG) {
    
    // Call delegate method to reload journals
    if([self.delegate respondsToSelector:@selector(reloadJournals:)]) {
      
      NSLog(@"it should see this");
      
      [self.delegate reloadJournals:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark - RestKit Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  if ([request isPOST]) {
    if ([response statusCode] == 201) {
      UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"JOURNAL_CREATED_HEADING", nil)
                                                            message:NSLocalizedString(@"JOURNAL_CREATED_MESSAGE", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TITLE", nil)
                                                  otherButtonTitles:nil];
      [successAlert setTag:CREATED_TAG];
      [successAlert show];
    }
    else {
      [GPHelpers showAlertWithMessage:[NSString stringWithFormat:@"Unexpected Response %i", [response statusCode]] andHeading:NSLocalizedString(@"JOURNAL_NOT_CREATED_HEADING", nil)];
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
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader failed with error: %@", error);
}

@end
