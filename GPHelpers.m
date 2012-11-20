//
//  GPHelpers.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPHelpers.h"

@implementation GPHelpers

+ (void) showAlertWithMessage:(NSString *)message andHeading:(NSString *)heading {
	UIAlertView *newView = [[UIAlertView alloc]initWithTitle:heading message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[newView show];
}

@end
