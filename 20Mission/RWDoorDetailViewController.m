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

#define DOOR_ZOOM_ANIMATION_TIME 0.7

@interface RWDoorDetailViewController ()
@property (nonatomic, strong) UIImageView* doorDetailImageView;
@property (nonatomic) CGRect initialDoorImageRect;
@property (nonatomic, strong) UIImageView* transitionImageView;
@property (nonatomic, strong) UIView* hideSelectedDoorFromTransitionView;
@end

@implementation RWDoorDetailViewController

#pragma mark view cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated {

    self.view.backgroundColor = [UIColor colorWithPatternImage:self.transitionImageView.image];
    [self.hideSelectedDoorFromTransitionView setFrame:self.initialDoorImageRect];
    [self.view sendSubviewToBack:self.hideSelectedDoorFromTransitionView];
    
    [UIView animateWithDuration:DOOR_ZOOM_ANIMATION_TIME animations:^{
        self.doorDetailImageView.frame = [self fullSizeDoorRect];
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
    float fullSizeDoorHeight = self.view.frame.size.height - NAV_BAR_AND_STATUS_BAR_HEIGHT;
    float fullSizeDoorWidth = floor(fullSizeDoorHeight / DoorHeightToWidthRatio);
    return CGRectMake((self.view.frame.size.width - fullSizeDoorWidth) / 2, NAV_BAR_AND_STATUS_BAR_HEIGHT, fullSizeDoorWidth, fullSizeDoorHeight);
}

#pragma mark lazy loaders
-(void) setDoorDetailImage:(UIImage*)image withInitialRect:(CGRect)initialRect {
    
    [self.doorDetailImageView setImage:image];
    self.initialDoorImageRect = CGRectMake(initialRect.origin.x, initialRect.origin.y + NAV_BAR_AND_STATUS_BAR_HEIGHT, initialRect.size.width, initialRect.size.height);
    [self.doorDetailImageView setFrame:self.initialDoorImageRect];
}

-(UIImageView*) doorDetailImageView
{
    if (!_doorDetailImageView) {
        _doorDetailImageView =[[UIImageView alloc] init];
        [self.view addSubview:_doorDetailImageView];
    }
    return _doorDetailImageView;
}

-(UIView*) hideSelectedDoorFromTransitionView {
    if (!_hideSelectedDoorFromTransitionView) {
        _hideSelectedDoorFromTransitionView = [[UIView alloc] init];
        [_hideSelectedDoorFromTransitionView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_hideSelectedDoorFromTransitionView];
    }
    return _hideSelectedDoorFromTransitionView;
}

-(void)setTransitionImageView:(UIImageView*)transitionImageView {
    _transitionImageView = transitionImageView;
}

@end
