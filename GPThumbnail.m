//
//  GPThumbnail.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPThumbnail.h"

@implementation GPThumbnail

static RKObjectMapping *mapping;

@synthesize thumbnailUrl = _thumbnailUrl;

+ (void)initialize
{
  [super initialize];
  
  // Setup the object mapping for API requests.
  if (!mapping)
  {
    mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping mapKeyPath:@"url" toAttribute:@"thumbnailUrl"];
  }
}

+ (RKObjectMapping *)mapping
{
  return mapping;
}

@end
