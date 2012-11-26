//
//  GPJournal.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/23/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPJournal.h"

@implementation GPJournal

static RKObjectMapping *mapping;

@synthesize birthDate = _birthDate;
@synthesize createdDate = _createdDate;
@synthesize gender = _gender;
@synthesize journalId = _journalId;
@synthesize name = _name;
@synthesize updatedDate = _updatedDate;
@synthesize userId = _userId;

+ (void) initialize {
  
  [super initialize];
  
  // Setup the object mapping for API requests.
  if (!mapping) {
    mapping = [RKObjectMapping mappingForClass:[self class]];

    [mapping mapKeyPath:@"birthdate" toAttribute:@"birthDate"];    
    [mapping mapKeyPath:@"created_at" toAttribute:@"createdDate"];
    [mapping mapKeyPath:@"gender" toAttribute:@"gender"];
    [mapping mapKeyPath:@"id" toAttribute:@"journalId"];
    [mapping mapKeyPath:@"name" toAttribute:@"name"];
    [mapping mapKeyPath:@"updated_at" toAttribute:@"updatedDate"];
    [mapping mapKeyPath:@"user_id" toAttribute:@"userId"];
  }
}

+ (RKObjectMapping *)mapping {
  return mapping;
}

@end
