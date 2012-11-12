//
//  GPCreateJournalViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCreateJournalViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UISegmentedControl *gender;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;

- (IBAction)birthdateButton:(id)sender;
- (IBAction)createJournalButton:(id)sender;

@end
