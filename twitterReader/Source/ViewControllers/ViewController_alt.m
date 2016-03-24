//
//  ViewController.m
//  twitterReader
//
//  Created by Katekov Anton on 22.12.15.
//  Copyright © 2015 katekovanton. All rights reserved.
//

#import "ViewController.h"
#import "TweetCollectionViewCell.h"
#import "LoginViewController.h"



@interface ViewController () {
    
}

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _layoutFlow.estimatedItemSize = CGSizeMake(screenWidth, 200);
    _layoutFlow.minimumLineSpacing = 0;
    _layoutFlow.minimumInteritemSpacing = 0;
    
    _layoutGrid = [[UICollectionViewFlowLayout alloc] init];
    _layoutGrid.itemSize = CGSizeMake(screenWidth/3, 150);
    _layoutGrid.minimumLineSpacing = 0;
    _layoutGrid.minimumInteritemSpacing = 0;

    _collectionRefresh = [[UIRefreshControl alloc] init];
    _collectionRefresh.tintColor = [UIColor blackColor];
    [_collectionRefresh addTarget:self
                 action:@selector(onUpdate:)
       forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_collectionRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    {
        NSArray *items = @[@"Flow", @"Grid"];
        _segments = [[UISegmentedControl alloc] initWithItems:items];
        [_segments addTarget:self action:@selector(onTabChanged:) forControlEvents:(UIControlEventValueChanged)];
        [_segments setWidth:100 forSegmentAtIndex:0];
        [_segments setWidth:100 forSegmentAtIndex:1];
        [_segments setSelectedSegmentIndex:0];
        [self.navigationItem setTitleView:_segments];
    }
}

- (void)onUpdate:(UIRefreshControl*)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_collectionRefresh endRefreshing];
    });
}

- (void)onTabChanged:(UISegmentedControl*)sender
{
    if (_segments.selectedSegmentIndex == 0)
    {
        [_collectionView setCollectionViewLayout:_layoutFlow animated:YES];
    }
    else if (_segments.selectedSegmentIndex == 1)
    {
        [_collectionView setCollectionViewLayout:_layoutGrid animated:YES];
    }
    
}

#pragma mark - UICollectionViewDataSource <NSObject>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

@end
