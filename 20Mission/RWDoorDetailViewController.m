//
//  DoorDetailViewController.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWDoorDetailViewController.h"
#import "RWHomeViewController.h"
#import "AppDelegate.h"
#import "RWDoorAnimation.h"
#import "RWRoomViewController.h"

#define DOOR_ZOOM_ANIMATION_TIME 0.5
#define DOOR_DASHBOARD_ANIMATION_TIME 0.4 
#define FULL_SIZE_DOOR_TOP_MARGIN 60
#define FULL_SIZE_DOOR_BOTTOM_MARGIN 30
#define DOOR_KNOCK_ICON_WIDTH 60
#define DOOR_KNOCK_ICON_HEIGHT 50
#define DOOR_KNOCK_FADE_ANIMATION_TIME 0.7

@interface RWDoorDetailViewController ()
@property (nonatomic, strong) UIImageView* doorDetailImageView;
@property (nonatomic) CGRect initialDoorImageRect;
@property (nonatomic, strong) UIImageView* transitionImageView;
@property (nonatomic, strong) UIImage* roomImage;
@property (nonatomic, strong) UIView* hideSelectedDoorFromTransitionView;
@property (nonatomic, strong) UIView* doorDashboardView;
@property (nonatomic, assign) int roomNumber;
@end

@implementation RWDoorDetailViewController

#pragma mark view cycle

- (id)initWithRoomNumber:(int)roomNumber
{
    self = [super init];
    if (self) {
        self.roomNumber = roomNumber;
        [self setupHideSelectedDoorFromTransitionView];
        [self setupDoorDashboardView];
        [self setupDoorDetailImageView];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {

    self.view.backgroundColor = [UIColor colorWithPatternImage:self.transitionImageView.image];
    
    [UIView animateWithDuration:DOOR_ZOOM_ANIMATION_TIME animations:^{
        self.doorDetailImageView.frame = [self fullSizeDoorRect];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:DOOR_DASHBOARD_ANIMATION_TIME animations:^{
            self.doorDashboardView.alpha = 1;
            [self addDoorKnockGestureRecognizer];
        }];
    }];
}

#pragma mark helper methods
-(CGRect) fullSizeDoorRect {
    float fullSizeDoorHeight = self.view.frame.size.height - NAV_BAR_HEIGHT - FULL_SIZE_DOOR_TOP_MARGIN - FULL_SIZE_DOOR_BOTTOM_MARGIN;
    float fullSizeDoorWidth = floor(fullSizeDoorHeight / DoorHeightToWidthRatio);
    return CGRectMake((self.view.frame.size.width - fullSizeDoorWidth) / 2, NAV_BAR_HEIGHT + FULL_SIZE_DOOR_TOP_MARGIN, fullSizeDoorWidth, fullSizeDoorHeight);
}

#pragma mark lazy loaders
-(void) setDoorDetailImage:(UIImage*)image withInitialRect:(CGRect)initialRect {
    [self.doorDetailImageView setImage:image];
    self.initialDoorImageRect = CGRectMake(initialRect.origin.x, initialRect.origin.y + NAV_BAR_HEIGHT, initialRect.size.width, initialRect.size.height);
    [self.doorDetailImageView setFrame:self.initialDoorImageRect];
    [self.hideSelectedDoorFromTransitionView setFrame:self.initialDoorImageRect];
}

#pragma mark setup helpers

-(void) setupDoorDetailImageView {
    self.doorDetailImageView =[[UIImageView alloc] init];
    self.doorDetailImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.doorDetailImageView];
}

-(void) setupHideSelectedDoorFromTransitionView {
    self.hideSelectedDoorFromTransitionView = [[UIView alloc] init];
    [self.hideSelectedDoorFromTransitionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.hideSelectedDoorFromTransitionView];
}

-(void) setupDoorDashboardView {
    self.doorDashboardView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.doorDashboardView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
    [self.view addSubview:self.doorDashboardView];
    self.doorDashboardView.alpha = 0;
    [self.doorDashboardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutToHomeViewController:)]];
}

-(void)setTransitionImageView:(UIImageView*)transitionImageView {
    _transitionImageView = transitionImageView;
}

-(void) setupRoomImageView {
    self.roomImage = [UIImage imageNamed:@"Room4.png"];
}

#pragma mark door knock gesture

-(void) addDoorKnockGestureRecognizer {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];

    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [self.doorDetailImageView addGestureRecognizer:singleTapGesture];
    [self.doorDetailImageView addGestureRecognizer:doubleTapGesture];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self addDoorKnockImageAtPoint:[sender locationInView:self.view] completionBlock:nil];
    }
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {

        [self setupRoomImageView];
        __weak typeof(self) weakSelf = self;
        [self addDoorKnockImageAtPoint:[sender locationInView:self.view] completionBlock:^{
            RWDoorAnimation *doorAnimation = [[RWDoorAnimation alloc] initWithBaseView:weakSelf.view doorView:weakSelf.doorDetailImageView roomView:weakSelf.roomImage];
            [doorAnimation performEnterRoomAnimationWithCompletion:^{
                RWRoomViewController* roomViewController = [[RWRoomViewController alloc] initWithRoomNumber:weakSelf.roomNumber];
                roomViewController.delegate = doorAnimation;
                [weakSelf presentViewController:roomViewController animated:NO completion:nil];
            }];
        }];
    }
}

-(void) addDoorKnockImageAtPoint:(CGPoint)targetPoint completionBlock:(void (^)(void))completionBlock {
    UIImageView* knockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DoorKnockIcon.png"]];
    knockImageView.frame = CGRectMake(targetPoint.x - DOOR_KNOCK_ICON_WIDTH / 2, targetPoint.y - DOOR_KNOCK_ICON_HEIGHT / 2, DOOR_KNOCK_ICON_WIDTH, DOOR_KNOCK_ICON_HEIGHT);
    [self.view addSubview:knockImageView];
    [UIView animateWithDuration:DOOR_KNOCK_FADE_ANIMATION_TIME delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        knockImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [knockImageView removeFromSuperview];
        if(completionBlock) {
            completionBlock();
        }
    }];
}

- (void) zoomOutToHomeViewController:(UITapGestureRecognizer *)sender {
     if (sender.state == UIGestureRecognizerStateRecognized) {
         [UIView animateWithDuration:DOOR_ZOOM_ANIMATION_TIME animations:^{
             self.doorDetailImageView.frame = self.initialDoorImageRect;
         } completion:^(BOOL finished) {
             [self dismissViewControllerAnimated:NO completion:nil];
         }];
     }
}
@end
