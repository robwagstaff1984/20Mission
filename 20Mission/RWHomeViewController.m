//
//  HomeViewController.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "RWHomeViewController.h"
#import "RWDoorCollectionViewCell.h"

#define NUMBER_OF_DOORS 42
#define DOOR_HEIGHT_TO_WIDTH_RATIO (80.0 / 36.0)
#define NUMBER_OF_DOORS_PER_ROW 3
#define SPACING 6

static NSString *const CellIdentifier = @"CellIdentifier";

@interface RWHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView* doorsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *doorsCollectionViewLayout;
@end

@implementation RWHomeViewController


#pragma mark View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.doorsCollectionView];
    self.doorsCollectionView.delegate = self;
    self.doorsCollectionView.dataSource = self;
    self.doorsCollectionView.backgroundColor= [UIColor whiteColor];
    [self.doorsCollectionView registerClass:[RWDoorCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
}

#pragma mark UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NUMBER_OF_DOORS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RWDoorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    [cell setImageForDoorNumber:indexPath.row + 1];
    return cell;
    
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat doorCellWidth = (self.view.bounds.size.width - ((NUMBER_OF_DOORS_PER_ROW - 1) * (SPACING*2))) / NUMBER_OF_DOORS_PER_ROW;
    CGFloat doorCellHeight = doorCellWidth * DOOR_HEIGHT_TO_WIDTH_RATIO;
    return CGSizeMake(doorCellWidth, doorCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return SPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SPACING;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SPACING, SPACING, SPACING, SPACING);
}

#pragma mark lazy loaded getters
-(UICollectionView*) doorsCollectionView {
    if (!_doorsCollectionView) {
        
        _doorsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.doorsCollectionViewLayout];
    }
    return _doorsCollectionView;
}

-(UICollectionViewFlowLayout*) doorsCollectionViewLayout {
    if(!_doorsCollectionViewLayout) {
        _doorsCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        [_doorsCollectionViewLayout setItemSize:CGSizeMake(320, 200)];
        [_doorsCollectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _doorsCollectionViewLayout.minimumLineSpacing = 0;
        _doorsCollectionViewLayout.minimumInteritemSpacing = 0;
    }
    return _doorsCollectionViewLayout;
}

@end
