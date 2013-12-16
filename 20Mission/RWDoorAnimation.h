//
//  RWDoorAnimation.h
//  20Mission
//
//  Created by Robert Wagstaff on 12/16/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWDoorAnimation : NSObject

@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) UIView *doorView;
@property (nonatomic, assign) UIImage *roomImage;

- (id)initWithBaseView:(UIView *)baseView doorView:(UIView *)doorView roomView:(UIImage*)roomImage;
- (void) performOpenDoorAnimation;
+ (CGImageRef)clipImageFromLayer:(CALayer *)layer size:(CGSize)size offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

@end
