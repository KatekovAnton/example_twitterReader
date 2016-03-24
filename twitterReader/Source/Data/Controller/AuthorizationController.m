//
//  AuthorizationController.m
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "AuthorizationController.h"



@interface AuthorizationController ()

@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *twitterAccountType;

@end



@implementation AuthorizationController

- (id)init
{
    if (self = [super init]) {
        self.accountStore = [[ACAccountStore alloc] init];
        self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if (self.twitterAccountType.accessGranted) {
            [self onTwitterAccessGranted];
        }
    }
    return self;
}

- (void)handleAccountChoosen:(ACAccount*)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account.identifier forKey:@"accountIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.account = account;
}

- (void)onTwitterAccessGranted
{
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
    if (twitterAccounts.count == 0)
        return;
    
    if (twitterAccounts.count == 1)
        self.account = twitterAccounts[0];
    else
    {
        self.accounts = twitterAccounts;
        NSString *accountIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountIdentifier"];
        if (accountIdentifier)
            self.account = [self accountWithIdentifier:accountIdentifier inAccountArray:self.accounts];
    }
}

- (ACAccount *)accountWithIdentifier:(NSString*)identifier inAccountArray:(NSArray*)accountArray
{
    for (ACAccount *account in accountArray) {
        if ([account.identifier isEqualToString:identifier]) {
            return account;
        }
    }
    return nil;
}

- (void)chooseAccount:(ACAccount*)account
{
    [self handleAccountChoosen:account];
}

- (void)loginWithCompletionHandler:(AuthorizationCompletionHandler)completionHandler
{
    __weak typeof (self) __weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [self.accountStore requestAccessToAccountsWithType:__weakself.twitterAccountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error)
         {
             [__weakself onTwitterAccessGranted];
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                completionHandler (granted, __weakself.account != nil, __weakself.accounts);
                            });
         }];
    });
}

- (void)logout
{
    self.account = nil;
    self.accounts = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accountIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
