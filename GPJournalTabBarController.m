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
}

@end
