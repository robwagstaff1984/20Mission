//
//  UINavigationBar+ZoomDoorOut.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "UINavigationBar+ZoomDoorOut.h"
#import "AppDelegate.h"

@implementation UINavigationBar (ZoomDoorOut)

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated;
{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* rootNavigationController = (UINavigationController*) delegate.window.rootViewController;
    
    if ([rootNavigationController.topViewController respondsToSelector:@selector(shouldZoomOutOnPopNavigationItem)]) {
        [rootNavigationController.topViewController performSelector:@selector(shouldZoomOutOnPopNavigationItem)];
//        [rootNavigationController popViewControllerAnimated:YES];
    } else {
        [rootNavigationController popViewControllerAnimated:YES];
    }
    
    return nil;
}

@end
