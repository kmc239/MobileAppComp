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
#import "GPEntryViewController.h"

@interface GPTimelineViewController ()

@end

@implementation GPTimelineViewController

@synthesize currentJournalId = _currentJournalId;
@synthesize entriesFromServer = _entriesFromServer;

- (void)viewDidLoad
{
  [super viewDidLoad];
  DLog(@"Current Journal ID: %i", self.currentJournalId);
  
  [self.tableView setRowHeight:130];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
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
  else if ([segue.identifier isEqualToString:@"View Entry"])
  {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    GPEntry *currentEntry = [self.entriesFromServer objectAtIndex:indexPath.row];
    GPEntryViewController *entryController = segue.destinationViewController;
    entryController.currentEntry = currentEntry;
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
  if ([GPUserSingleton sharedGPUserSingleton] == nil || self.entriesFromServer == nil) {
    return 0;
  }
  else {
    return self.entriesFromServer.count;
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
  if ([GPUserSingleton sharedGPUserSingleton] == nil || self.entriesFromServer == nil) {
    return;
  }
  
  CGFloat nRed=207.0/255.0;
  CGFloat nBlue=209.0/255.0;
  CGFloat nGreen=88.0/255.0;
  UIColor *greenColor=[[UIColor alloc]initWithRed:nRed green:nBlue blue:nGreen alpha:1];
  
  GPEntry *currentEntry = [self.entriesFromServer objectAtIndex:indexPath.row];
  
  // Update the date
  UILabel *dateLabel = (UILabel *)[cell viewWithTag:1];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM. d"];
  dateLabel.text = [formatter stringFromDate:currentEntry.createdDate];
  dateLabel.font = [UIFont fontWithName:@"Sanchez-Regular" size:dateLabel.font.pointSize * 0.9];
  dateLabel.textColor = [UIColor darkGrayColor];
  
  // Update the age
  UILabel *ageLabel = (UILabel *)[cell viewWithTag:2];
  ageLabel.text = [GPHelpers formattedAgeOfEntryDate:currentEntry.createdDate withBirthdate:[GPHelpers journalForJournalId:self.currentJournalId].birthDate];
  ageLabel.font = [UIFont fontWithName:@"Sanchez-Regular" size:ageLabel.font.pointSize * 0.9];
  ageLabel.textColor = greenColor;
  
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
  pictureImageView.layer.borderColor = greenColor.CGColor;
  pictureImageView.layer.borderWidth = 2.0;
  
  // Update the description
  UILabel *description = (UILabel *)[cell viewWithTag:4];
  description.text = currentEntry.description;
  description.font = [UIFont fontWithName:@"Sanchez-Regular" size:description.font.pointSize * 0.9];
  description.textColor = [UIColor darkGrayColor];
  
  // Update the time
  UILabel *time = (UILabel *)[cell viewWithTag:5];
  [formatter setDateFormat:@"HH:mm a"];
  time.text = [[formatter stringFromDate:currentEntry.createdDate] lowercaseString];
  time.font = [UIFont fontWithName:@"Sanchez-Regular" size:time.font.pointSize * 0.9];
  time.textColor = greenColor;

  // Round the corners on the white background
  UIView *whiteBackground = (UIView *)[cell viewWithTag:6];
  whiteBackground.layer.cornerRadius = 5.0;
  whiteBackground.layer.masksToBounds = YES;
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
    
    // Save entries to local object
    self.entriesFromServer = userEntries.entry;
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
