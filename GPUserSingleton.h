//
//  GPUserSingleton.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPModels.h"

@interface GPUserSingleton : NSObject

@property (nonatomic, retain) NSString *email;
@property NSInteger userId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSArray *journals;
@property (nonatomic, retain) NSArray *posts;
@property (nonatomic, assign) BOOL userIsSet;

+ (GPUserSingleton *)sharedGPUserSingleton;
- (void)setUser:(GPUser *)user;

@end
