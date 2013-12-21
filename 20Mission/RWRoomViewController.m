//
//  RWRoomViewController.m
//  20Mission
//
//  Created by Robert Wagstaff on 19/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWRoomViewController.h"
#import "RWRoomDataManager.h"

@interface RWRoomViewController ()
@property (nonatomic, strong) UIView* housemateDetailsView;
@property (nonatomic, assign) int roomNumber;
@end

@implementation RWRoomViewController

- (id)initWithRoomNumber:(int)roomNumber
{
    self = [super init];
    if (self) {
        self.roomNumber = roomNumber;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRoomImage];
    [self showHousemateDetails];
}

#pragma mark - View creation helper

-(void) setupRoomImage {
    UIImageView *roomImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    roomImage.image = [UIImage imageNamed:@"Room4.png"];
    [self.view addSubview:roomImage];
}

-(void) showHousemateDetails {
    
    self.housemateDetailsView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.housemateDetailsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.housemateDetailsView.alpha = 0;
    [self.view addSubview:self.housemateDetailsView];
    
    NSDictionary* roomProperties = [self retrieveHousemateInfo];
    NSArray* roomPropertyKeys = [roomProperties allKeys];
    
    
    for(int labelNumber = 0; labelNumber < [roomPropertyKeys count]; labelNumber++) {
        
        UILabel* roomPropertyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.width / 4) + labelNumber * 50, self.view.bounds.size.width * .45, 50)];
        roomPropertyNameLabel.text = roomPropertyKeys[labelNumber];
        roomPropertyNameLabel.textAlignment = NSTextAlignmentRight;
        roomPropertyNameLabel.textColor = [UIColor whiteColor];
        roomPropertyNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        UITextField* roomPropertyValueText = [[UITextField alloc] initWithFrame:CGRectMake((self.view.bounds.size.width /2), (self.view.bounds.size.width / 4) + labelNumber * 50, self.view.bounds.size.width /2, 50)];
        roomPropertyValueText.text = roomProperties[roomPropertyKeys[labelNumber]];
        roomPropertyValueText.textAlignment = NSTextAlignmentLeft;
        roomPropertyValueText.textColor = [UIColor whiteColor];
        roomPropertyValueText.font = [UIFont boldSystemFontOfSize:16.0];
        
        [self.housemateDetailsView addSubview:roomPropertyNameLabel];
        [self.housemateDetailsView addSubview:roomPropertyValueText];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.housemateDetailsView.alpha = 1;
    }];
}

#pragma mark - Room Data source 

-(NSDictionary*) retrieveHousemateInfo {
    
   RWRoom* currentRoom = [[RWRoomDataManager sharedManager] roomAtDoorNumber:self.roomNumber];
    return currentRoom.roomProperties;
}

@end
