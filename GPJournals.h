//
//  GPJournals.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/23/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPJournals : NSObject

@property (nonatomic, retain) NSArray *journals;

+ (RKObjectMapping *)mapping;

@end
