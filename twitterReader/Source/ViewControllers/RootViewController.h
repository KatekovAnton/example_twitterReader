//
//  RootViewController.h
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RootViewController : UINavigationController

+ (RootViewController*)sharedInstance;

- (void)presentLoginUIAnimated:(BOOL)animated;

@end
