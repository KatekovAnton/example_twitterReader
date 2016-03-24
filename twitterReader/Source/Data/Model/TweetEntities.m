//
//  TweetEntities.m
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "TweetEntities.h"



@implementation TweetEntity

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    [super readFromDictionaryRepresentation:dictionary];
    self.indecesFrom = dictionary[@"indices"][0];
    self.indecesTo = dictionary[@"indices"][1];
}

- (NSRange)rangeInText
{
    NSInteger length = self.indecesTo.integerValue - self.indecesFrom.integerValue;
    return NSMakeRange(self.indecesFrom.integerValue, length);
}

- (TweetEntity*)copy
{
    TweetEntity *result = [[[self class] alloc] init];
    result.pk = self.pk;
    result.indecesFrom = self.indecesFrom;
    result.indecesTo = self.indecesTo;
    return result;
}

@end



@implementation TweetEntityMedia

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    [super readFromDictionaryRepresentation:dictionary];
    self.type = dictionary[@"type"];
    self.displayUrl = dictionary[@"display_url"];
    self.expandedUrl = dictionary[@"expanded_url"];
    self.mediaUrl = dictionary[@"media_url"];
    self.videoInfo = dictionary[@"video_info"];
    //    if ([self.type isEqualToString:@"video"]) {
    //        int a = 0;
    //        a++;
    //    }
}

- (TweetEntity*)copy
{
    TweetEntityMedia *result = (TweetEntityMedia *)[super copy];
    result.type = self.type;
    result.displayUrl = self.displayUrl;
    result.expandedUrl = self.expandedUrl;
    result.mediaUrl = self.mediaUrl;
    result.videoInfo = self.videoInfo;
    return result;
}

@end



@implementation TweetEntityUrl

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    [super readFromDictionaryRepresentation:dictionary];
    self.displayUrl = dictionary[@"display_url"];
    self.expandedUrl = dictionary[@"expanded_url"];
    self.url = dictionary[@"url"];
}

- (TweetEntity*)copy
{
    TweetEntityUrl *result = (TweetEntityUrl *)[super copy];
    result.displayUrl = self.displayUrl;
    result.expandedUrl = self.expandedUrl;
    result.url = self.url;
    return result;
}

@end



@implementation TweetEntities

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    [super readFromDictionaryRepresentation:dictionary];
    self.hastags = [TweetEntity arrayOfObjectsFromArrayOfDictionaryRepresentations:dictionary[@"hashtags"]];
    [self.hastags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetEntity *item = obj;
        item.entityType = TweetEntityTypeHashtag;
    }];
    self.media = [TweetEntityMedia arrayOfObjectsFromArrayOfDictionaryRepresentations:dictionary[@"media"]];
    [self.media enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetEntity *item = obj;
        item.entityType = TweetEntityTypeMedia;
    }];
    self.symbols = [TweetEntity arrayOfObjectsFromArrayOfDictionaryRepresentations:dictionary[@"symbols"]];
    [self.symbols enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetEntity *item = obj;
        item.entityType = TweetEntityTypeSymbol;
    }];
    self.urls = [TweetEntityUrl arrayOfObjectsFromArrayOfDictionaryRepresentations:dictionary[@"urls"]];
    [self.urls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetEntity *item = obj;
        item.entityType = TweetEntityTypeUrl;
    }];
    self.userMentions = [TweetEntity arrayOfObjectsFromArrayOfDictionaryRepresentations:dictionary[@"user_mentions"]];
    [self.userMentions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetEntity *item = obj;
        item.entityType = TweetEntityTypeUserMention;
    }];
}

@end

