//
//  TweetEntities.h
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "BaseObject.h"



typedef NS_ENUM(NSUInteger, TweetEntityType) {
    TweetEntityTypeHashtag,
    TweetEntityTypeMedia,
    TweetEntityTypeSymbol,
    TweetEntityTypeUrl,
    TweetEntityTypeUserMention
};



@interface TweetEntity : BaseObject

@property (nonatomic) TweetEntityType entityType;
@property (nonatomic) NSNumber* indecesFrom;
@property (nonatomic) NSNumber* indecesTo;

- (NSRange)rangeInText;

- (TweetEntity*)copy;

@end



@interface TweetEntityMedia : TweetEntity

@property (nonatomic) NSString* type;
@property (nonatomic) NSString* displayUrl;
@property (nonatomic) NSString* expandedUrl;
@property (nonatomic) NSString* mediaUrl;
@property (nonatomic) NSDictionary *videoInfo;

@end



@interface TweetEntityUrl : TweetEntity

@property (nonatomic) NSString* displayUrl;
@property (nonatomic) NSString* expandedUrl;
@property (nonatomic) NSString* url;

@end



@interface TweetEntities : BaseObject

@property (nonatomic) NSArray* hastags;
@property (nonatomic) NSArray* media;
@property (nonatomic) NSArray* symbols;
@property (nonatomic) NSArray* urls;
@property (nonatomic) NSArray* userMentions;

@end

