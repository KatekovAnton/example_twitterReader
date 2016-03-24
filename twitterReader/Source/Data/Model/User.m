//
//  User.m
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "User.h"



@implementation User

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    [super readFromDictionaryRepresentation:dictionary];
    self.name = dictionary[@"name"];
    self.screenName = dictionary[@"screen_name"];
    self.profileImageUrl = dictionary[@"profile_image_url"];
}

@end
