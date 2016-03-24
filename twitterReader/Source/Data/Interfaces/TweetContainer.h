//
//  TweetContainer.h
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetContainerDelegate.h"
#import "TweetDataSource.h"



@class TweetListController;



@interface TweetContainer : NSObject <TweetDataSource> {
    
    NSMutableArray *_tweets;
    TweetListController *_tweetListController;
    
    NSNumber *_topId;
    NSNumber *_lastId;
    
    BOOL _loadingHead;
    NSMutableArray *_headLoadedTweets;
}

@property (nonatomic, weak) id<TweetContainerDelegate> delegate;

@end
