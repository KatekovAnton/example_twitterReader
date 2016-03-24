//
//  FeedFlowViewController.m
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "FeedFlowViewController.h"
#import "FeedFlowTableViewCell.h"



@interface FeedFlowViewController () {
    
}

@end



@implementation FeedFlowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r = self.navigationController.navigationBar.frame;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(r), 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedFlowTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FeedFlowTableViewCell"];
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _refresh = [[UIRefreshControl alloc] init];
    _refresh.tintColor = [UIColor blackColor];
    [_refresh addTarget:self
                 action:@selector(onUpdate:)
       forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refresh];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
}

- (void)setTweetSource:(id<TweetDataSource>)tweetSource
{
    _tweetSource = tweetSource;
    [self.tableView reloadData];
}

- (void)onUpdate:(UIRefreshControl*)sender
{
    [self.tweetSource loadHead];
}

- (void)insertItemsAtIndexSet:(NSIndexSet*)indexSet
{
    if (indexSet.count == 0)
        return;
    
    if ([self.tableView numberOfRowsInSection:0] > 0 && ![indexSet containsIndex:0]) {
        [self.tableView reloadData];
        return;
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger i = indexSet.firstIndex; i <= indexSet.lastIndex; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)startRefreshing
{
    [_refresh beginRefreshing];
}

- (void)endRefreshing
{
    [_refresh endRefreshing];
}

#pragma mark - Table view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height > 1 &&
        scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - scrollView.frame.size.height) {
        [_tweetSource loadTail];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    FeedFlowTableViewCell *tweetCell = (FeedFlowTableViewCell*)cell;
    [tweetCell prepareToPresentation];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedFlowTableViewCell *tweetCell = (FeedFlowTableViewCell*)cell;
    [tweetCell finishPresentation];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.tweetSource tweetAtIndex:indexPath.row];
    return [FeedFlowTableViewCell estimateHeightOfTweet:tweet];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tweetSource numberOfTweets];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.tweetSource tweetAtIndex:indexPath.row];
    
    FeedFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedFlowTableViewCell" forIndexPath:indexPath];
    cell.tableViewWidth = tableView.frame.size.width;
    cell.tweet = tweet;
    return cell;
}

@end
