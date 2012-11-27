//
//  GPPicture.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPPicture.h"

@implementation GPPicture

static RKObjectMapping *mapping;

@synthesize pictureUrl = _pictureUrl;
@synthesize thumbnail = _thumbnail;

+ (void)initialize
{
  [super initialize];
  
  // Setup the object mapping for API requests.
  if (!mapping)
  {
    mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping mapKeyPath:@"url" toAttribute:@"pictureUrl"];
  }
}

+ (RKObjectMapping *)mapping
{
  return mapping;
}

@end
