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

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  
  UILabel *nameLabel = (UILabel *)[cell viewWithTag:6];
  
  // We may want to loop through rather than set each individually
  UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:1];
  UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:2];
  
  nameLabel.text = @"Eva";
  
  UIImage* myImage1 = [UIImage imageNamed:@"baby-girl.jpeg"];
  [imageView1 setImage:myImage1];

  UIImage* myImage2 = [UIImage imageNamed:@"cutebaby.jpeg"];
  [imageView2 setImage:myImage2];
  
  // Make it a circle
  imageView1.layer.cornerRadius = 25.0;
  imageView1.layer.masksToBounds = YES;
  
  // Add a thin border
  imageView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
  imageView1.layer.borderWidth = 1.0;

  // Make it a circle
  imageView2.layer.cornerRadius = 25.0;
  imageView2.layer.masksToBounds = YES;
  
  // Add a thin border
  imageView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
  imageView2.layer.borderWidth = 1.0;
}

@end
