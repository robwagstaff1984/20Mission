//
//  DoorDetailViewController.h
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWDoorDetailViewController : UIViewController

-(void)setDoorDetailImage:(UIImage*)image withInitialRect:(CGRect)initialRect;
-(void) shouldZoomOutOnPopNavigationItem;

@end
