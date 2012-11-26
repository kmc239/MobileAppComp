//
//  GPHomeScreenViewController.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/14/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPHomeScreenViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKRequestDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) IBOutlet UITableView *_tableView;

@end
