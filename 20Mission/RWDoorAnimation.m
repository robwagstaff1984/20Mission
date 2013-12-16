//
//  RWDoorAnimation.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/16/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWDoorAnimation.h"

#define DOOR_FRAME_WIDTH 20

CGFloat degreeToRadian(CGFloat degree)
{
    return degree * M_PI / 180.0f;
}

@interface RWDoorAnimation()

@property (nonatomic, retain) CALayer *doorLayer;
@property (nonatomic, retain) CALayer *doorFrameLayer;
@property (nonatomic, retain) CALayer *roomLayer;
@end

@implementation RWDoorAnimation


- (id)initWithBaseView:(UIView *)baseView doorView:(UIView *)doorView roomView:(UIImage *)roomImage
{
    if((self = [super init])) {
        self.view = baseView;
        self.doorView = doorView;
        self.roomImage = roomImage;
    }
    return self;
}


-(void) performOpenDoorAnimation {

    
    [self.doorView removeFromSuperview];
    self.doorFrameLayer = [CALayer layer];
    self.doorFrameLayer.frame = self.doorView.frame;
    self.doorFrameLayer.contents = (id)[RWDoorAnimation clipImageFromLayer:self.doorView.layer size:self.doorView.frame.size offsetX:0 offsetY:0];
    
    [self.view.layer addSublayer:self.doorFrameLayer];
    
    
    self.roomLayer = [CALayer layer];
//    self.roomLayer.frame = self.view.frame;
        self.roomLayer.frame = [self doorInteriorRect];
    self.roomLayer.contents = (__bridge id)([self.roomImage CGImage]);
    //self.roomLayer.contents = (id)[RWDoorAnimation clipImageFromLayer:self.roomView.layer size:[self doorInteriorRect].size offsetX:-DOOR_FRAME_WIDTH offsetY:-DOOR_FRAME_WIDTH];
    [self.view.layer addSublayer:self.roomLayer];
    
    self.doorLayer = [CALayer layer];
    self.doorLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
    self.doorLayer.frame = [self doorInteriorRect];
    CATransform3D leftTransform = self.doorLayer.transform;
    leftTransform.m34 = 1.0f / -420.0f;
    self.doorLayer.transform = leftTransform;
    self.doorLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.doorLayer.contents = (id)[RWDoorAnimation clipImageFromLayer:self.doorView.layer size:self.doorLayer.frame.size offsetX:-DOOR_FRAME_WIDTH offsetY:-DOOR_FRAME_WIDTH];
    
    self.doorLayer.zPosition = 100;
    [self.view.layer addSublayer:self.doorLayer];
    
    
    CAAnimation *doorAnimation = [self openDoorAnimationWithRotationDegree:90.0f];
    doorAnimation.delegate = self;
    [self.doorLayer addAnimation:doorAnimation forKey:@"doorAnimationStarted"];
    

//    
//    CAAnimation *roomZoomAnimation = [self zoomInAnimation];
//    roomZoomAnimation.delegate = self;
//    [self.roomLayer addAnimation:roomZoomAnimation forKey:@"NextViewAnimationStarted"];

    

}





-(CGRect) doorInteriorRect {
    return CGRectMake(self.doorView.frame.origin.x + DOOR_FRAME_WIDTH, self.doorView.frame.origin.y + DOOR_FRAME_WIDTH, self.doorView.frame.size.width - 2 * DOOR_FRAME_WIDTH, self.doorView.frame.size.height - DOOR_FRAME_WIDTH);
}


#pragma - Image utility
#
+ (CGImageRef)clipImageFromLayer:(CALayer *)layer size:(CGSize)size offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, offsetX, offsetY);
    [layer renderInContext:context];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot.CGImage;
}


#pragma - Animation set
#
- (CAAnimation *)zoomInAnimation
{
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *zoomInAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    zoomInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    zoomInAnim.fromValue = [NSNumber numberWithFloat:-1000.0f];
    zoomInAnim.toValue = [NSNumber numberWithFloat:0.0f];
    
    CABasicAnimation *fadeInAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeInAnim.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeInAnim.toValue = [NSNumber numberWithFloat:1.0f];
    
    animGroup.animations = [NSArray arrayWithObjects:zoomInAnim, fadeInAnim, nil];
    animGroup.duration = 1.5f;
    
    return animGroup;
}

- (CAAnimation *)zoomInRoomAnimation {
//    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    
//    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    baseAnimation.fromValue = [NSValue valueWithCGPoint:self.roomLayer] ;
//    baseAnimation.toValue = [NSValue valueWithCGPoint:endPoint] ;
//    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:self.roomLayer.bounds] ; boundsAnimation.toValue = [NSValue valueWithCGRect:self.view.bounds] ;
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO; group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:boundsAnimation, nil];
    group.duration = 0.7;
    
    return group;
}

- (CAAnimation *)zoomPastDoorFrameAnimation {
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
//    CGRect endBoundsRect = CGRectMake(self.view.bounds.origin.x - DOOR_FRAME_WIDTH- 50, self.view.bounds.origin.y - DOOR_FRAME_WIDTH - 25, self.view.bounds.size.width + DOOR_FRAME_WIDTH *2 + 50 ,  self.view.bounds.size.height + DOOR_FRAME_WIDTH + 25);
    
    CGRect endBoundsRect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.doorFrameLayer.bounds.size.width * 2,  self.doorFrameLayer.bounds.size.height * 2);
    
    boundsAnimation.fromValue = [NSValue valueWithCGRect:self.doorFrameLayer.bounds] ; boundsAnimation.toValue = [NSValue valueWithCGRect:endBoundsRect] ;
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO; group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:boundsAnimation, nil];
    group.duration = 0.7;

    return group;
}



- (CAAnimation *)openDoorAnimationWithRotationDegree:(CGFloat)degree
{
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *openAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    openAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    openAnim.fromValue = [NSNumber numberWithFloat:degreeToRadian(0.0f)];
    openAnim.toValue = [NSNumber numberWithFloat:degreeToRadian(degree)];
    
//    CABasicAnimation *zoomInAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
//    zoomInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    zoomInAnim.fromValue = [NSNumber numberWithFloat:0.0f];
//    zoomInAnim.toValue = [NSNumber numberWithFloat:300.0f];
    
//    animGroup.animations = [NSArray arrayWithObjects:openAnim, zoomInAnim, nil];
    animGroup.animations = [NSArray arrayWithObjects:openAnim, nil];
    animGroup.duration = 0.9f;
    
    return animGroup;
}

//
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) {
      //  if([self.doorLayer animationForKey:@"doorAnimationStarted"] == anim)
        {
            [self.doorLayer removeFromSuperlayer];
            
            
            
            CAAnimation * zoomPastDoorFrameAnimation = [self zoomPastDoorFrameAnimation];
            [self.doorFrameLayer addAnimation:zoomPastDoorFrameAnimation forKey:@"zoomPastDoorFrame"];
//
            CAAnimation * zoomInRoomAnimation = [self zoomInRoomAnimation];
            [self.roomLayer addAnimation:zoomInRoomAnimation forKey:@"zoomInRoom"];
            
         //   self.roomLayer.frame = self.view.frame;
//            CAAnimation *roomZoomAnimation = [self zoomInAnimation];
//            roomZoomAnimation.delegate = self;
//            [self.roomLayer addAnimation:roomZoomAnimation forKey:@"NextViewAnimationStarted"];
//            [self.doorLayerLeft removeFromSuperlayer];
//            [self.doorLayerRight removeFromSuperlayer];
//        }
//        else
//        {
//            [self.view addSubview:self.nextView];
//        }
        }
    }
}


@end
