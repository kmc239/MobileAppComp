//
//  GPTimelineViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPTimelineViewController.h"
#import <RestKit/RestKit.h>
#import "GPUserSingleton.h"
#import "GPHelpers.h"
#import "GPEntries.h"

@interface GPTimelineViewController ()

@end

@implementation GPTimelineViewController

@synthesize currentJournalId = _currentJournalId;

- (void)viewDidLoad
{
  [super viewDidLoad];

  DLog(@"Current Journal ID: %i", self.currentJournalId);
  
  // Load entries
  NSLog(@"\n\nGETTING ENTRIES\n\n");
  NSString *getEntriesURL = [NSString stringWithFormat:@"/journals/%i/entries.json", self.currentJournalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:getEntriesURL delegate:self];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSString *cellType = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
  
  NSLog(@"selected %@", cellType);
  
  if ([cellType isEqualToString:@"EntryCell"]) {
    [self performSegueWithIdentifier:@"Open Entry" sender:self];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  // If there is no sharedUser or no journals for the given user, return 0 and set a loading/add journals message
  if ([GPUserSingleton sharedGPUserSingleton] == nil || [GPUserSingleton sharedGPUserSingleton].journals == nil) {
    return 0;
  }
  else {
    return [GPUserSingleton sharedGPUserSingleton].journals.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
	static NSString *CellIdentifier = @"JournalCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    [self tableViewCellWithReuseIdentifier:CellIdentifier];
  }
  // Configure the cell...
  [self configureCell:cell forIndexPath:indexPath];
  
	return cell;
}

- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier {
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  
  // If there is no sharedUser or no journals for the given user, return
  if ([GPUserSingleton sharedGPUserSingleton] == nil || [GPUserSingleton sharedGPUserSingleton].journals == nil) {
    return;
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
    
    NSLog(@"POST finished with status code: %i", [response statusCode]);
		
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
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_CONNECTION_ERROR", nil) andHeading:NSLocalizedString(@"RK_CONNECTION_ERROR_HEADING", nil)];
		return;
	}
}

// Sent to the delegate when a request has timed out
- (void)requestDidTimeout:(RKRequest*)request {
  
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_REQUEST_TIMEOUT", nil) andHeading:NSLocalizedString(@"RK_OPERATION_FAILED", nil)];
}


#pragma mark - RestKit objectLoader
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  
  NSLog(@"here");
  
  if ([[objects objectAtIndex:0] isKindOfClass:[GPEntries class]]) {
    
    GPEntries *userEntries = [objects objectAtIndex:0];
    NSLog(@"User has %i entries", userEntries.entry.count);
    
    // Save Singleton Object
    GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
    [sharedUser setUserEntries:userEntries.entry];
  }
  
  // Force the tableview to reload, now with new entry information
  [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
  
  NSLog(@"objectLoader failed with error: %@", error);
}


@end
