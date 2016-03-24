//
//  BaseObject.m
//  twitterReader
//
//  Created by Katekov Anton on 06.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "BaseObject.h"



@implementation BaseObject

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    self.pk = dictionary [@"id"];
}

+ (BaseObject *)objectFromDictionaryRepresentation:(NSDictionary*)dictionary
{
    if (!dictionary)
        return nil;
    
    BaseObject *result = [[self alloc] init];
    [result readFromDictionaryRepresentation:dictionary];
    return result;
}

+ (NSArray *)arrayOfObjectsFromArrayOfDictionaryRepresentations:(NSArray*)array
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *item in array) {
        [result addObject:[self objectFromDictionaryRepresentation:item]];
    }
    return result;
}

+ (NSDate*)dateWithString:(NSString*)string
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //Fri Jan 08 01:03:29 +0000 2016
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [df dateFromString:string];
    return date;
}

@end
