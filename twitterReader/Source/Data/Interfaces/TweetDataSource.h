//
//  TweetDataSource.h
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#ifndef TweetDataSource_h
#define TweetDataSource_h

#import <Foundation/Foundation.h>



@class Tweet;



@protocol TweetDataSource <NSObject>

- (NSInteger)numberOfTweets;
- (Tweet*)tweetAtIndex:(NSInteger)index;
- (void)loadTail;
- (void)loadHead;

@end

#endif /* TweetDataSource_h */
