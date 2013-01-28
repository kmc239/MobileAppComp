//
//  GPHelpers.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPHelpers.h"
#import "GPUserSingleton.h"
#import <RestKit/RestKit.h>

@implementation GPHelpers

+ (void) showAlertWithMessage:(NSString *)message andHeading:(NSString *)heading {
	UIAlertView *newView = [[UIAlertView alloc]initWithTitle:heading message:message delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TITLE", nil) otherButtonTitles:nil];
	[newView show];
}

+ (BOOL) isValidName:(NSString *)name {
  
  return name.length > 0 ? YES : NO;
}

+ (BOOL) isValidEmail:(NSString *)emailAddress {
  
  // Email validation regex
	NSString *emailRegex =
  @"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  
  return [emailTest evaluateWithObject:emailAddress];
}

+ (BOOL) isValidPassword:(NSString *)password {
	if ([password length] >= 6) {
		return YES;
	}
	return NO;
}

+ (void)setCustomFontsForTitle:(NSString *)title forViewController:(UIViewController *)controller {
  
  int height = controller.navigationController.navigationBar.frame.size.height;
  int width = controller.navigationController.navigationBar.frame.size.width;
  
  UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  navLabel.backgroundColor = [UIColor clearColor];
  navLabel.textColor = [UIColor whiteColor];
  navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  navLabel.font = [UIFont fontWithName:@"Sanchez-Regular" size:22];
  navLabel.textAlignment = NSTextAlignmentCenter;
  navLabel.text = title;
  controller.navigationItem.titleView = navLabel;
  [navLabel sizeToFit];
  
}

// Returns the formatted age of person in terms of months/days from today
+ (NSString *)formattedAge:(NSDate *)birthdate {
  
  double secondsOld = [[NSDate date] timeIntervalSinceReferenceDate] - [birthdate timeIntervalSinceReferenceDate];
  double minutesOld = secondsOld / 60;
  double hoursOld = minutesOld / 60;
  double daysOld = hoursOld / 24;
  double monthsOld = daysOld / 30;    // We should change this to check which month and return 28, 29, 30, or 31 depending
  
  NSInteger monthsOldInt = (NSInteger)monthsOld;
  NSInteger daysOldInMonths = (NSInteger)((int)daysOld % (int)30);
  
  return [NSString stringWithFormat:@"%im %id", monthsOldInt, daysOldInMonths];
}

// Returns the formatted age of person on a give day
+ (NSString *)formattedAgeOfEntryDate:(NSDate *)entryDate withBirthdate:(NSDate *)birthdate {
  
  double secondsOld = [entryDate timeIntervalSinceReferenceDate] - [birthdate timeIntervalSinceReferenceDate];
  double minutesOld = secondsOld / 60;
  double hoursOld = minutesOld / 60;
  double daysOld = hoursOld / 24;
  double monthsOld = daysOld / 30;    // We should change this to check which month and return 28, 29, 30, or 31 depending
  
  NSInteger monthsOldInt = (NSInteger)monthsOld;
  NSInteger daysOldInMonths = (NSInteger)((int)daysOld % (int)30);
  
  return [NSString stringWithFormat:@"%im %id", monthsOldInt, daysOldInMonths];
}

// Helper method that returns a journal for the corresponding journalId
+ (GPJournal *)journalForJournalId:(NSInteger)journalId {
  
  for (GPJournal *journal in [GPUserSingleton sharedGPUserSingleton].journals) {
    if (journal.journalId == journalId) {
      return journal;
    }
  }
  return nil;
}

// Use RestKit to download image asychronously
+ (void)loadImageAsynchronously:(UIImageView *)imageView fromUrlString:(NSString *)urlString {
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  NSURL *imageURL = [NSURL URLWithString:urlString];
  RKRequest* request = [RKRequest requestWithURL: imageURL];

  request.onDidLoadResponse = ^(RKResponse* response) {
    UIImage* image = [UIImage imageWithData: response.body];
    imageView.image = image;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  };
  request.onDidFailLoadWithError = ^(NSError* error) {
    // handle failure to load image
    DLog(@"image error");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  };

  RKRequestQueue *imageLoadingQueue = [RKRequestQueue requestQueueWithName: @"imageLoadingQueue"];
  [imageLoadingQueue start];

  [imageLoadingQueue addRequest: request];
  
}

@end
