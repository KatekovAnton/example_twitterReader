//
//  TweetListController.m
//  twitterReader
//
//  Created by Katekov Anton on 01.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "TweetListController.h"
#import "Entities.h"



@implementation TweetListController

+ (NSUInteger)countOfTweetsPerRequest
{
    return 20;
}

- (void)loadWithMaxId:(NSNumber*)maxId sinceId:(NSNumber*)sinceId completionHandler:(void(^)(NSArray *result, NSError *error))completionHandler
{
    NSString *url = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", (int)[TweetListController countOfTweetsPerRequest]] forKey:@"count"];
    if (maxId)
        [parameters setObject:[maxId stringValue] forKey:@"max_id"];
    if (sinceId)
        [parameters setObject:[sinceId stringValue] forKey:@"since_id"];
    
    __weak typeof(self) __weakself = self;
    [self sendRequrestWithMethod:kRequestMethodGET
                       URLString:url
                      parameters:parameters
                         success:^(id responseObject, NSString *requstURL)
     {
         if (!__weakself)
             return;
         
         completionHandler (responseObject, nil);
     }
                         failure:^(NSError *error, NSString *requstURL)
     {
         if (!__weakself)
             return;
         
         completionHandler (nil, error);
     }];
}

#pragma mark - Override base class mapping method

- (id)performMappingForResponce:(id)responce forRequsetURL:(NSString*)requestURL
{
    return [Tweet arrayOfObjectsFromArrayOfDictionaryRepresentations:responce];
}

@end
