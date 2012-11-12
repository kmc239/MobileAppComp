//
//  GPCreateJournalViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPCreateJournalViewController.h"

@interface GPCreateJournalViewController ()

@end

@implementation GPCreateJournalViewController

@synthesize actionSheet = _actionSheet;
@synthesize datePicker = _datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
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

- (IBAction)birthdateButton:(id)sender {
  
  [self showPicker];
}

- (IBAction)createJournalButton:(id)sender {
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.name) {
    [textField resignFirstResponder];
  }
  return NO;
}

#pragma mark - Picker methods

- (void)showPicker {
  
  _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:nil
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil];
  
  [_actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
  
  CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
  
  UIDatePicker *datePickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
  [datePickerView setDatePickerMode:UIDatePickerModeDate];
  [datePickerView setMaximumDate:[NSDate date]];
  
  [self.actionSheet addSubview:datePickerView];
  
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
 
}


@end
