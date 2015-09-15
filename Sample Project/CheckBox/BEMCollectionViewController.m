//
//  BEMCollectionViewController.m
//  CheckBox
//
//  Created by Boris Emorine on 9/14/15.
//  Copyright © 2015 Boris Emorine. All rights reserved.
//

#import "BEMCollectionViewController.h"
#import "BEMCustomCollectionViewCell.h"

@interface BEMCollectionViewController ()

@property (nonatomic, strong) NSArray *checkBoxes;

@end

@implementation BEMCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor * const defaultBlue = [UIColor colorWithRed:0 green:122.0/255.0 blue:255/255 alpha:1];
    
    self.checkBoxes = @[@{@"title": @"test", @"boxType": @1}, @{@"title": @"test2"}, @{@"title": @"test"},
                        @{@"title": @"test2", @"boxType": @1, @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @1, @"offAnimationType": @1}, @{@"title": @"test", @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @1, @"offAnimationType": @1}, @{@"title": @"test2"},
                       @{@"title": @"test2", @"boxType": @1, @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @2, @"offAnimationType": @2}, @{@"title": @"test", @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @2, @"offAnimationType": @2}, @{@"title": @"test2"},
                        @{@"title": @"test2", @"boxType": @1, @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @3, @"offAnimationType": @3}, @{@"title": @"test", @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @3, @"offAnimationType": @3}, @{@"title": @"test2"},
                        @{@"title": @"test2", @"boxType": @1, @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @4, @"offAnimationType": @3}, @{@"title": @"test", @"onFillColor": defaultBlue, @"onCheckColor": [UIColor whiteColor], @"onAnimationType": @3, @"offAnimationType": @3}, @{@"title": @"test2"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.checkBoxes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEMCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *checkBoxDict = self.checkBoxes[indexPath.row];
    
    cell.title.text = checkBoxDict[@"title"];
    
    for (NSString *key in checkBoxDict) {
        if (![key  isEqual: @"title"]) {
            id value = checkBoxDict[key];
            [cell.checkBox setValue:value forKey:key];
        }
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewFlowLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/3, self.view.bounds.size.width/3);
}

@end
