//
//  GPMidsize.m
//  GrowingPains
//
//  Created by Kyle Clegg on 12/29/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPMidsize.h"

@implementation GPMidsize

static RKObjectMapping *mapping;

@synthesize midsizeUrl = _midsizeUrl;

+ (void)initialize
{
  [super initialize];
  
  // Setup the object mapping for API requests.
  if (!mapping)
  {
    mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping mapKeyPath:@"url" toAttribute:@"midsizeUrl"];
  }
}

+ (RKObjectMapping *)mapping
{
  return mapping;
}


@end
