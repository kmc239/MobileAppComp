//
//  GPTimelineViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPTimelineViewController.h"
#import "AFNetworking.h"

@interface GPTimelineViewController ()

@end

@implementation GPTimelineViewController

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

- (IBAction)postNew:(id)sender {
  NSLog(@"posting");
  
  
  NSURL *url = [NSURL URLWithString:@"http://localhost:3000/"];
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
  
  // Create our JSON array using an NSDictionary
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init ];
  
  // User and password params, put into password dictionary
  [params setObject:@"kyle" forKey:@"name"];
  [params setObject:@"post title" forKey:@"title"];
  [params setObject:@"this is the content dawg" forKey:@"content"];
  
  NSLog(@"params: %@", params);
  
//  NSMutableURLRequest *request = [[httpClient requestWithMethod:@"POST" path:<#(NSString *)#> parameters:<#(NSDictionary *)#>]]
  
  [httpClient postPath: @"posts" parameters:params
             success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
               NSLog (@"SUCCESS");
              
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"FAILED");
               NSLog(@"error: %@", [error description]);
             }
   ];
}

@end
