//
//  FeedGridViewController.h
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetDataSource.h"



@class FeedGridCollectionViewLayout;



@interface FeedGridViewController : UICollectionViewController {

    IBOutlet FeedGridCollectionViewLayout *_collectionViewLayout;
    UIRefreshControl *_refresh;
    
}

@property (nonatomic) id<TweetDataSource> tweetSource;

- (void)insertItemsAtIndexSet:(NSIndexSet*)indexSet;
- (void)reloadData;

- (void)startRefreshing;
- (void)endRefreshing;

@end
