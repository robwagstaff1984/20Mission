//
//  RWDoorAnimation.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/16/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWDoorAnimation.h"

#define DOOR_FRAME_WIDTH 15
#define DOOR_OPEN_ANIMATION_TIME 0.8
#define ENTER_ROOM_ANIMATION_TIME 1.1
#define ENTER_ROOM_ZOOM_SCALE 1.2

@interface RWDoorAnimation()

@property (nonatomic, assign) UIView *baseView;
@property (nonatomic, assign) UIView *doorView;
@property (nonatomic, assign) UIImage *roomImage;

@property (nonatomic, retain) CALayer *doorLayer;
@property (nonatomic, strong) UIImageView *roomImageView;
@property (nonatomic, strong) UIImageView *doorFrameImageView;
@property (nonatomic, strong) UIView* roomClippingView;
@property (nonatomic, strong) completionBlock completion;
@end

@implementation RWDoorAnimation

#pragma mark - init
- (id)initWithBaseView:(UIView *)baseView doorView:(UIView *)doorView roomView:(UIImage *)roomImage
{
    if((self = [super init])) {
        self.baseView = baseView;
        self.doorView = doorView;
        self.roomImage = roomImage;
    }
    return self;
}
#pragma mark - public methods
- (void) performEnterRoomAnimationWithCompletion:(completionBlock)completion {
    [self.doorView removeFromSuperview];
    self.completion = completion;
    
    [self addClippedViewOfRoom];
    [self addDoorFrame];
    [self addDoor];
    [self animateDoorOpening];
}

#pragma mark - view creation helpers
-(void) addClippedViewOfRoom {
    self.roomClippingView = [[UIView alloc] initWithFrame: [self doorInteriorRect]];
    self.roomClippingView.clipsToBounds = YES;
    self.roomImageView = [[UIImageView alloc] initWithImage:self.roomImage];
    self.roomImageView.frame = self.baseView.bounds;
    self.roomImageView.frame = CGRectMake(self.baseView.bounds.origin.x - self.roomClippingView.frame.origin.x, self.baseView.bounds.origin.y - self.roomClippingView.frame.origin.y, self.baseView.bounds.size.width, self.baseView.bounds.size.height);
    [self.roomClippingView addSubview:self.roomImageView];
    [self.baseView addSubview:self.roomClippingView];
}

-(void) addDoorFrame {
    self.doorFrameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DoorFrame.png"]];
    self.doorFrameImageView.frame = self.doorView.frame;
    [self.baseView addSubview:self.doorFrameImageView];
}

-(void) addDoor{
    self.doorLayer = [CALayer layer];
    self.doorLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
    self.doorLayer.frame = [self doorInteriorRect];
    CATransform3D doorOpeningleftTransform = self.doorLayer.transform;
    doorOpeningleftTransform.m34 = 1.0f / -420.0f;
    self.doorLayer.transform = doorOpeningleftTransform;
    self.doorLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.doorLayer.contents = (id)[RWDoorAnimation clipImageFromLayer:self.doorView.layer size:self.doorLayer.frame.size offsetX:-DOOR_FRAME_WIDTH offsetY:-DOOR_FRAME_WIDTH];
    self.doorLayer.zPosition = 100;
    [self.baseView.layer addSublayer:self.doorLayer];
}

#pragma mark - Door Layer Animation
-(void) animateDoorOpening {
    CAAnimation *doorAnimation = [self openDoorAnimationWithRotationDegree:90.0f];
    doorAnimation.delegate = self;
    [self.doorLayer addAnimation:doorAnimation forKey:@"doorAnimationStarted"];
}

- (CAAnimation *)openDoorAnimationWithRotationDegree:(CGFloat)degree
{
    CABasicAnimation *openAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    openAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    openAnim.fromValue = [NSNumber numberWithFloat:[self degreeToRadian:(0.0f)]];
    self.doorLayer.transform = CATransform3DRotate(self.doorLayer.transform, [self degreeToRadian:90.0f], 0.0, 1.0, 0.0);
    openAnim.toValue = [NSNumber numberWithFloat:[self degreeToRadian:(degree)]];
    openAnim.duration = DOOR_OPEN_ANIMATION_TIME;
    
    return openAnim;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) {
        [self.doorLayer removeFromSuperlayer];
        [self animateWalkingIntoRoom];
    }
}

#pragma mark - Door Frame and Room View animation
-(void) animateWalkingIntoRoom {
    float scaledDoorFrameWidth = ceilf((self.baseView.bounds.size.width / self.doorFrameImageView.frame.size.width) * DOOR_FRAME_WIDTH);
    
    [UIView animateWithDuration:ENTER_ROOM_ANIMATION_TIME animations:^(void) {
        self.doorFrameImageView.frame = CGRectMake(self.baseView.frame.origin.x - scaledDoorFrameWidth, self.baseView.frame.origin.y, self.baseView.frame.size.width + (2 * scaledDoorFrameWidth), self.baseView.frame.size.height);
        self.roomClippingView.frame = self.baseView.bounds;
        self.roomImageView.frame = self.baseView.bounds;
        self.roomImageView.transform = CGAffineTransformScale(self.roomImageView.transform, ENTER_ROOM_ZOOM_SCALE, ENTER_ROOM_ZOOM_SCALE);
    } completion:^(BOOL finished) {
        self.completion();
    }];
}

#pragma mark - Image utility
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

#pragma mark - Calculation utilities
-(CGRect) doorInteriorRect {
    return CGRectMake(self.doorView.frame.origin.x + DOOR_FRAME_WIDTH, self.doorView.frame.origin.y + DOOR_FRAME_WIDTH, self.doorView.frame.size.width - 2 * DOOR_FRAME_WIDTH, self.doorView.frame.size.height - DOOR_FRAME_WIDTH);
}

-(CGFloat) degreeToRadian:(CGFloat) degree {
    return degree * M_PI / 180.0f;
}


@end
