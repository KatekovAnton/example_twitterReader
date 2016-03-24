//
//  RootViewController.m
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "RootViewController.h"



@implementation RootViewController

__strong static RootViewController *_gRootViewControllerInstance = nil;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _gRootViewControllerInstance = self;
    }
    return self;
}

+ (RootViewController*)sharedInstance
{
    return _gRootViewControllerInstance;
}

- (void)presentLoginUIAnimated:(BOOL)animated
{
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        });
    }
    else
        [self performSegueWithIdentifier:@"presetnLoginViewController" sender:self];
    
}

@end
