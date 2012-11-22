//
//  GPLoginViewController.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface GPLoginViewController : UIViewController <RKRequestDelegate, RKObjectLoaderDelegate>

- (IBAction)loginPressed:(id)sender;

@end
