//
//  RWRoomViewController.h
//  20Mission
//
//  Created by Robert Wagstaff on 19/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RWDoorExitAnimationDelegate;

@interface RWRoomViewController : UIViewController

@property (nonatomic, weak) id<RWDoorExitAnimationDelegate> delegate;
- (id)initWithRoomNumber:(int)roomNumber;
@end

@protocol RWDoorExitAnimationDelegate <NSObject>
@required
- (void)didExitRoom;
@end

