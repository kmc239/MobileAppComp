//
//  GPUserSingleton.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPUserSingleton.h"
#import "SynthesizeSingleton.h"
#import "GPConstants.h"
#import <RestKit/RKJSONParserJSONKit.h>

@implementation GPUserSingleton

SYNTHESIZE_SINGLETON_FOR_CLASS(GPUserSingleton);

@synthesize email = _email;
@synthesize userId = _userId;
@synthesize name = _name;
@synthesize password = _password;
@synthesize journals = _journals;
@synthesize userIsSet = _userIsSet;

+ (void)initialize {
  
  [super initialize];
  
  GPUserSingleton *userSingleton = [self sharedGPUserSingleton];
  
  // Check if the user is set (also an NSUserDefaults value)
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  userSingleton.userIsSet = [defaults boolForKey:kGPUserDefaultsUserIsSet];
  
  // If the userSingleton is there, load everything
  if (userSingleton.userIsSet) {
    
    userSingleton.email = [defaults objectForKey:kGPUserDefaultsUserEmail];
    userSingleton.name = [defaults objectForKey:kGPUserDefaultsUserName];
    userSingleton.userId = [defaults integerForKey:kGPUserDefaultsUserId];
    
    // Load journals JSON string rather than array because NSArrays cannot be saved in NSUserDefaults
    NSString *journalsJSON = [defaults objectForKey:kGPUserDefaultsJournals];
    
    // If journals JSON string is not null then we will use RK's JSON parser to parse it into a GPJournals Object
    if (journalsJSON != nil) {
      
      RKJSONParserJSONKit *parser = [[RKJSONParserJSONKit alloc] init];
      NSError *error = nil;
      NSArray *target = [GPUserSingleton sharedGPUserSingleton].journals;
      
      NSDictionary *objectAsDictionary;
      RKObjectMapper* mapper;
      objectAsDictionary = [parser objectFromString:journalsJSON error:&error];
      mapper = [RKObjectMapper mapperWithObject:objectAsDictionary
                                mappingProvider:[RKObjectManager sharedManager].mappingProvider];
      mapper.targetObject = target;
      
      RKObjectMappingResult* result = [mapper performMapping];
      DLog(@"the result: %@", [result asObject]);
      GPJournals *gpJournalsFromJsonString = [result asObject];
      
      sharedGPUserSingleton.journals = gpJournalsFromJsonString.journal;
    }
  }
}

- (void)setUser:(GPUser *)user {
  
  // Setting save to YES by default. This will save the user to NSUserDefaults
  // We can pull this out and put save in as a parameter if we want.
  // E.G. for a keep me logged in button
  BOOL save = YES;
  
  self.email = user.email;
  self.name = user.name;
  self.userId = user.userId;
  self.userIsSet = save;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (save) {
    // Save user info to NSUserDefaults
    [defaults setObject:user.email forKey:kGPUserDefaultsUserEmail];
    [defaults setObject:user.name forKey:kGPUserDefaultsUserName];
    [defaults setInteger:user.userId forKey:kGPUserDefaultsUserId];
    [defaults setBool:save forKey:kGPUserDefaultsUserIsSet];
    
  }
  else {
    // Remove info that was previously saved
    [defaults removeObjectForKey:kGPUserDefaultsUserEmail];
    [defaults removeObjectForKey:kGPUserDefaultsUserName];
    [defaults removeObjectForKey:kGPUserDefaultsUserId];
    [defaults removeObjectForKey:kGPUserDefaultsUserIsSet];
  }
  [defaults synchronize];
}

- (void)setUserJournals:(NSArray *)journals withString:(NSString *)jsonJournals {
  
  NSLog(@"setting %i journals into NSUserDefaults", journals.count);
    
  self.journals = journals;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // Save journals JSON string because we cannot save an NSArray to NSUserDefaults
  [defaults setObject:jsonJournals forKey:kGPUserDefaultsJournals];
  [defaults synchronize];
}

// Sets the latest 4 thumbnail urls to an object, puts it in an array with one GPLatestImageUrls per journal, and stores it in an iOS file for the application
- (void)setLatestImageUrls:(NSArray *)entries {
  
  // Check if the latestimageurls are previously saved (using the file system)
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  //2) Create the full file path by appending the desired file name
  GPEntry *firstEntry = [entries objectAtIndex:0];
  NSString *pathComponent = [NSString stringWithFormat:@"latestUrlsForJournal%i.dat", firstEntry.journalId];
  NSString *latestUrlsFileName = [documentsDirectory stringByAppendingPathComponent:pathComponent];
  
  DLog(@"filename: %@", latestUrlsFileName);
  
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
  for (int i = 0; i <= 3 && i < entries.count; i++) {
    
    GPEntry *currentEntry = [entries objectAtIndex:i];
    [dict setValue:[NSString stringWithFormat:@"%i", currentEntry.journalId] forKey:@"journalId"];
    
    // Not the most efficient way, but set the latest 4
    if (i == 0) {
      [dict setValue:currentEntry.picture.thumbnail.thumbnailUrl forKey:@"thumbnailUrl1"];
    }
    else if (i == 1) {
      [dict setValue:currentEntry.picture.thumbnail.thumbnailUrl forKey:@"thumbnailUrl2"];
    }
    else if (i == 2) {
      [dict setValue:currentEntry.picture.thumbnail.thumbnailUrl forKey:@"thumbnailUrl3"];
    }
    else if (i == 3) {
      [dict setValue:currentEntry.picture.thumbnail.thumbnailUrl forKey:@"thumbnailUrl4"];
    }
  }
  
  [dict writeToFile:latestUrlsFileName atomically:YES];
}

- (NSMutableDictionary *)latestImageUrlsForJournal:(NSInteger)journalId {
  
  // Check if the latestimageurls are previously saved (using the file system
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  //2) Create the full file path by appending the desired file name
  NSString *pathComponent = [NSString stringWithFormat:@"latestUrlsForJournal%i.dat", journalId];
  NSString *latestUrlsFileName = [documentsDirectory stringByAppendingPathComponent:pathComponent];
  
  //Load the array
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:latestUrlsFileName];
  if (dict == nil)
  {
    DLog(@"nil...couldn't retrieve");
  }
  else {
    DLog(@"got em");
    return dict;
  }
  return nil;
}

- (void)clearSharedUserInfo {
  
  self.email = nil;
  self.userId = 0;
  self.name = nil;
  self.password = nil;
  self.journals = nil;
  self.userIsSet = NO;
 
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  [defaults removeObjectForKey:kGPUserDefaultsUserEmail];
  [defaults removeObjectForKey:kGPUserDefaultsUserName];
  [defaults removeObjectForKey:kGPUserDefaultsUserId];
  [defaults removeObjectForKey:kGPUserDefaultsUserPassword];
  [defaults removeObjectForKey:kGPUserDefaultsJournals];
  [defaults removeObjectForKey:kGPUserDefaultsUserIsSet];
  
  [defaults synchronize];
}

@end
