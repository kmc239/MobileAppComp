//
//  GPImagePickerController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/17/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPImagePickerController.h"

@interface GPImagePickerController ()

@end

@implementation GPImagePickerController

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
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
      self.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
      NSLog(@"Camera is not currently available.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
