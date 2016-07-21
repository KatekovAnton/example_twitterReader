//
//  FeedFlowTableViewCell.h
//  twitterReader
//
//  Created by Katekov Anton on 04.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Tweet;
@class TweetMediaView;



@interface FeedFlowTableViewCell : UITableViewCell {
    
    IBOutlet UILabel *_labelRetweetedName;
    IBOutlet UIView *_viewRetweetedBase;
    IBOutlet NSLayoutConstraint *_constraintViewRetweetedBaseH;
    
    IBOutlet UIView *_viewTweetBase;
    IBOutlet UIImageView *_imageUserAvatar;
    IBOutlet UILabel *_labelUserName;
    IBOutlet UILabel *_labelUserScreenname;
    IBOutlet UILabel *_labelTweetText;
    
    IBOutlet UIView *_viewTweetMediaBase;
    IBOutlet NSLayoutConstraint *_constraintViewTweetMediaH;
    TweetMediaView *_viewTweetMedia;
    IBOutlet NSLayoutConstraint *_constraintViewTweetMediaBottomDistance;
    
    IBOutlet UIImageView *_imageRetweets;
    IBOutlet UILabel *_labelRetweets;
    IBOutlet UIImageView *_imageLikes;
    IBOutlet UILabel *_labelLikes;
}

@property (nonatomic) Tweet *tweet;
@property (nonatomic) CGFloat tableViewWidth;

+ (CGFloat)estimateHeightOfTweet:(Tweet*)tweet;

- (void)prepareToPresentation;
- (void)finishPresentation;
- (void)startPlayback;

@end
