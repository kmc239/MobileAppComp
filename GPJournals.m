//
//  GPJournals.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/23/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPJournals.h"

@implementation GPJournals

static RKObjectMapping *mapping;

@synthesize journals = _journals;

+ (void) initialize {
  
  [super initialize];
  
  // Setup the object mapping for API requests.
  if (!mapping) {
    mapping = [RKObjectMapping mappingForClass:[self class]];
  }
}

+ (RKObjectMapping *)mapping {
  return mapping;
}

@end
