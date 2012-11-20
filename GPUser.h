//
//  GPUser.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/19/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPUser : NSObject

@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSString *email;
@property NSInteger userId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *updatedDate;

+ (RKObjectMapping *)mapping;

@end
