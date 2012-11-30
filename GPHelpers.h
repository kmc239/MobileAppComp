//
//  GPHelpers.h
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPModels.h"

@interface GPHelpers : NSObject

+ (void) showAlertWithMessage:(NSString *)message andHeading:(NSString *)heading;
+ (BOOL) isValidName:(NSString *)name;
+ (BOOL) isValidEmail:(NSString* )emailAddress;
+ (BOOL) isValidPassword:(NSString *)password;
+ (void)setCustomFontsForTitle:(NSString *)title forViewController:(UIViewController *)controller;
+ (NSString *)formattedAge:(NSDate *)birthdate;
+ (NSString *)formattedAgeOfEntryDate:(NSDate *)entryDate withBirthdate:(NSDate *)birthdate;
+ (GPJournal *)journalForJournalId:(NSInteger)journalId;

@end
