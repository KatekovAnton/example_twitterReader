//
//  FeedGridCollectionViewCell.m
//  twitterReader
//
//  Created by Katekov Anton on 04.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "FeedGridCollectionViewCell.h"
#import "UIColor+Additions.h"
#import "UIView+Layout.h"
#import "Entities.h"

#import "TweetMediaView.h"
#import "TweetDataCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSMutableAttributedString+Additions.h"
#import "UIFont+Additions.h"



@implementation FeedGridCollectionViewCell

- (void)awakeFromNib {
    self.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.6 alpha:0.3].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imageUserAvatar.layer.cornerRadius = 2;
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

+ (CGFloat)heightForTweet:(Tweet*)tweet forWidth:(CGFloat)width
{
    CGFloat result = 0;
    Tweet *tweetBody = tweet;
    
    // header
    {
        if (tweet.retweetedStatus)
        {
            result += 20;
            tweetBody = tweet.retweetedStatus;
        }
    }
    
    // body
    {
        CGFloat height = 19 + [[[TweetDataCache instance] formattedStringForTweet:tweetBody] sizeWithFont:[UIFont helveticaNeueRegularFontOfSize:14] constraintWithWidth:width - 10] + 5;
        result += height;
    }
    
    // media
    {
        if (tweetBody.extendedEntities.media.count > 0)
        {
            result += 154;
        }
    }
    
    // footer: retweets/likes
    {
        result += 24;
    }
    return result;
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
            [_viewTweetMedia setMedia:tweetBody.extendedEntities.media playable:NO];
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

@end
