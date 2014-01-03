//
//  RWRoom.m
//  20Mission
//
//  Created by Robert Wagstaff on 19/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWRoom.h"

@implementation RWRoom

NSString* const RoomPropertyLabel [] = {
    [HousemateName] = @"Housemate name: ",
    [JoinDate] = @"Date Joined: ",
    [LeaveDate] =  @"Date Leaving: ",
    [Mood] = @"Mood: ",
    [Facebook] = @"Facebook: ",
    [MaintainenceRequests] = @"Maintainence Requests: "
};

- (id)initWithRoomNumber:(int)roomNumber roomProperties:(NSDictionary*)roomProperties
{
    self = [super init];
    if (self) {
        self.roomNumber = roomNumber;
        self.roomProperties = roomProperties;
    }
    return self;
}

+(NSString*) labelForRoomProperty:(RoomProperty)roomProperty {
    return RoomPropertyLabel[roomProperty];
}

@end
