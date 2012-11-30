//
//  GPGreenButton.m
//  GrowingPains
//
//  Created by Kyle Clegg on 11/30/12.
//  Copyright (c) 2012 Kyle Clegg. All rights reserved.
//

#import "GPGreenButton.h"

@implementation GPGreenButton

- (id)initWithCoder:(NSCoder *)aDecoder{
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Initialization code
    
    self.titleLabel.font = [UIFont fontWithName:@"Sanchez-Regular" size:self.titleLabel.font.pointSize];
    
  }
  return self;
}
@end
