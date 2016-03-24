//
//  NSError+Additions.m
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "NSError+Additions.h"



@implementation NSError (Additions)

- (BOOL)isRateLimitError
{
    return [[self.userInfo objectForKey:@"code"] intValue] == 88;
}

- (BOOL)isNoAccess
{
    return [[self.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"Could not prepare the URL request."];
}

@end
