//
//  RWRoomDataManager.h
//  20Mission
//
//  Created by Robert Wagstaff on 21/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWRoom.h"

@interface RWRoomDataManager : NSObject

+(RWRoomDataManager*) sharedManager;
-(RWRoom*) roomAtDoorNumber:(int)doorNumber;

@end
