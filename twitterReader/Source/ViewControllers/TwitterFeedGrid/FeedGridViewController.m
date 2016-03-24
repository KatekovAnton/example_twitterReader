//
//  FeedGridViewController.m
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "FeedGridViewController.h"
#import "FeedGridCollectionViewCell.h"
#import "FeedGridCollectionViewLayout.h"
#import "FeedGridCollectionViewCell.h"



@interface FeedGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FeedGridCollectionViewLayoutDelegate> {
    
}

@end



@implementation FeedGridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r = self.navigationController.navigationBar.frame;
    self.collectionView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(r), 0, 0, 0);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedGridCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FeedGridCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    _refresh = [[UIRefreshControl alloc] init];
    _refresh.tintColor = [UIColor blackColor];
    [_refresh addTarget:self
                 action:@selector(onUpdate:)
       forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refresh];
    
    _collectionViewLayout.numberOfColumns = 2;
    _collectionViewLayout.cellPadding = 6;
    _collectionViewLayout.delegate = self;
}

- (void)onUpdate:(UIRefreshControl*)sender
{
    [self.tweetSource loadHead];
}

- (void)insertItemsAtIndexSet:(NSIndexSet*)indexSet
{
    if (indexSet.count == 0)
        return;
    
    if (!self.isViewLoaded)
        return;
    
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        [self.collectionView reloadData];
        return;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger i = indexSet.firstIndex; i <= indexSet.lastIndex; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)reloadData
{
    if (!self.isViewLoaded) {
        return;
    }
    [self.collectionView reloadData];
}

- (void)startRefreshing
{
    [_refresh beginRefreshing];
}

- (void)endRefreshing
{
    [_refresh endRefreshing];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tweetSource numberOfTweets];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedGridCollectionViewCell" forIndexPath:indexPath];
    Tweet *tweet = [self.tweetSource tweetAtIndex:indexPath.row];
    cell.tweet = tweet;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height > 1 &&
        scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - scrollView.frame.size.height) {
        [_tweetSource loadTail];
    }
}

#pragma mark - FeedGridCollectionViewLayoutDelegate <NSObject>

- (CGFloat)feedGridCollectionViewLayout:(FeedGridCollectionViewLayout*)collectionViewLayout sizeForItem:(NSIndexPath*)item forWidth:(CGFloat)width
{
    Tweet *tweet = [self.tweetSource tweetAtIndex:item.row];
    return [FeedGridCollectionViewCell heightForTweet:tweet forWidth:width];
}

@end
