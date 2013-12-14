//
//  UIView+screenGrab.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "UIView+screenGrab.h"

@implementation UIView (screenGrab)

- (UIImageView *)screenshotImageViewWithCroppingRect:(CGRect)croppingRect {
    // For dealing with Retina displays as well as non-Retina, we need to check
    // the scale factor, if it is available. Note that we use the size of teh cropping Rect
    // passed in, and not the size of the view we are taking a screenshot of.
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, YES, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(croppingRect.size);
    }
    
    // Create a graphics context and translate it the view we want to crop so
    // that even in grabbing (0,0), that origin point now represents the actual
    // cropping origin desired:
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -croppingRect.origin.x, -croppingRect.origin.y);
    [self.layer renderInContext:ctx];
    
    // Retrieve a UIImage from the current image context:
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the image in a UIImageView:
    return [[UIImageView alloc] initWithImage:snapshotImage];
}

@end
