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

// TODO: Update this to set the journals JSON string to NSUserDefaults
// This is not saving because NSUserDefaults does not support dates or NSIntegers
- (void)setUserJournals:(NSArray *)journals {
  
  NSLog(@"setting %i journals into NSUserDefaults", journals.count);
    
  self.journals = journals;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // Save journal
  [defaults setObject:journals forKey:kGPUserDefaultsJournals];
  [defaults synchronize];
}

// TODO: Load JSON string and use RKJSONParser to convert back to NSArray
//- (NSArray *)journals
//{
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  return [defaults objectForKey:@"kGPUserDefaultsJournals"];
//}

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
