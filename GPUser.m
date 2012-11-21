//
//  GPUser.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/19/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPUser.h"

@implementation GPUser

static RKObjectMapping *mapping;

@synthesize createdDate = _createdDate;
@synthesize email = _email;
@synthesize userId = _userId;
@synthesize name = _name;
@synthesize password = _password;
@synthesize updatedDate = _updatedDate;

+ (void) initialize {
  
  [super initialize];
  
  // Setup the object mapping for API requests.
  if (!mapping) {
    mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping mapKeyPath:@"created_at" toAttribute:@"createdDate"];
    [mapping mapKeyPath:@"email" toAttribute:@"email"];
    [mapping mapKeyPath:@"id" toAttribute:@"userId"];
    [mapping mapKeyPath:@"name" toAttribute:@"name"];
    [mapping mapKeyPath:@"password" toAttribute:@"password"];
    [mapping mapKeyPath:@"updated_at" toAttribute:@"updatedDate"];
  }
}

+ (RKObjectMapping *)mapping {
  return mapping;
}

@end
