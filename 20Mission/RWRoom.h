//
//  RWRoom.h
//  20Mission
//
//  Created by Robert Wagstaff on 19/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HousemateName,
    JoinDate,
    LeaveDate,
    Mood,
    Facebook,
    MaintainenceRequests
} RoomProperty;

extern NSString* const RoomPropertyLabel[];

@interface RWRoom : NSObject
@property (nonatomic, assign) int roomNumber;
@property (nonatomic, strong) NSDictionary* roomProperties;

- (id)initWithRoomNumber:(int)roomNumber roomProperties:(NSDictionary*)roomProperties;
+(NSString*) labelForRoomProperty:(RoomProperty)roomProperty;

@end
