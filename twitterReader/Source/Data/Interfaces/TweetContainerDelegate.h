//
//  TweetContainerDelegate.h
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#ifndef TweetContainerDelegate_h
#define TweetContainerDelegate_h



@class TweetContainer;



@protocol TweetContainerDelegate <NSObject>

- (void)tweetContainer:(TweetContainer*)container didLoadTweetsAtIndexSet:(NSIndexSet*)indexSet;
- (void)tweetContainer:(TweetContainer*)container didFailWithError:(NSError*)error;

- (void)tweetContainerDidFinishLoadingHead:(TweetContainer*)container;

@end

#endif /* TweetContainerDelegate_h */
