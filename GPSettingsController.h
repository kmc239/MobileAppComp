//
//  GPSettingsViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSettingsController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailTitleLabel;

- (IBAction)logoutPressed:(id)sender;

@end
