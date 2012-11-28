//
//  GPSettingsViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPSettingsViewController.h"
#import "GPUserSingleton.h"
#import "STKeychain.h"
#import "GPConstants.h"
#import "GPHelpers.h"

@interface GPSettingsViewController ()

@end

@implementation GPSettingsViewController

@synthesize nameLabel = _nameLabel;
@synthesize emailLabel = _emailLabel;
@synthesize nameTitleLabel = _nameTitleLabel;
@synthesize emailTitleLabel = _emailTitleLabel;

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

  // Set custom fonts
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"SETTINGS", nil) forViewController:self];
  [self.nameLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.nameLabel.font.pointSize * 0.9]];
  [self.emailLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.emailLabel.font.pointSize * 0.9]];
  [self.nameTitleLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.nameTitleLabel.font.pointSize * 0.9]];
  [self.emailTitleLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.emailTitleLabel.font.pointSize * 0.9]];  
  
  self.nameLabel.text = [GPUserSingleton sharedGPUserSingleton].name;
  self.emailLabel.text = [GPUserSingleton sharedGPUserSingleton].email;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)logoutPressed:(id)sender {
  
  [STKeychain deleteItemForUsername:[GPUserSingleton sharedGPUserSingleton].email andServiceName:kSTKeychainServiceName error:nil];
  [[GPUserSingleton sharedGPUserSingleton] clearSharedUserInfo];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
