//
//  GPViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 9/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPViewController.h"

@interface GPViewController ()

@end

@implementation GPViewController

@synthesize _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  

//  [self performSegueWithIdentifier:@"newScreen" sender:self];

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

@end
