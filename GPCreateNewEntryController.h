//
//  GPCreateNewEntryController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 1/27/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCreateNewEntryController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property NSInteger currentJournalId;
@property (strong, nonatomic) IBOutlet UIImageView *capturedImage;
@property (strong, nonatomic) IBOutlet UITextView *entryDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)createEntry:(id)sender;
- (IBAction)retakeImage:(id)sender;

@end
