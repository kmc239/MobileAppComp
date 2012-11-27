//
//  GPEntry.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "GPPicture.h"

@interface GPEntry : NSObject

@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSString *description;
@property NSInteger entryId;
@property NSInteger journalId;
@property (nonatomic, strong) GPPicture *picture;
@property (nonatomic, strong) NSDate *updatedDate;

+ (RKObjectMapping *)mapping;

@end