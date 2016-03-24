//
//  TweetMediaView.h
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TweetEntityMedia;
@class TweetMediaInternalView;



@interface TweetMediaView : UIView {
    TweetMediaInternalView *_internalView;
}

- (void)setMedia:(NSArray<__kindof TweetEntityMedia*>*)media playable:(BOOL)playable;

- (void)prepareToPresentation;
- (void)finishPresentation;

@end
