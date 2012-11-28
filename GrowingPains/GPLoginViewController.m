//
//  GPLoginViewController.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/20/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <RestKit/RKRequestSerialization.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import "GPLoginViewController.h"
#import "GPModels.h"
#import "GPUserSingleton.h"
#import "GPHelpers.h"
#import "GPConstants.h"
#import "DejalActivityView.h"

@interface GPLoginViewController ()

@end

@implementation GPLoginViewController

@synthesize _scrollView, _email, _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // If user is set, automatically log them in
  if ([GPUserSingleton sharedGPUserSingleton].userIsSet) {
    [self performSegueWithIdentifier:@"Login" sender:self];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - TextFieldDelegate
// Called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[_scrollView setContentOffset:CGPointMake(0,textField.center.y - (kKeyBoardFieldOffset/2)) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
  [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - RestKit Calls

// Sent when a request has finished loading
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
  
  [DejalBezelActivityView removeViewAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  if ([request isPOST]) {
    
    NSLog(@"POST finished with status code: %i", [response statusCode]);
    if ([response statusCode] == 200) {
      DLog(@"the user id is %@",  response.bodyAsString);
      GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
      sharedUser.userId = [response.bodyAsString doubleValue];
      
      NSString *userJSON = response.bodyAsString;
      
      // If User JSON string is not null then we will use RK's JSON parser to parse into a user object
      // We only need to do this here because of the custom login API, which returns a valid user object
      if (userJSON != nil) {
        
        RKJSONParserJSONKit *parser = [[RKJSONParserJSONKit alloc] init];
        NSError *error = nil;
        GPUser *targetUser = [[GPUser alloc] init];
        
        NSDictionary *objectAsDictionary;
        RKObjectMapper* mapper;
        objectAsDictionary = [parser objectFromString:userJSON error:&error];
        mapper = [RKObjectMapper mapperWithObject:objectAsDictionary
                                  mappingProvider:[RKObjectManager sharedManager].mappingProvider];
        mapper.targetObject = targetUser;
        
        RKObjectMappingResult* result = [mapper performMapping];
        DLog(@"the result: %@", [result asObject]);
        targetUser = [result asObject];
        
        DLog(@"user's name is %@ and id is %i", targetUser.name, targetUser.userId);
        
        GPUserSingleton *sharedUser = [GPUserSingleton sharedGPUserSingleton];
        [sharedUser setUser:targetUser];
        
        // Set RestKit shared client to store creds for this session
        // The API requires all users to be logged in for every API call,
        // with the exception of create user and login
        [[RKClient sharedClient] setUsername:_email.text];
        [[RKClient sharedClient] setPassword:_password.text];
        
        [self performSegueWithIdentifier:@"Login" sender:self];
      }
    }
    else if ([response statusCode] == 403) {
      [GPHelpers showAlertWithMessage:NSLocalizedString(@"LOGIN_INVALID_CREDS", nil)
                           andHeading:NSLocalizedString(@"LOGIN_UNSUCCESSFUL", nil)];
    }
    else {
      [GPHelpers showAlertWithMessage:NSLocalizedString(@"UNEXPECTED_RESPONSE", nil)
                           andHeading:NSLocalizedString(@"LOGIN_UNSUCCESSFUL", nil)];
    }
  }
}

// Sent when a request has failed due to an error
- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error
{
  
  [DejalBezelActivityView removeViewAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
	int test = [error code];
	if (test == RKRequestBaseURLOfflineError) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_CONNECTION_ERROR", nil) andHeading:NSLocalizedString(@"RK_CONNECTION_ERROR_HEADING", nil)];
		return;
	}
}

// Sent to the delegate when a request has timed out
- (void)requestDidTimeout:(RKRequest*)request {
  
  [DejalBezelActivityView removeViewAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  [GPHelpers showAlertWithMessage:NSLocalizedString(@"RK_REQUEST_TIMEOUT", nil) andHeading:NSLocalizedString(@"RK_OPERATION_FAILED", nil)];
}


#pragma mark - RestKit objectLoader
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
  [DejalBezelActivityView removeViewAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader did load objects");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
  
  [DejalBezelActivityView removeViewAnimated:YES];
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  NSLog(@"objectLoader failed with error: %@", error);
}

#pragma mark - Actions

- (IBAction)loginPressed:(id)sender
{
  if (![GPHelpers isValidEmail:_email.text]) {
    [GPHelpers showAlertWithMessage:NSLocalizedString(@"INVALID_EMAIL", nil)
                         andHeading:NSLocalizedString(@"LOGIN_UNSUCCESSFUL", nil)];
  }
  else {
    
    // Create our JSON array using an NSDictionary
    // Because it's a small POST where the server expects a custom array we'll just build
    // it here using the RestKit parser
    // Server expects: {"email":"kyle@kyleclegg.com", "password":"password"}
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    // Email and password params, put into params dictionary
    [params setObject:_email.text forKey:@"email"];
    [params setObject:_password.text forKey:@"password"];
    
    // Parse password dictionary to JSON string
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:params error:&error];
    
    DLog(@"json: %@", json);
    
    if (!error){
      [DejalBezelActivityView activityViewForView:self.view withLabel:@"Logging in..."];
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
      [[RKClient sharedClient] post:@"/sessions" params:[RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON] delegate:self];
    }
  }
}
@end
