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
#define DOOR_CLOSE_ANIMATION_TIME 0.5
#define ENTER_ROOM_ANIMATION_TIME 1.0
#define EXIT_ROOM_ANIMATION_TIME 0.7
#define ENTER_ROOM_ZOOMED_OUT_SCALE 0.8
#define ZOOMED_OUT_ROOM_Y_OFFSET 32

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

- (void)didExitRoom {
    [self performExitRoomAnimation];
}

- (void) performExitRoomAnimation {
    [self animateWalkingOutOfRoom];
}

#pragma mark - view creation helpers
-(void) addClippedViewOfRoom {
    self.roomClippingView = [[UIView alloc] initWithFrame: [self doorInteriorRect]];
    self.roomClippingView.backgroundColor = [UIColor redColor];
    self.roomClippingView.clipsToBounds = YES;

    self.roomImageView = [[UIImageView alloc] initWithImage:self.roomImage];
    self.roomImageView.frame = [self roomImageBeforeEnteringRoomRect];
    self.roomImageView.transform = CGAffineTransformScale(self.roomImageView.transform, ENTER_ROOM_ZOOMED_OUT_SCALE, ENTER_ROOM_ZOOMED_OUT_SCALE);
    
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
    self.doorLayer.zPosition = 200;
    [self.baseView.layer addSublayer:self.doorLayer];
}

#pragma mark - Door Layer Animation
-(void) animateDoorOpening {
    CAAnimation *doorOpeningAnimation = [self openDoorAnimationWithRotationDegree:90.0f];
    doorOpeningAnimation.delegate = self;
    doorOpeningAnimation.removedOnCompletion = NO;
    [self.doorLayer addAnimation:doorOpeningAnimation forKey:@"doorOpeningAnimation"];
}

-(void) animateDoorClosing {
    CAAnimation *doorClosingAnimation = [self closeDoorAnimationWithRotationDegree:90.0f];
    doorClosingAnimation.delegate = self;
    doorClosingAnimation.removedOnCompletion = NO;
    [self.doorLayer addAnimation:doorClosingAnimation forKey:@"doorClosingAnimation"];
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

- (CAAnimation *)closeDoorAnimationWithRotationDegree:(CGFloat)degree
{
    CABasicAnimation *openAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    openAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    openAnim.fromValue = [NSNumber numberWithFloat:[self degreeToRadian:(degree)]];
    self.doorLayer.transform = CATransform3DRotate(self.doorLayer.transform, [self degreeToRadian:0.0f], 0.0, 1.0, 0.0);
    openAnim.toValue = [NSNumber numberWithFloat:[self degreeToRadian:(0.0)]];
    openAnim.duration = DOOR_CLOSE_ANIMATION_TIME;
    
    return openAnim;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) {
        if (anim == [self.doorLayer animationForKey:@"doorOpeningAnimation"]) {
            [self.doorLayer removeFromSuperlayer];
            [self animateWalkingIntoRoom];
        } else if (anim == [self.doorLayer animationForKey:@"doorClosingAnimation"]) {
            
        }
    }
}

#pragma mark - Door Frame and Room View animation
-(void) animateWalkingIntoRoom {
    float scaledDoorFrameWidth = ceilf(((self.baseView.frame.size.width + DOOR_FRAME_WIDTH + DOOR_FRAME_WIDTH) / self.doorFrameImageView.frame.size.width) * DOOR_FRAME_WIDTH) + 1;
    
    [UIView animateWithDuration:ENTER_ROOM_ANIMATION_TIME animations:^(void) {
        self.doorFrameImageView.frame = CGRectMake(self.baseView.frame.origin.x - scaledDoorFrameWidth, self.baseView.frame.origin.y - scaledDoorFrameWidth, self.baseView.frame.size.width + (2 * scaledDoorFrameWidth), self.baseView.frame.size.height + scaledDoorFrameWidth);
        self.roomClippingView.frame = self.baseView.bounds;
        self.roomImageView.frame = self.baseView.bounds;
        self.roomImageView.transform = CGAffineTransformScale(self.roomImageView.transform, 1.0, 1.0);
    } completion:^(BOOL finished) {
        self.completion();
    }];
}

-(void) animateWalkingOutOfRoom {
    
    [UIView animateWithDuration:EXIT_ROOM_ANIMATION_TIME animations:^(void) {
        self.doorFrameImageView.frame = self.doorView.frame;
        self.roomClippingView.frame = [self doorInteriorRect];
        self.roomImageView.frame = [self roomImageBeforeEnteringRoomRect];
        self.roomImageView.transform = CGAffineTransformScale(self.roomImageView.transform, ENTER_ROOM_ZOOMED_OUT_SCALE, ENTER_ROOM_ZOOMED_OUT_SCALE);
    } completion:^(BOOL finished) {
        [self addDoor];
        [self animateDoorClosing];

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

-(CGRect) roomImageBeforeEnteringRoomRect {
    return CGRectMake(self.baseView.bounds.origin.x - self.roomClippingView.frame.origin.x, self.baseView.bounds.origin.y - self.roomClippingView.frame.origin.y + ZOOMED_OUT_ROOM_Y_OFFSET, self.baseView.bounds.size.width, self.baseView.bounds.size.height);
}

-(CGFloat) degreeToRadian:(CGFloat) degree {
    return degree * M_PI / 180.0f;
}

@end
