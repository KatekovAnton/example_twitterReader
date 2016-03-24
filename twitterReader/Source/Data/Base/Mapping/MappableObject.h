//
//  MappableObject.h
//  twitterReader
//
//  Created by Katekov Anton on 06.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#ifndef MappableObject_h
#define MappableObject_h

#import <Foundation/Foundation.h>



@protocol MappableObject <NSObject>

- (void)readFromDictionaryRepresentation:(NSDictionary*)dictionary;

@end


#endif /* MappableObject_h */
