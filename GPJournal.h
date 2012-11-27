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

@property (nonatomic, strong) NSDate *birthDate;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *gender;
@property NSInteger journalId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *updatedDate;
@property NSInteger userId;

+ (RKObjectMapping *)mapping;

@end
