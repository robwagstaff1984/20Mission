//
//  RWDoorAnimation.h
//  20Mission
//
//  Created by Robert Wagstaff on 12/16/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWDoorAnimation : NSObject

- (id)initWithBaseView:(UIView *)baseView doorView:(UIView *)doorView roomView:(UIImage*)roomImage;
- (void) performOpenDoorAndEnterRoomAnimation;

@end
