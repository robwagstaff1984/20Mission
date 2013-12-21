//
//  RWRoomDataManager.m
//  20Mission
//
//  Created by Robert Wagstaff on 21/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWRoomDataManager.h"
#import "RWRoom.h"

#define NUMBER_OF_ROOMS 42

@interface RWRoomDataManager()
@property(nonatomic, strong) NSMutableArray* rooms;
@end

@implementation RWRoomDataManager

+(RWRoomDataManager*) sharedManager {
    
    static RWRoomDataManager* _sharedManager;
    if(!_sharedManager) {
        _sharedManager = [[self alloc] init];
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.rooms = [[NSMutableArray alloc] init];
        [self fetchRoomData];
    }
    return self;
}

//TODO: Fetch and synchronize with parse.com
-(void) fetchRoomData {
    
    NSDictionary* roomProperties = @{[RWRoom labelForRoomProperty:HousemateName]: @"Robert Wagstaff", [RWRoom labelForRoomProperty:HousemateName]: @"Stephanie Harris",  [RWRoom labelForRoomProperty:Mood] : @"Socialable", [RWRoom labelForRoomProperty:JoinDate] : @"10/22/14", [RWRoom labelForRoomProperty:LeaveDate]: @"10/22/15", [RWRoom labelForRoomProperty: Facebook] : @"ww.facebook.com/robertwagstaff"};
    
    for (int roomNumber=1; roomNumber <= NUMBER_OF_ROOMS; roomNumber++) {
        RWRoom *room = [[RWRoom alloc] initWithRoomNumber:roomNumber roomProperties:roomProperties];
        [self.rooms addObject:room];
    }
}

-(RWRoom*) roomAtDoorNumber:(int)doorNumber {
    return self.rooms[doorNumber];
}

@end
