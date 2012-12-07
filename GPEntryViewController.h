//
//  GPEntryViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/28/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPEntry.h"

@interface GPEntryViewController : UIViewController

@property (nonatomic, strong) GPEntry *currentEntry;
@property (nonatomic, strong) IBOutlet UIImageView *entryPicture;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
