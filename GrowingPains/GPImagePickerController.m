//
//  GPImagePickerController.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/17/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>

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
    
    // Check camera availability
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Set source type
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Only capture still images
        self.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        
        // Allow editting
        self.allowsEditing = YES;
        
        // Set the delegate
        self.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self.parentViewController;
    }
    else
    {
        NSLog(@"Camera is not available.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
