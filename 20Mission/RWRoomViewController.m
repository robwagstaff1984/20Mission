//
//  RWRoomViewController.m
//  20Mission
//
//  Created by Robert Wagstaff on 19/12/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWRoomViewController.h"

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
    
    NSArray* housemateInfo = [self retrieveHousemateInfo];
    
    for(int labelNumber = 0; labelNumber < [housemateInfo count]; labelNumber++) {
        
        UILabel* housemateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.width / 4) + labelNumber * 50, self.view.bounds.size.width, 50)];
        housemateNameLabel.text = housemateInfo[labelNumber];
        housemateNameLabel.textAlignment = NSTextAlignmentCenter;
        housemateNameLabel.textColor = [UIColor whiteColor];
        housemateNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self.housemateDetailsView addSubview:housemateNameLabel];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.housemateDetailsView.alpha = 1;
    }];
}

#pragma mark - Room Data source 

-(NSArray*) retrieveHousemateInfo {
    return @[@"Robert Wagstaff's Room", @"Mood: Socialable", @"www.facebook.com/robertwagstaff", @"Housemate since: 10/22/14", @"Leaving: 10/22/15"];
}

@end
