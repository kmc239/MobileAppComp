//
//  GPLoginViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPLoginViewController.h"
#import "GPModels.h"
#import "GPHelpers.h"

@interface GPLoginViewController ()

@end

@implementation GPLoginViewController

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

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  //When a row is selected, the segue creates the detail view controller as the destination.
  //Set the detail view controller's detail item to the item associated with the selected row.
  NSLog(@"test");
  if ([[segue identifier] isEqualToString:@"Login"]) {
    NSLog(@"time to login");
    
    //GetSummary
    NSString *getUserURL = [NSString stringWithFormat:@"/users/1.json"];
    NSLog(@"the get user url is %@", getUserURL);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:getUserURL delegate:self];
  }
}

#pragma mark - RestKit Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
  if ([request isGET]) {
    
    if ([response isOK]) {
      
      if ([response isOK]) {
        
        NSString* responseString = [response bodyAsString];
        NSLog(@"Response is OK:\n\n%@", responseString);
        
      }
    }
  }
  else if ([request isPOST]) {
		
  }
  else if ([request isDELETE]) {
    
    if ([response isNotFound]) {
      NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
    }
	}
}

// Sent when a request has failed due to an error
- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error {
  
	int test = [error code];
	if (test == RKRequestBaseURLOfflineError) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RESTKIT CONNECTION ERROR", nil) andHeading:NSLocalizedString(@"RESTKIT CONNECTION HEADING", nil)];
		return;
	}
}

/**
 * Sent to the delegate when a request has timed out. This is sent when a
 * backgrounded request expired before completion.
 */
- (void)requestDidTimeout:(RKRequest*)request {
  
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RESTKIT LOAD ERROR", nil) andHeading:NSLocalizedString(@"OPERATION FAILED", nil)];
}


#pragma mark - RestKit objectLoader
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  
  if ([[objects objectAtIndex:0] isKindOfClass:[GPUser class]]) {
    
    NSLog(@"it's a gpuser");
    GPUser *gpuser = [objects objectAtIndex:0];
    NSLog(@"user's name is %@", gpuser.name);
  }
  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
  
  NSLog(@"objectLoader failed with error: %@", error);
}

@end
