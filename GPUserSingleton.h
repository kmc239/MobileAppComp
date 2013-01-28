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

@property (nonatomic, strong) NSString *email;
@property NSInteger userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *journals;
@property (nonatomic, assign) BOOL userIsSet;

+ (GPUserSingleton *)sharedGPUserSingleton;
- (void)setUser:(GPUser *)user;
- (void)setUserJournals:(NSArray *)journals withString:(NSString *)jsonJournals;
- (void)setLatestImageUrls:(NSArray *)entries;
- (NSMutableDictionary *)latestImageUrlsForJournal:(NSInteger)journalId;
- (void)clearSharedUserInfo;

@end
