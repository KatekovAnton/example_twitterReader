//
//  NSError+Additions.h
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSError (Additions)

- (BOOL)isRateLimitError;
- (BOOL)isNoAccess;

@end
