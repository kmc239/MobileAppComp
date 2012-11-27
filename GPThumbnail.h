//
//  GPThumbnail.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPThumbnail : NSObject

@property (nonatomic, strong) NSString *thumbnailUrl;

+ (RKObjectMapping *)mapping;

@end
