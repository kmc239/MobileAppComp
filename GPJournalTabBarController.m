//
//  GPJournalTabBarController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPJournalTabBarController.h"
#import "GPTimelineViewController.h"
#import "GPHelpers.h"
#import "GPCreateEntryViewController.h"
#import "UIViewController+NavBarSetup.h"

@interface GPJournalTabBarController ()

@end

@implementation GPJournalTabBarController

@synthesize currentJournalId = _currentJournalId;

- (void)viewDidLoad
{
  GPTimelineViewController *timelineController = (GPTimelineViewController *) [self.viewControllers objectAtIndex:0];
  timelineController.currentJournalId = self.currentJournalId;
  
  // Set custom font for title
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"TIMELINE", nil) forViewController:self];
  
  // Setup back button for subsequent VCs
  [self setupBackButton:self.navigationItem];
  
  // Style the tab bar
  CGFloat nRed = 235.0/255.0;
  CGFloat nGreen = 235.0/255.0;
  CGFloat nBlue = 235.0/255.0;
  UIColor *grayBackgroundColor = [UIColor colorWithRed:nRed green:nGreen blue:nBlue alpha:1.0];
  [self.tabBar setBackgroundColor:grayBackgroundColor];
  
  UIImage *tabBarBg = [UIImage imageNamed:@"TabBar.png"];
  [self.tabBar setBackgroundImage:tabBarBg];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Create Entry"])
  {
    GPCreateEntryViewController *entryController = segue.destinationViewController;
    entryController.currentJournalId = self.currentJournalId;
    
    NSLog(@"current journal id is %i", self.currentJournalId);
  }
}

@end
