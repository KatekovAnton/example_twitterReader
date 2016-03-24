//
//  AuthorizationController.h
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>



typedef void (^AuthorizationCompletionHandler)(BOOL granted, BOOL loggedIn, NSArray *accountsToChoose);



@interface AuthorizationController : NSObject {
    
}

@property (nonatomic, strong) ACAccount *account;
@property (nonatomic, strong) NSArray<__kindof ACAccount*> *accounts;

- (void)loginWithCompletionHandler:(AuthorizationCompletionHandler)completionHandler;
- (void)chooseAccount:(ACAccount*)account;
- (void)logout;

@end
