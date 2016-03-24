//
//  Tweet.m
//  twitterReader
//
//  Created by Katekov Anton on 01.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "Tweet.h"
#import "Entities.h"



@implementation Tweet

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    [super readFromDictionaryRepresentation:dictionary];
    
    self.createdAt = [BaseObject dateWithString:dictionary[@"created_at"]];
    self.entities = (TweetEntities*)[TweetEntities objectFromDictionaryRepresentation:dictionary[@"entities"]];
    self.extendedEntities = (TweetEntities*)[TweetEntities objectFromDictionaryRepresentation:dictionary[@"extended_entities"]];
    self.inReplyToScreenName = dictionary[@"in_reply_to_screen_name"];
    self.inReplyToStatusId = dictionary[@"in_reply_to_status_id"];
    self.inReplyToUserId = dictionary[@"in_reply_to_user_id"];
    self.favoriteCount = dictionary[@"favorite_count"];
    self.favorited = dictionary[@"favorited"];
    self.retweetCount = dictionary[@"retweet_count"];
    self.retweeted = dictionary[@"retweeted"];
    self.retweetedStatus = (Tweet*)[Tweet objectFromDictionaryRepresentation:dictionary[@"retweeted_status"]];
    self.geo = dictionary[@"geo"];
    self.isQuoteStatus = dictionary[@"is_quote_status"];
    self.lang = dictionary[@"lang"];
    self.place = dictionary[@"place"];
    self.text = dictionary[@"text"];
    self.truncated = dictionary[@"truncated"];
    self.user = (User*)[User objectFromDictionaryRepresentation:dictionary[@"user"]];
}

- (NSString *)decodedText
{
    NSString *result = [[self text] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    result = [result stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    return result;
}

@end
