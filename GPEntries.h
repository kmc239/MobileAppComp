//
//  GPEntries.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/26/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPEntries : NSObject

@property (nonatomic, strong) NSArray *entry;

+ (RKObjectMapping *)mapping;

@end
