//
//  BaseObject.h
//  twitterReader
//
//  Created by Katekov Anton on 06.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappableObject.h"



@interface BaseObject : NSObject <MappableObject>

@property (nonatomic) id pk;

+ (BaseObject *)objectFromDictionaryRepresentation:(NSDictionary*)dictionary;
+ (NSArray *)arrayOfObjectsFromArrayOfDictionaryRepresentations:(NSArray*)array;

// mapping replacement
+ (NSDate*)dateWithString:(NSString*)string;

@end
