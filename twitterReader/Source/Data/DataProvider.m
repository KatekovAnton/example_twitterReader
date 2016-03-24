//
//  DataProvider.m
//  twitterReader
//
//  Created by Katekov Anton on 01.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "DataProvider.h"
#import "AuthorizationController.h"
#import "NetworkManager.h"



NSString *DataProviderLoginStatusChangedNotify = @"DataProviderLoginStatusChangedNotify";



@implementation DataProvider

__strong static DataProvider *_gInstance = nil;

+ (DataProvider *)sharedProvider {
    @synchronized(self) {
        
        if (!_gInstance) {
            _gInstance = [[DataProvider alloc] init];
        }
        
        return _gInstance;
    }
    return nil;
}

- (id)init
{
    if (self = [super init])
    {
        _authorizationController = [[AuthorizationController alloc] init];
        if (self.loggedIn) {
            [NetworkManager instance].account = _authorizationController.account;
        }
    }
    return self;
}

- (BOOL)loggedIn
{
    return _authorizationController.account != nil;
}

- (void)logout
{
    [_authorizationController logout];
}

- (void)loginWithCompletionHandler:(LoginCompletionHandler)completionHandler
{
    [_authorizationController loginWithCompletionHandler:^(BOOL granted, BOOL loggedIn, NSArray *accounts)
     {
         completionHandler (granted, loggedIn, _authorizationController.accounts);
         
         if (_authorizationController.account) {
             [NetworkManager instance].account = _authorizationController.account;
             [[NSNotificationCenter defaultCenter] postNotificationName:DataProviderLoginStatusChangedNotify object:nil];
         }
     }];
}

- (void)chooseAccount:(ACAccount*)account
{
    [_authorizationController chooseAccount:account];
    [NetworkManager instance].account = _authorizationController.account;
    [[NSNotificationCenter defaultCenter] postNotificationName:DataProviderLoginStatusChangedNotify object:nil];
}

@end
