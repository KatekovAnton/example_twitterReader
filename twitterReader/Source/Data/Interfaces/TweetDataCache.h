//
//  TweetDataCache.h
//  twitterReader
//
//  Created by Katekov Anton on 13.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Tweet;



@interface TweetDataCache : NSObject {
    
    NSMutableDictionary *_tweetTextCache;
    
}

+ (TweetDataCache *)instance;

- (NSAttributedString*)formattedStringForTweet:(Tweet*)tweet;

+ (UIImage*)imageRetweeted;
+ (UIImage*)imageLiked;

@end
