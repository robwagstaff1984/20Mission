//
//  DoorCollectionViewCell.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWDoorCollectionViewCell.h"

@interface RWDoorCollectionViewCell()
@property (nonatomic, strong) UIImageView* doorImageView;
@end


@implementation RWDoorCollectionViewCell

#pragma mark public methods
-(void) setImageForDoorNumber:(NSInteger)doorNumber {
    
    if(!_doorImageView) {
        _doorImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_doorImageView];
    }
    NSString* imageName = [NSString stringWithFormat:@"Door%d.png", doorNumber ];
    UIImage *doorImage = [UIImage imageNamed:imageName];
    
    [_doorImageView setImage:doorImage];
}

-(UIImage*) getCurrentImage {
    return self.doorImageView.image;
}

@end
