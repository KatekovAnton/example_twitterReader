//
//  ViewController.h
//  twitterReader
//
//  Created by Katekov Anton on 02.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetContainerDelegate.h"



@class TweetContainer;
@class FeedFlowViewController;
@class FeedGridViewController;



@interface ViewController : UIPageViewController <TweetContainerDelegate> {
    
    TweetContainer *_tweetContainer;
    
    UISegmentedControl *_segments;
    
    FeedFlowViewController *_feedFlow;
    FeedGridViewController *_feedGrid;
    
}

@end
