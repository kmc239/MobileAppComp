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
@synthesize entries = _entries;
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

- (void)setUserJournals:(NSArray *)journals {
    
  self.journals = journals;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // Save journal
  [defaults setObject:journals forKey:kGPUserDefaultsJournals];
  [defaults synchronize];
}

- (void)setUserEntries:(NSArray *)entries {
  
  self.entries = entries;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // Save entry
  [defaults setObject:entries forKey:kGPUserDefaultsEntries];
  [defaults synchronize];
}


@end
