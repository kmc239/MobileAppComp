//
//  GPCreateJournalViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

// Delegate to reload journals after new journal is added
@protocol GPCreateJournalViewControllerDelegate <NSObject>

@optional
-(void)reloadJournals:(BOOL)reloadStatus;

@end

@interface GPCreateJournalController : UIViewController <UITextFieldDelegate, RKObjectLoaderDelegate, RKRequestDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *whoForLabel;
@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UISegmentedControl *gender;
@property (nonatomic, strong) IBOutlet UITextField *birthdate;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIDatePicker *datePicker;

- (IBAction)birthdateButton:(id)sender;
- (IBAction)createJournalButton:(id)sender;

@property (nonatomic, assign) id delegate;

@end
