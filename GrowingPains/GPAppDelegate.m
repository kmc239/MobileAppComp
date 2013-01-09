//
//  GPAppDelegate.m
//  GrowingPains
//
//  Created by Kyle Clegg on 9/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPAppDelegate.h"
#import <RestKit/RestKit.h>
#import "GPModels.h"

// Used to check if running on simulator or device
#ifdef __APPLE__
  #include "TargetConditionals.h"
#endif


@implementation GPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
  RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
  
  // If on simulator use local web server
  #if TARGET_IPHONE_SIMULATOR
  NSURL *myURL = [NSURL URLWithString:NSLocalizedString(@"TESTING_URL", nil)];
  #elif TARGET_OS_IPHONE
  NSURL *myURL = [NSURL URLWithString:NSLocalizedString(@"SERVER_URL", nil)];
  #endif
  
  // Initialize The RestKit objectManager
	RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:myURL];
	
  [objectManager setSerializationMIMEType:RKMIMETypeJSON];
  [objectManager setAcceptMIMEType:RKMIMETypeJSON];
  [objectManager.client setTimeoutInterval:20.0]; // 20 seconds
  RKClient *client = objectManager.client;
  
  // Disable cert validation for now.
  client.disableCertificateValidation = YES;
  
  // Setup provider for object mappings
  RKObjectMappingProvider *provider = objectManager.mappingProvider;
  
  // Define object mappings
  RKObjectMapping *userMapping = [GPUser mapping];
  RKObjectMapping *journalsMapping = [GPJournals mapping];
  RKObjectMapping *journalMapping = [GPJournal mapping];
  RKObjectMapping *entriesMapping = [GPEntries mapping];
  RKObjectMapping *entryMapping = [GPEntry mapping];
  RKObjectMapping *pictureMapping = [GPPicture mapping];
  RKObjectMapping *thumbnailMapping = [GPThumbnail mapping];
  RKObjectMapping *midsizeMapping = [GPMidsize mapping];
  
  // Set up nested mappings
  [journalsMapping mapKeyPath:@"journal" toRelationship:@"journal" withMapping:journalMapping];
  [entriesMapping mapKeyPath:@"entry" toRelationship:@"entry" withMapping:entryMapping];
  [entryMapping mapKeyPath:@"picture" toRelationship:@"picture" withMapping:pictureMapping];
  [pictureMapping mapKeyPath:@"thumb" toRelationship:@"thumbnail" withMapping:thumbnailMapping];
  [pictureMapping mapKeyPath:@"midsize" toRelationship:@"midsize" withMapping:midsizeMapping];
  
  // Register mappings
  [provider registerMapping:userMapping withRootKeyPath:@"user"];
  [provider registerMapping:journalsMapping withRootKeyPath:@"journals"];
  [provider registerMapping:journalMapping withRootKeyPath:@"journal"];
  [provider registerMapping:entriesMapping withRootKeyPath:@"entries"];
  [provider registerMapping:entryMapping withRootKeyPath:@"entry"];
  [provider registerMapping:pictureMapping withRootKeyPath:@"picture"];
  [provider registerMapping:thumbnailMapping withRootKeyPath:@"thumbnail"];
  [provider registerMapping:midsizeMapping withRootKeyPath:@"midsize"];
  
  // Setup routing for posting, putting, and deleting objects from server
  [objectManager.router routeClass:[GPUser class] toResourcePath:@"/users"];
  [objectManager.router routeClass:[GPJournal class] toResourcePath:@"/journals"];
  [objectManager.router routeClass:[GPEntry class] toResourcePath:@"/entries"];
  
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
