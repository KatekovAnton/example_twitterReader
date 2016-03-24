//
//  Tweet.h
//  twitterReader
//
//  Created by Katekov Anton on 01.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "BaseObject.h"



@class User;
@class TweetEntities;



@interface Tweet : BaseObject

@property (nonatomic) NSDate*   createdAt;
@property (nonatomic) TweetEntities*    entities;
@property (nonatomic) TweetEntities*    extendedEntities;
@property (nonatomic) NSString* inReplyToScreenName;
@property (nonatomic) id        inReplyToStatusId;
@property (nonatomic) id        inReplyToUserId;
@property (nonatomic) NSNumber* favoriteCount;
@property (nonatomic) NSNumber* favorited;
@property (nonatomic) NSNumber* retweetCount;
@property (nonatomic) NSNumber* retweeted;
@property (nonatomic) Tweet *   retweetedStatus;
@property (nonatomic) id        geo;
@property (nonatomic) NSNumber* isQuoteStatus;
@property (nonatomic) NSString* lang;
@property (nonatomic) id        place;
@property (nonatomic) NSString* text;
@property (nonatomic) NSNumber* truncated;
@property (nonatomic) User*     user;

- (NSString *)decodedText;

@end
