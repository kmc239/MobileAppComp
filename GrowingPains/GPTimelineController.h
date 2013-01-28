//
//  GPTimelineViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 10/24/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPTimelineController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKRequestDelegate, RKObjectLoaderDelegate>

@property NSInteger currentJournalId;
@property NSArray *entriesFromServer;

@end
