//
//  DataProvider.h
//  twitterReader
//
//  Created by Katekov Anton on 01.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString *DataProviderLoginStatusChangedNotify;



typedef void (^LoginCompletionHandler)(BOOL granted, BOOL loggedIn, NSArray *accounts);



@class ACAccount;
@class AuthorizationController;



@interface DataProvider : NSObject {
    
    AuthorizationController *_authorizationController;

}

@property (nonatomic, readonly) BOOL loggedIn;

+ (DataProvider *)sharedProvider;

- (void)loginWithCompletionHandler:(LoginCompletionHandler)completionHandler;
- (void)chooseAccount:(ACAccount*)account;
- (void)logout;

@end
