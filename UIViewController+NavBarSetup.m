//
//  UIViewController+NavBarSetup.m
//  GrowingPains
//
//  Created by Kyle Clegg on 1/27/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import "UIViewController+NavBarSetup.h"

@implementation UIViewController (NavBarSetup)

- (void) setupBackButton:(UINavigationItem *)navItem {
  
  DLog(@"setting up back button");
  
  // Set the back button title
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                 initWithTitle: @"Back"
                                 style: UIBarButtonItemStyleBordered
                                 target: nil action: nil];
  
  [navItem setBackBarButtonItem: backButton];
  
}

@end
