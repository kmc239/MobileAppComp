//
//  GPPicture.h
//  GrowingPains
//
//  Created by Taylor McGann on 11/27/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPPicture : NSObject

@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) NSDictionary *thumb;

+ (RKObjectMapping *)mapping;

@end
