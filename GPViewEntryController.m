//
//  GPEntryViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/28/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPViewEntryController.h"
#import "GPHelpers.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "Twitter/TWTweetComposeViewController.h"
#import <Social/Social.h>
#import "UIViewController+NavBarSetup.h"

@interface GPViewEntryController ()

@end

@implementation GPViewEntryController 

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Setup back button
  [self setupBackButton:self.navigationItem];
  
  // Set custom font for title
  [GPHelpers setCustomFontsForTitle:NSLocalizedString(@"ENTRY", nil) forViewController:self];
  [self.descriptionLabel setFont:[UIFont fontWithName:@"Sanchez-Regular" size:self.descriptionLabel.font.pointSize]];
  [self.descriptionLabel setText:self.currentEntry.description];
  [self.descriptionLabel sizeToFit];
  
  // Use RestKit to download image asychronously
  GPPicture *picture = self.currentEntry.picture;
  GPMidsize *midsize = picture.midsize;
  [GPHelpers loadImageAsynchronously:self.entryPicture fromUrlString:midsize.midsizeUrl];
  
  // Make picture circular
  self.entryPicture.layer.cornerRadius = 5.0;
  self.entryPicture.layer.masksToBounds = YES;
}

- (IBAction)twitterShare:(id)sender
{
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
      UIGraphicsBeginImageContextWithOptions(self.entryPicture.bounds.size, NO, 0.0);
      [self.entryPicture.image drawInRect:CGRectMake(0, 0, self.entryPicture.frame.size.width, self.entryPicture.frame.size.height)];
      UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
      [tweetVC setInitialText:[NSString stringWithFormat:@"%@ - day ## via @growingpainsapp", self.currentEntry.description]];
      
      // add image
      [tweetVC addImage:SaveImage];
      tweetVC.completionHandler = ^(SLComposeViewControllerResult result) {
        if(result == SLComposeViewControllerResultDone) {
          DLog(@"Tweet Sent");
        } else if(result == SLComposeViewControllerResultCancelled) {
          DLog(@"Tweet Cancelled");
        }
        [self dismissViewControllerAnimated:YES completion:nil];
      };
      
      [self presentViewController:tweetVC animated:YES completion:nil];
    } else {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Fail" message:@"You can't send a tweet right now. Make sure you have at least one Twitter account setup." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alertView show];
    }
  } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Fail" message:@"You must upgrade to iOS 6 to send tweets." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  }
  
  /////////////////////////
  
//  Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
//  
//  if(tweeterClass != nil) {   // check for Twitter integration
//    
//    // check Twitter accessibility and at least one account is setup
//    if([TWTweetComposeViewController canSendTweet]) {
//      
//      UIGraphicsBeginImageContextWithOptions(self.entryPicture.bounds.size, NO, 0.0);
//      [self.entryPicture.image drawInRect:CGRectMake(0, 0, self.entryPicture.frame.size.width, self.entryPicture.frame.size.height)];
//      UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
//      UIGraphicsEndImageContext();
//      
//      TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
//      [tweetViewController setInitialText:[NSString stringWithFormat:@"%@ - day 16 via @growingpainsapp", self.currentEntry.description]];
//      
//      // add image
//      [tweetViewController addImage:SaveImage];
//      tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
//        
//        if(result == TWTweetComposeViewControllerResultDone) {
//          DLog(@"Tweet Sent");
//        } else if(result == TWTweetComposeViewControllerResultCancelled) {
//          DLog(@"Tweet Cancelled");
//        }
//        [self dismissViewControllerAnimated:YES completion:nil];
//      };
//      
//      [self presentViewController:tweetViewController animated:YES completion:nil];
//      
//    }
//    else {
//      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure you have at least one Twitter account setup" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//      [alertView show];
//    }
//  } else {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You must upgrade to iOS 5 in order to send tweets from Growing Pains" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
//  }
}

- (IBAction)facebookShare:(id)sender
{
  
}

- (IBAction)instagramShare:(id)sender
{
  
}

@end
