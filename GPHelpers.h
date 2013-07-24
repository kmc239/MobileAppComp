//
//  GPHelpers.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPModels.h"

// System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface GPHelpers : NSObject

+ (void) showAlertWithMessage:(NSString *)message andHeading:(NSString *)heading;
+ (BOOL) isValidName:(NSString *)name;
+ (BOOL) isValidEmail:(NSString* )emailAddress;
+ (BOOL) isValidPassword:(NSString *)password;
+ (void)setCustomFontsForTitle:(NSString *)title forViewController:(UIViewController *)controller;
+ (NSString *)formattedAge:(NSDate *)birthdate;
+ (NSString *)formattedAgeOfEntryDate:(NSDate *)entryDate withBirthdate:(NSDate *)birthdate;
+ (GPJournal *)journalForJournalId:(NSInteger)journalId;
+ (void)loadImageAsynchronously:(UIImageView *)imageView fromUrlString:(NSString *)urlString;

@end
