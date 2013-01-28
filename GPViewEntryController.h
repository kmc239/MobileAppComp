//
//  GPEntryViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/28/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPEntry.h"

@interface GPViewEntryController : UIViewController

@property (nonatomic, strong) GPEntry *currentEntry;
@property (nonatomic, strong) IBOutlet UIImageView *entryPicture;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)twitterShare:(id)sender;
- (IBAction)facebookShare:(id)sender;
- (IBAction)instagramShare:(id)sender;

@end
