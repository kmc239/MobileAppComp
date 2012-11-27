//
//  GPTimelineViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPTimelineViewController.h"

@interface GPTimelineViewController ()

@end

@implementation GPTimelineViewController

@synthesize currentJournalId = _currentJournalId;

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

    DLog(@"Current Journal ID: %i", self.currentJournalId);
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"Current Journal ID: %i", self.currentJournalId);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
