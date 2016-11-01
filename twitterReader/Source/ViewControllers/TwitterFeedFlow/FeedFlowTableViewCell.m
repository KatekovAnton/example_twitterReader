//
//  FeedFlowTableViewCell.m
//  twitterReader
//
//  Created by Katekov Anton on 04.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "FeedFlowTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Additions.h"
#import "UIView+Layout.h"
#import "Entities.h"

#import "TweetMediaView.h"
#import "TweetDataCache.h"



@implementation FeedFlowTableViewCell

+ (CGFloat)estimateHeightOfTweet:(Tweet *)tweet
{
    if (tweet.entities.media.count > 0) {
        return 150;
    }
    return 100;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor colorFromHex:0xaab8c2];
    [self addSubview:separator];
    [separator autoSetDimension:NSLayoutAttributeHeight toSize:0.5];
    [separator autoPinEdgeToSuperviewEdge:(NSLayoutAttributeLeading)];
    [separator autoPinEdgeToSuperviewEdge:(NSLayoutAttributeTrailing)];
    [separator autoPinEdgeToSuperviewEdge:(NSLayoutAttributeBottom)];
    
    _imageUserAvatar.layer.cornerRadius = 4;
    _labelUserName.textColor = [UIColor colorFromHex:0x292f33];
    _labelUserScreenname.textColor = [UIColor colorFromHex:0x8899a6];
    _labelTweetText.textColor = [UIColor colorFromHex:0x292f33];
    
    _viewTweetMediaBase.layer.cornerRadius = 4;
}

- (void)setTableViewWidth:(CGFloat)tableViewWidth
{
    _tableViewWidth = tableViewWidth;
    _labelTweetText.preferredMaxLayoutWidth = _tableViewWidth - 59 - 8;
    
    self.bounds = CGRectMake(0, 0, _tableViewWidth, 999);
    self.contentView.bounds = self.bounds;
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    if (!_tweet)
        return;
    
    Tweet *tweetBody = tweet;
    
    // header
    {
        if (_tweet.retweetedStatus)
        {
            _constraintViewRetweetedBaseH.constant = 20;
            _labelRetweetedName.text = [NSString stringWithFormat:@"%@ Retweeted", _tweet.user.name];
            tweetBody = _tweet.retweetedStatus;
        }
        else
            _constraintViewRetweetedBaseH.constant = 0;
    }
    
    // body
    {
        [_imageUserAvatar sd_setImageWithURL:[NSURL URLWithString:tweetBody.user.profileImageUrl]];
        _labelUserName.text = tweetBody.user.name;
        _labelUserScreenname.text = [NSString stringWithFormat:@"@%@", tweetBody.user.screenName];
        
        _labelTweetText.attributedText = [[TweetDataCache instance] formattedStringForTweet:tweetBody];
    }
    
    // media
    {
        
        if (tweetBody.extendedEntities.media.count > 0)
        {
            _constraintViewTweetMediaH.constant = 150;
            _constraintViewTweetMediaBottomDistance.constant = 4;
            if (!_viewTweetMedia) {
                _viewTweetMedia = [[TweetMediaView alloc] init];
                [_viewTweetMediaBase addSubview:_viewTweetMedia];
                [_viewTweetMedia autoPinEdgeToSuperviewEdges];
            }
            [_viewTweetMedia setMedia:tweetBody.extendedEntities.media playable:YES];
        }
        else
        {
            [_viewTweetMedia removeFromSuperview];
            _viewTweetMedia = nil;
            
            _constraintViewTweetMediaH.constant = 0;
            _constraintViewTweetMediaBottomDistance.constant = 0;
        }
    }
    
    // footer: retweets/likes
    {
        // todo: human readable large values
        _labelLikes.text = tweetBody.favoriteCount.description;
        if (tweetBody.favorited.boolValue)
        {
            _imageLikes.image =  [TweetDataCache imageLiked];
            _labelLikes.textColor = [UIColor colorFromHex:0xFF6A5F];
        }
        else
        {
            _imageLikes.image = [UIImage imageNamed:@"icon_liked"];
            _labelLikes.textColor = [UIColor colorFromHex:0xaab8c2];
        }
        
        // todo: human readable large values
        _labelRetweets.text = tweetBody.retweetCount.description;
        if (tweetBody.retweeted.boolValue)
        {
            _imageRetweets.image =  [TweetDataCache imageRetweeted];
            _labelRetweets.textColor = [UIColor colorFromHex:0xFF6A5F];
        }
        else
        {
            _imageRetweets.image = [UIImage imageNamed:@"icon_retweeted"];
            _labelRetweets.textColor = [UIColor colorFromHex:0xaab8c2];
        }
    }
}

- (void)prepareToPresentation
{
    [_viewTweetMedia prepareToPresentation];
}

- (void)finishPresentation
{
    [_viewTweetMedia finishPresentation];
}

- (void)startPlayback
{
    [_viewTweetMedia startPlayback];
}

@end
