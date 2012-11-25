//
//  GPJournal.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/23/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPJournal : NSObject

@property (nonatomic, retain) NSDate *birthDate;
@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSString *gender;
@property NSInteger journalId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *updatedDate;
@property NSInteger userId;

+ (RKObjectMapping *)mapping;

@end
