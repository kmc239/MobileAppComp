//
//  GPSettingsViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

- (IBAction)logoutPressed:(id)sender;

@end
