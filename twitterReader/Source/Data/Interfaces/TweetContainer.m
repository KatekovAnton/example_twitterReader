//
//  TweetContainer.m
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "TweetContainer.h"
#import "TweetListController.h"
#import "Entities.h"
#import "DataProvider.h"



@implementation TweetContainer

- (id)init
{
    if (self = [super init]) {
        
        _tweetListController = [[TweetListController alloc] init];
        
    }
    return self;
}

- (void)handleLoadedTailTweets:(NSArray*)tweets
{
    if (tweets.count > 0)
    {
        Tweet *lastTweet = tweets.lastObject;
        _lastId = [NSNumber numberWithUnsignedLongLong:[lastTweet.pk unsignedLongLongValue] - 1];
        
        if (!_topId) {
            Tweet *firstTweet = tweets.firstObject;
            _topId = firstTweet.pk;
        }
        
        if (!_tweets)
            _tweets = [NSMutableArray array];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_tweets.count, tweets.count)];
        [_tweets addObjectsFromArray:tweets];
        [self.delegate tweetContainer:self didLoadTweetsAtIndexSet:indexSet];
    }
}

- (void)handleLoadedHeadTweets:(NSArray*)tweets
{
    [_headLoadedTweets addObjectsFromArray:tweets];
    
    if (tweets.count < [TweetListController countOfTweetsPerRequest])
    {
        // we have loaded all head, its time to
        // correct maxId and since id values
        // merge results and call delegate
        if (tweets.count > 0)
        {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _headLoadedTweets.count)];
            [_tweets insertObjects:_headLoadedTweets atIndexes:indexSet];
            
            Tweet *firstTweet = _headLoadedTweets.firstObject;
            _topId = firstTweet.pk;
            
            [self.delegate tweetContainer:self didLoadTweetsAtIndexSet:indexSet];
        }
        
        //cleanup
        _headLoadedTweets = nil;
        _loadingHead = NO;
        [self.delegate tweetContainerDidFinishLoadingHead:self];
    }
    else
    {
        // we have loaded maximum number of tweets
        // we may try to find a way to handle this
        // gap between maxid <-> sinceid
        // but I dont think it is critical
        
        
        Tweet *lastTweet = _headLoadedTweets.lastObject;
        NSNumber *maxId = [NSNumber numberWithUnsignedLongLong:[lastTweet.pk unsignedLongLongValue] - 1];
        NSNumber *sinceId = _topId;
        
        __weak typeof(self) __weakself = self;
        [_tweetListController loadWithMaxId:maxId sinceId:sinceId completionHandler:^(NSArray *result, NSError *error)
         {
             if (result)
                 [__weakself handleLoadedHeadTweets:result];
             else
                 [__weakself handleLoadedError:error];
         }];
    }
}

- (void)handleLoadedError:(NSError*)error
{
    if (_loadingHead) {
        //cleanup
        _headLoadedTweets = nil;
        _loadingHead = NO;
        
        [self handleLoadedHeadTweets:[NSArray array]];
    }
    [self.delegate tweetContainer:self didFailWithError:error];
}

#pragma mark - TweetDataSource <NSObject>

- (NSInteger)numberOfTweets
{
    return _tweets.count;
}

- (Tweet*)tweetAtIndex:(NSInteger)index
{
    return _tweets[index];
}

- (void)loadHead
{
    if (_loadingHead)
        return;
    
    if (!_topId) {
        // todo:
        // we didnt load even first bunch of tweets
        // tell somehow about that
        if (_tweetListController.isLoading) {
            __weak typeof(self) __weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [__weakself handleLoadedHeadTweets:nil];
            });
        }
        else
            [self loadTail];
        
        return;
    }
    
    if (!_loadingHead) {
        _loadingHead = YES;
        _headLoadedTweets = [NSMutableArray array];
    }
    
    __weak typeof(self) __weakself = self;
    [_tweetListController loadWithMaxId:nil sinceId:_topId completionHandler:^(NSArray *result, NSError *error)
     {
         if (result)
             [__weakself handleLoadedHeadTweets:result];
         else
             [__weakself handleLoadedError:error];
     }];
}

- (void)loadTail
{
    if (_tweetListController.isLoading)
        return;
    
    __weak typeof(self) __weakself = self;
    [_tweetListController loadWithMaxId:_lastId sinceId:nil completionHandler:^(NSArray *result, NSError *error)
     {
         if (result)
             [__weakself handleLoadedTailTweets:result];
         else
             [__weakself handleLoadedError:error];
         
     }];
}

@end
