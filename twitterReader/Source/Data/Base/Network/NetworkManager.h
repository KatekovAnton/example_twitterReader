//
//  NetworkManager.h
//  twitterReader
//
//  Created by Katekov Anton on 05.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>



/*
 * Represents current method of network connection
 */
@interface NetworkManager : NSObject {
    
}

@property (nonatomic) ACAccount *account;

+ (NetworkManager *)instance;

- (SLRequest *)GET:(NSString *)URLString
        parameters:(id)parameters
           success:(void (^)(SLRequest *request, id response))success
           failure:(void (^)(SLRequest *request, NSError *error))failure;

@end
