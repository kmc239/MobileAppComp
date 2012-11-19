//
//  GPHomeScreenViewController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/14/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPHomeScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GPHomeScreenViewController ()

@end

@implementation GPHomeScreenViewController

@synthesize _tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.tableView setRowHeight:130];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)fetchedData:(NSData *)responseData {
//  // Parse out the json data
//  NSError* error;
//  NSArray* journals = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
//  
//  NSLog(@"Journals: %@", journals);
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSString *cellType = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
  
  NSLog(@"selected %@", cellType);
  
  if ([cellType isEqualToString:@"JournalCell"]) {
      [self performSegueWithIdentifier:@"Open Journal" sender:self];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
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

//#define bgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//#define journalsURL [NSURL URLWithString:@"https://lola9.herokuapp.com/journals.josn"]

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  
  UILabel *journalNameLabel = (UILabel *)[cell viewWithTag:6];
  
//  dispatch_async(bgQueue, ^{
//    NSData *data = [NSData dataWithContentsOfURL:journalsURL];
//    [self performSelectorOnMainThread:@selector(fetchedData:)
//                           withObject:data waitUntilDone:YES];
//  });
  
  // Loop through five images
  for (int tag = 1; tag <= 5; tag++) {
    journalNameLabel.text = @"Eva Maria Gonzalez Pereira";   // Change to dynamically load name from db
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:tag];
    UIImage *image = [UIImage imageNamed:@"cutebaby.jpeg"];   // Change to dynamically load image from db
    [imageView setImage:image];
    
    // Make image circular
    imageView.layer.cornerRadius = 24.0;
    imageView.layer.masksToBounds = YES;
    
    // Add a thin border
//    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    imageView.layer.borderWidth = 0.5;
  }

}

@end
