//
//  DoorDetailViewController.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWDoorDetailViewController.h"

@interface RWDoorDetailViewController ()
@property (nonatomic, strong) UIImageView* doorDetailImageView;

@end

@implementation RWDoorDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.doorDetailImageView.frame = self.view.bounds;
    }];
}


-(void) setDoorDetailImage:(UIImage*)image withInitialRect:(CGRect)initialRect {
    [self.doorDetailImageView setImage:image];
    [self.doorDetailImageView setFrame:initialRect];
}

-(UIImageView*) doorDetailImageView
{
    if (!_doorDetailImageView) {
        _doorDetailImageView =[[UIImageView alloc] init];
        [self.view addSubview:_doorDetailImageView];
    }
    return _doorDetailImageView;
}



@end
