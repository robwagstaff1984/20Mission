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

#define DOOR_ZOOM_ANIMATION_TIME 0.5
#define DOOR_DASHBOARD_ANIMATION_TIME 0.4 
#define FULL_SIZE_DOOR_TOP_MARGIN 60
#define FULL_SIZE_DOOR_BOTTOM_MARGIN 30

@interface RWDoorDetailViewController ()
@property (nonatomic, strong) UIImageView* doorDetailImageView;
@property (nonatomic) CGRect initialDoorImageRect;
@property (nonatomic, strong) UIImageView* transitionImageView;
@property (nonatomic, strong) UIImage* roomImage;
@property (nonatomic, strong) UIView* hideSelectedDoorFromTransitionView;
@property (nonatomic, strong) UIView* doorDashboardView;
@end

@implementation RWDoorDetailViewController

#pragma mark view cycle

- (id)init
{
    self = [super init];
    if (self) {
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


#pragma mark custom navigation back behaviour
-(void) shouldZoomOutOnPopNavigationItem {
    
    [UIView animateWithDuration:DOOR_ZOOM_ANIMATION_TIME animations:^{
        self.doorDetailImageView.frame = self.initialDoorImageRect;
    } completion:^(BOOL finished) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        UINavigationController* rootNavigationController = (UINavigationController*) delegate.window.rootViewController;
        [rootNavigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark helper methods
-(CGRect) fullSizeDoorRect {
    float fullSizeDoorHeight = self.view.frame.size.height - NAV_BAR_AND_STATUS_BAR_HEIGHT - FULL_SIZE_DOOR_TOP_MARGIN - FULL_SIZE_DOOR_BOTTOM_MARGIN;
    float fullSizeDoorWidth = floor(fullSizeDoorHeight / DoorHeightToWidthRatio);
    return CGRectMake((self.view.frame.size.width - fullSizeDoorWidth) / 2, NAV_BAR_AND_STATUS_BAR_HEIGHT + FULL_SIZE_DOOR_TOP_MARGIN, fullSizeDoorWidth, fullSizeDoorHeight);
}

#pragma mark lazy loaders
-(void) setDoorDetailImage:(UIImage*)image withInitialRect:(CGRect)initialRect {
    [self.doorDetailImageView setImage:image];
    self.initialDoorImageRect = CGRectMake(initialRect.origin.x, initialRect.origin.y + NAV_BAR_AND_STATUS_BAR_HEIGHT, initialRect.size.width, initialRect.size.height);
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
}

-(void)setTransitionImageView:(UIImageView*)transitionImageView {
    _transitionImageView = transitionImageView;
}

-(void) setupRoomImageView {
  //  self.roomImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];

//        self.roomImageView.contentMode = UIViewContentModeCenter;
    //[self.roomImageView setImage:[UIImage imageNamed:@"Room4.png"]];
    self.roomImage = [UIImage imageNamed:@"Room4.png"];
}

#pragma mark door knock gesture

-(void) addDoorKnockGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    
    [self.doorDetailImageView addGestureRecognizer:tapGesture];
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Knocked");
        [self setupRoomImageView];
        RWDoorAnimation *doorAnimation = [[RWDoorAnimation alloc] initWithBaseView:self.view doorView:self.doorDetailImageView roomView:self.roomImage];
        [doorAnimation performOpenDoorAndEnterRoomAnimation];
    }
}

@end
