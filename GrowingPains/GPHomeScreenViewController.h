//
//  GPHomeScreenViewController.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/14/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "GPCreateJournalViewController.h"

@interface GPHomeScreenViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKRequestDelegate, RKObjectLoaderDelegate, GPCreateJournalViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
