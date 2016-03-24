//
//  TweetListController.h
//  twitterReader
//
//  Created by Katekov Anton on 01.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "BaseNetworkController.h"



@interface TweetListController : BaseNetworkController {

}

+ (NSUInteger)countOfTweetsPerRequest; 

- (void)loadWithMaxId:(NSNumber*)maxId sinceId:(NSNumber*)sinceId completionHandler:(void(^)(NSArray *result, NSError *error))completionHandler;

@end
