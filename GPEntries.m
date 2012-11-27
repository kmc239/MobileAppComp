//
//  GPEntries.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPEntries.h"

@implementation GPEntries

static RKObjectMapping *mapping;

@synthesize entry = _entry;

+ (void)initialize
{
    [super initialize];
    
    // Setup the object mapping for API requests.
    if (!mapping) {
        mapping = [RKObjectMapping mappingForClass:[self class]];
    }
}

+ (RKObjectMapping *)mapping
{
    return mapping;
}

@end
