//
//  LoginViewController.m
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "LoginViewController.h"
#import "DataProvider.h"
#import <Accounts/Accounts.h>



@interface LoginViewController ()

@end



@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onLogin:(id)sender
{
    _labelError.hidden = YES;
    
    __weak typeof (self) __weakself = self;
    [[DataProvider sharedProvider] loginWithCompletionHandler:^(BOOL granted, BOOL loggedIn, NSArray *accounts)
     {
         [__weakself handleAccessGranted:granted loggedIn:loggedIn accountsToChoose:accounts];
     }];
}

- (void)handleAccessGranted:(BOOL)accessGranted loggedIn:(BOOL)loggedIn accountsToChoose:(NSArray*)accounts
{
    if (loggedIn) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (!accessGranted) {
        _labelError.text = @"please provide access to twitter account";
        _labelError.hidden = NO;
    }
    else if (accounts.count == 0) {
        _labelError.text = @"there is no twitter account. please create one";
        _labelError.hidden = NO;
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose an account"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        __weak typeof (self) __weakself = self;
        for (ACAccount *account in accounts)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:account.username
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [__weakself handleAccountChoosen:account];
                                                           }];
            [alert addAction:action];
        }
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (void)handleAccountChoosen:(ACAccount*)account
{
    [[DataProvider sharedProvider] chooseAccount:account];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
