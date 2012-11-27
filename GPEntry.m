//
//  GPEntry.m
//  GrowingPains
//
//  Created by Taylor McGann on 11/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPEntry.h"

@implementation GPEntry

static RKObjectMapping *mapping;

@synthesize createdDate = _createdDate;
@synthesize description = _description;
@synthesize entryId = _entryId;
@synthesize journalId = _journalId;
@synthesize picture = _picture;
@synthesize updatedDate = _updatedDate;

+ (void)initialize
{
    [super initialize];
    
    // Setup the object mapping for API requests.
    if (!mapping)
    {
        mapping = [RKObjectMapping mappingForClass:[self class]];
        
        [mapping mapKeyPath:@"created_at" toAttribute:@"crearedDate"];
        [mapping mapKeyPath:@"description" toAttribute:@"description"];
        [mapping mapKeyPath:@"id" toAttribute:@"entryId"];
        [mapping mapKeyPath:@"journal_id" toAttribute:@"journalId"];
        [mapping mapKeyPath:@"updated_at" toAttribute:@"updatedDate"];
    }
}

+ (RKObjectMapping *)mapping
{
    return mapping;
}

@end
