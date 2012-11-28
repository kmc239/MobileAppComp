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
#import <QuartzCore/QuartzCore.h>
#import "GPCreateEntryViewController.h"

@interface GPTimelineViewController ()

@end

@implementation GPTimelineViewController

@synthesize currentJournalId = _currentJournalId;

- (void)viewDidLoad
{
  [super viewDidLoad];
  DLog(@"Current Journal ID: %i", self.currentJournalId);
  
  [self.tableView setRowHeight:150];
  
  // Load entries
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  NSLog(@"\n\nGETTING ENTRIES\n\n");
  NSString *getEntriesURL = [NSString stringWithFormat:@"/journals/%i/entries.json", self.currentJournalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:getEntriesURL delegate:self];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Create Entry"])
  {
    GPCreateEntryViewController *entryController = segue.destinationViewController;
    entryController.currentJournalId = self.currentJournalId;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSString *cellType = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
  DLog(@"selected %@", cellType);
  
  if ([cellType isEqualToString:@"EntryCell"]) {
    [self performSegueWithIdentifier:@"View Entry" sender:self];
  }
  
  // Must do this last so that prepareForSegue:sender: can access indexPath
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // If there is no sharedUser or no entries for the given user, return 0 and set a loading/add entries message
  if ([GPUserSingleton sharedGPUserSingleton] == nil || [GPUserSingleton sharedGPUserSingleton].entries == nil) {
    return 0;
  }
  else {
    return [GPUserSingleton sharedGPUserSingleton].entries.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
	static NSString *CellIdentifier = @"EntryCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    [self tableViewCellWithReuseIdentifier:CellIdentifier];
  }
  // Configure the cell...
  [self configureCell:cell forIndexPath:indexPath];
  
	return cell;
}

- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier
{
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
  
  // If there is no sharedUser or no entries for the given user, return
  if ([GPUserSingleton sharedGPUserSingleton] == nil || [GPUserSingleton sharedGPUserSingleton].entries == nil) {
    return;
  }
  
  GPEntry *currentEntry = [[GPUserSingleton sharedGPUserSingleton].entries objectAtIndex:indexPath.row];
  
  // Update the date
  UILabel *dateLabel = (UILabel *)[cell viewWithTag:1];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d"];
  dateLabel.text = [formatter stringFromDate:currentEntry.createdDate];
  
  // Update the time
//  UILabel *timeLabel = (UILabel *)[cell viewWithTag:2];
  
  // Load the picture
  UIImageView *pictureImageView = (UIImageView *)[cell viewWithTag:3];
  GPPicture *picture = currentEntry.picture;
  GPThumbnail *thumbnail = picture.thumbnail;
  NSString *baseUrl = [[RKClient sharedClient] baseURL].absoluteString;
  NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseUrl, thumbnail.thumbnailUrl]];
  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  UIImage *image = [UIImage imageWithData:imageData];
  pictureImageView.image = image;
  
  // Make picture circular
  pictureImageView.layer.cornerRadius = 40.0;
  pictureImageView.layer.masksToBounds = YES;
  
  // Add a thin border
//    previewImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    previewImageView.layer.borderWidth = 0.5;
  
  // Update the description
  UILabel *description = (UILabel *)[cell viewWithTag:4];
  description.text = currentEntry.description;
  
}


#pragma mark - RestKit Request Delegate Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  if ([request isGET]) {
    
    if ([response isOK]) {
      
      if ([response isOK]) {
        
//        NSString *responseString = [response bodyAsString];
//        NSLog(@"Response is OK:\n\n%@", responseString);
        
      }
    }
  }
  else if ([request isPOST]) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"POST finished with status code: %i", [response statusCode]);
  }
  else if ([request isDELETE]) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([response isNotFound]) {
      NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
    }
	}
}

// Sent when a request has failed due to an error
- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	int test = [error code];
	if (test == RKRequestBaseURLOfflineError)
  {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_CONNECTION_ERROR", nil) andHeading:NSLocalizedString(@"RK_CONNECTION_ERROR_HEADING", nil)];
		return;
	}
}

// Sent to the delegate when a request has timed out
- (void)requestDidTimeout:(RKRequest*)request
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_REQUEST_TIMEOUT", nil) andHeading:NSLocalizedString(@"RK_OPERATION_FAILED", nil)];
}


#pragma mark - RestKit objectLoader
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  if ([[objects objectAtIndex:0] isKindOfClass:[GPEntries class]]) {
    
    GPEntries *userEntries = [objects objectAtIndex:0];
    DLog(@"User has %i entries", userEntries.entry.count);
    
    // Save Singleton Object
    GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
    [sharedUser setUserEntries:userEntries.entry];
  }
  
  // Force the tableview to reload, now with new entry information
  [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader failed with error: %@", error);
}

@end
