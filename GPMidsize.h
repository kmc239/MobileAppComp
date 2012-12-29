//
//  GPMidsize.h
//  GrowingPains
//
//  Created by Kyle Clegg on 12/29/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GPMidsize : NSObject

@property (nonatomic, strong) NSString *midsizeUrl;

+ (RKObjectMapping *)mapping;

@end
