//
//  HomeViewController.m
//  20Mission
//
//  Created by Robert Wagstaff on 12/13/13.
//  Copyright (c) 2013 Robert Wagstaff. All rights reserved.
//

#import "HomeViewController.h"

#define NUMBER_OF_DOORS 42

static NSString *const CellIdentifier = @"CellIdentifier";

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView* doorsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *doorsCollectionViewLayout;
@end

@implementation HomeViewController


#pragma mark View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.doorsCollectionView];
    self.doorsCollectionView.delegate = self;
    self.doorsCollectionView.dataSource = self;
    [self.doorsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
    
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSize = (self.view.bounds.size.width / 3) - 3;
    return CGSizeMake(itemSize, itemSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
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
        [_doorsCollectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _doorsCollectionViewLayout.minimumLineSpacing = 0;
        _doorsCollectionViewLayout.minimumInteritemSpacing = 0;
    }
    return _doorsCollectionViewLayout;
}

@end
