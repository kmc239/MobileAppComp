//
//  GPCreateEntryViewController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/16/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPCreateEntryViewController.h"

@interface GPCreateEntryViewController ()

@end

@implementation GPCreateEntryViewController

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


- (IBAction)takePicture:(UIButton *)sender
{
//  UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//  ipc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//  
//  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//  {
//    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//  }
//  else
//  {
//    NSLog(@"Camera is not currently available.");
//  }
//  
//  [self.navigationController presentViewController:ipc animated:YES completion:^{
//    NSLog(@"Modal view should have loaded.");
//  }];
}

@end
