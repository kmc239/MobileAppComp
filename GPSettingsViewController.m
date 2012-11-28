//
//  GPSettingsViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPSettingsViewController.h"
#import "GPUserSingleton.h"

@interface GPSettingsViewController ()

@end

@implementation GPSettingsViewController

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

#pragma mark - Actions
- (IBAction)logoutPressed:(id)sender {
  
  [[GPUserSingleton sharedGPUserSingleton] clearSharedUserInfo];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
