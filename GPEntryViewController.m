//
//  GPEntryViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/28/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPEntryViewController.h"
#import "GPHelpers.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>

@interface GPEntryViewController ()

@end

@implementation GPEntryViewController

@synthesize currentEntry = _currentEntry;
@synthesize entryPicture = _entryPicture;
@synthesize descriptionLabel = _descriptionLabel;

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
  
  // Set custom font for title
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"ENTRY", nil) forViewController:self];
  [self.descriptionLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.descriptionLabel.font.pointSize * 0.9]];
  [self.descriptionLabel setText:self.currentEntry.description];
  [self.descriptionLabel sizeToFit];
  
  // Use RestKit to download image asychronously
  GPPicture *picture = self.currentEntry.picture;
  NSString *baseUrl = [[RKClient sharedClient] baseURL].absoluteString;
  NSString *urlString = [NSString stringWithFormat:@"%@%@", baseUrl, picture.pictureUrl];

  [GPHelpers loadImageAsynchronously:self.entryPicture fromUrlString:urlString];
  
  // Make picture circular
  self.entryPicture.layer.cornerRadius = 5.0;
  self.entryPicture.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
