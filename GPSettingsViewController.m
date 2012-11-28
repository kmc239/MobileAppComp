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
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"SETTINGS", nil) forViewController:self];
  
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
