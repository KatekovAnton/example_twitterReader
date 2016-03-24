//
//  ViewController.m
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "ViewController.h"
#import "FeedFlowViewController.h"
#import "FeedGridViewController.h"
#import "RootViewController.h"
#import "TweetContainer.h"
#import "DataProvider.h"
#import "NSMutableAttributedString+Additions.h"
#import "UIColor+Additions.h"
#import "NSError+Additions.h"



@interface ViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
}

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    
    TweetEntitiesAppearance *appearance = [TweetEntitiesAppearance sharedAppearance];
    appearance.colorForHastags = [UIColor colorFromHex:0x0084B4];
    
    _feedFlow = [[FeedFlowViewController alloc] init];
    _feedGrid = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedGridViewController"];
    [self setViewControllers:@[_feedFlow] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    
    [self createTweetContainer];
    
    if ([DataProvider sharedProvider].loggedIn)
        [_tweetContainer loadTail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginStatusChanged:) name:DataProviderLoginStatusChangedNotify object:nil];
}

- (void)createTweetContainer
{
    _tweetContainer = [[TweetContainer alloc] init];
    _tweetContainer.delegate = self;
    
    _feedFlow.tweetSource = _tweetContainer;
    _feedGrid.tweetSource = _tweetContainer;
    [_feedFlow reloadData];
    [_feedGrid reloadData];

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

- (void)onLoginStatusChanged:(NSNotification*)notification
{
    if ([DataProvider sharedProvider].loggedIn) {
        [self createTweetContainer];
        [_tweetContainer loadTail];
    }
    else {
        
    }
}

- (void)onTabChanged:(UISegmentedControl*)sender
{
    if (_segments.selectedSegmentIndex == 0)
    {
        [self setViewControllers:@[_feedFlow] direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
    }
    else if (_segments.selectedSegmentIndex == 1)
    {
        [self setViewControllers:@[_feedGrid] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    }
}

#pragma mark - UIPageViewControllerDataSource <NSObject>

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (viewController == _feedGrid)
        return _feedFlow;
    
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (viewController == _feedFlow) {
        return _feedGrid;
    }
    
    return nil;
}

#pragma mark - UIPageViewControllerDelegate <NSObject>

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (previousViewControllers.firstObject == _feedFlow)
        _segments.selectedSegmentIndex = 1;
    else
        _segments.selectedSegmentIndex = 0;
}

#pragma mark - 

- (void)tweetContainer:(TweetContainer*)container didLoadTweetsAtIndexSet:(NSIndexSet*)indexSet
{
    [_feedFlow insertItemsAtIndexSet:indexSet];
    [_feedGrid insertItemsAtIndexSet:indexSet];
}

- (void)tweetContainer:(TweetContainer*)container didFailWithError:(NSError*)error
{
    if ([error isRateLimitError]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                       message:@"Maximum number of requests reached. Please try again later"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else if ([error isNoAccess])
    {
        [[RootViewController sharedInstance] presentLoginUIAnimated:YES];
    }
}

- (void)tweetContainerDidFinishLoadingHead:(TweetContainer*)container
{
    [_feedFlow endRefreshing];
    [_feedGrid endRefreshing];
}

@end
