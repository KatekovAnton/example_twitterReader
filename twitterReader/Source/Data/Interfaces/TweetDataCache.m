//
//  TweetDataCache.m
//  twitterReader
//
//  Created by Katekov Anton on 13.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "TweetDataCache.h"
#import "NSMutableAttributedString+Additions.h"
#import "Entities.h"



@implementation TweetDataCache

__strong TweetDataCache *_gTweetDataCacheInstance = nil;

__strong UIImage *_staticImageLiked = nil;
__strong UIImage *_staticImageRetweeted = nil;

+ (TweetDataCache *)instance
{
    if (!_gTweetDataCacheInstance) {
        _gTweetDataCacheInstance = [[TweetDataCache alloc] init];
    }
    return _gTweetDataCacheInstance;
}

- (NSAttributedString*)formattedStringForTweet:(Tweet*)tweet
{
    if (!_tweetTextCache) {
        _tweetTextCache = [NSMutableDictionary dictionary];
    }
    
    NSAttributedString *result = _tweetTextCache [tweet.pk];
    if (!result) {
        result = [NSMutableAttributedString attributedStringWithString:tweet.text entities:tweet.entities];
        [_tweetTextCache setObject:result forKey:tweet.pk];
    }
    return result;
}

+ (UIImage*)imageRetweeted
{
    if (!_staticImageRetweeted)
        _staticImageRetweeted = [[UIImage imageNamed:@"icon_retweeted"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return _staticImageRetweeted;
}

+ (UIImage*)imageLiked
{
    if (!_staticImageLiked)
        _staticImageLiked = [[UIImage imageNamed:@"icon_liked"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return _staticImageLiked;
}

@end
