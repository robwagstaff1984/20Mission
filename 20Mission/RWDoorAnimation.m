//
//  RWDoorAnimation.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/16/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWDoorAnimation.h"

#define DOOR_FRAME_WIDTH 15

CGFloat degreeToRadian(CGFloat degree)
{
    return degree * M_PI / 180.0f;
}

@interface RWDoorAnimation()

@property (nonatomic, retain) CALayer *doorLayer;
@property (nonatomic, retain) CALayer *doorFrameLayer;
@property (nonatomic, retain) CALayer *roomLayer;
@property (nonatomic, strong) UIImageView *roomImageView;
@property (nonatomic, strong) UIImageView *doorFrameImageView;
@property (nonatomic, strong) UIView* roomClippingView;
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
    
//        self.doorFrameLayer = [CALayer layer];
//        self.doorFrameLayer.frame = self.doorView.frame;
//    
//        UIImage* doorFrameImage = [UIImage imageNamed:@"DoorFrame.png"];
//    
//        self.doorFrameLayer.contents = (__bridge id)(doorFrameImage.CGImage);
//    
    
    
  
    [self addRoomWithAnimation];
//    
//    
//
//
//    [self.view.layer addSublayer:self.doorFrameLayer];
//
//    CAAnimation *zoomPastDoorFrameAnimation = [self zoomPastDoorFrameAnimation];
//    zoomPastDoorFrameAnimation.delegate = self;
//    [self.doorFrameLayer addAnimation:zoomPastDoorFrameAnimation forKey:@"zoomPastDoorFrameAnimationStarted"];
//    
    
    [self addDoorWithAnimation];
}

-(void) addRoomWithAnimation {
    
    self.roomClippingView = [[UIView alloc] initWithFrame: [self doorInteriorRect]];
    self.roomClippingView.backgroundColor = [UIColor redColor];
    self.roomClippingView.clipsToBounds = YES;
    
    
    self.roomImageView = [[UIImageView alloc] initWithImage:self.roomImage];
    self.roomImageView.frame = self.view.bounds;
    self.roomImageView.frame = CGRectMake(self.view.bounds.origin.x - self.roomClippingView.frame.origin.x, self.view.bounds.origin.y - self.roomClippingView.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.roomImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.roomClippingView addSubview:self.roomImageView];
    [self.view addSubview:self.roomClippingView];
    
//    [self.view addSubview:self.roomImageView];
    
    self.doorFrameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DoorFrame.png"]];
    self.doorFrameImageView.frame = self.doorView.frame;
//    self.doorFrameImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.doorFrameImageView];
    
    //
   
//    [UIView animateWithDuration:1 animations:^(void) {
//        self.roomImageView.transform = CGAffineTransformScale(self.roomImageView.transform, 1.00, 1.0);
//    }];
}


-(void) addDoorWithAnimation {
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

- (CAAnimation *)zoomPastDoorFrameAnimation {
    
    float magicScaleFactor = 2.1;
    float magicYPosition = 140;
    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CGRect endBoundsRect = CGRectMake(self.view.bounds.origin.x, self.doorFrameLayer.bounds.origin.y, self.doorFrameLayer.bounds.size.width * magicScaleFactor,  self.doorFrameLayer.bounds.size.height * magicScaleFactor);
    boundsAnimation.fromValue = [NSValue valueWithCGRect:self.doorFrameLayer.bounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:endBoundsRect];
    

    CABasicAnimation * positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.doorFrameLayer.position.x, self.doorFrameLayer.position.y)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.doorFrameLayer.position.x, magicYPosition)];
    
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO; group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:boundsAnimation, positionAnimation, nil];
    group.duration = 2.0;

    return group;
}

- (CAAnimation *)zoomIntoRoomAnimation {
        float magicScaleFactor = 2.1;
    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
 //   CGRect endBoundsRect = CGRectMake(self.view.bounds.origin.x, self.doorFrameLayer.bounds.origin.y, self.doorFrameLayer.bounds.size.width * magicScaleFactor,  self.doorFrameLayer.bounds.size.height * magicScaleFactor);
    boundsAnimation.fromValue =  [NSValue valueWithCGRect:[self doorInteriorRect]] ;
    boundsAnimation.toValue = [NSValue valueWithCGRect:self.view.bounds];
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO; group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:boundsAnimation, nil];
    group.duration = 2.0;
    
    return group;
}



- (CAAnimation *)zoomIntoRoomAnimationOld {
    
    
    CABasicAnimation * boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:self.roomLayer.bounds] ;
    boundsAnimation.toValue = [NSValue valueWithCGRect:self.view.bounds] ;
    
    CAAnimationGroup * group =[CAAnimationGroup animation];
    group.removedOnCompletion=NO; group.fillMode=kCAFillModeForwards;
    group.animations =[NSArray arrayWithObjects:boundsAnimation, nil];
    group.duration = 0.5;
    
    return group;
}






- (CAAnimation *)openDoorAnimationWithRotationDegree:(CGFloat)degree
{
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *openAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    openAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    openAnim.fromValue = [NSNumber numberWithFloat:degreeToRadian(0.0f)];
    openAnim.toValue = [NSNumber numberWithFloat:degreeToRadian(degree)];

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
            
            float scaledDoorFrameWidth = ceilf((self.view.bounds.size.width / self.doorFrameImageView.frame.size.width) * DOOR_FRAME_WIDTH);
            
            [UIView animateWithDuration:1.1 animations:^(void) {
                self.doorFrameImageView.frame = CGRectMake(self.view.frame.origin.x - scaledDoorFrameWidth, self.view.frame.origin.y, self.view.frame.size.width + (2 * scaledDoorFrameWidth), self.view.frame.size.height);
                self.roomClippingView.frame = self.view.bounds;
                self.roomImageView.frame = self.view.bounds;
                self.roomImageView.transform = CGAffineTransformScale(self.roomImageView.transform, 1.2, 1.2);
                
            }];

            
            
//            CAAnimation * zoomPastDoorFrameAnimation = [self zoomPastDoorFrameAnimation];
//            [self.doorFrameLayer addAnimation:zoomPastDoorFrameAnimation forKey:@"zoomPastDoorFrame"];
////
//            CAAnimation * zoomInRoomAnimation = [self zoomInRoomAnimation];
//            [self.roomLayer addAnimation:zoomInRoomAnimation forKey:@"zoomInRoom"];
//            
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
