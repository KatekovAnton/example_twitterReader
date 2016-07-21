//
//  TweetMediaView.m
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "TweetMediaView.h"
#import "UIView+Layout.h"
#import "Entities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>



typedef NS_ENUM(NSUInteger, TweetMediaInternalViewAlignment) {
    TweetMediaInternalViewAlignmentNone,
    TweetMediaInternalViewAlignmentHorizontal,
    TweetMediaInternalViewAlignmentVertical
};



@interface TweetMediaInternalViewData : NSObject

// if it is a final leaf
@property (nonatomic) TweetEntityMedia *media;

// if it is a nested container
@property (nonatomic) TweetMediaInternalViewAlignment alignment;
@property (nonatomic) NSArray* data;

@end



@implementation TweetMediaInternalViewData

- (id)initWithMedia:(NSArray<__kindof TweetEntityMedia*>*)media
  previousAlignment:(TweetMediaInternalViewAlignment)previousAlignment
{
    if (self = [super init]) {
        
        if (media.count == 1)
        {
            _alignment = TweetMediaInternalViewAlignmentNone;
            _media = [media firstObject];
        }
        else
        {
            NSArray *mediaToWorkWith = media;
            if (previousAlignment == TweetMediaInternalViewAlignmentNone &&
                media.count > 4)
                mediaToWorkWith = [media subarrayWithRange:NSMakeRange(0, 4)];
            
            if (previousAlignment == TweetMediaInternalViewAlignmentHorizontal)
                _alignment = TweetMediaInternalViewAlignmentVertical;
            else
                _alignment = TweetMediaInternalViewAlignmentHorizontal;
            
            NSArray *mediaData1 = [mediaToWorkWith subarrayWithRange:NSMakeRange(0, mediaToWorkWith.count/2)];
            NSArray *mediaData2 = [mediaToWorkWith subarrayWithRange:NSMakeRange(mediaData1.count, mediaToWorkWith.count - mediaData1.count)];
            _data = @[[[TweetMediaInternalViewData alloc] initWithMedia:mediaData1 previousAlignment:_alignment],
                      [[TweetMediaInternalViewData alloc] initWithMedia:mediaData2 previousAlignment:_alignment]];
        }
    }
    return self;
}

@end



@interface TweetMediaInternalView : UIView {
    
    UIImageView *_finalImage;
    AVPlayerViewController *_videoPlayer;
    
    
    TweetMediaInternalView *_internalView1;
    TweetMediaInternalView *_internalView2;
    
}

@property (nonatomic, readonly) TweetMediaInternalViewData* data;
@property (nonatomic, readonly) BOOL playable;

@end



@implementation TweetMediaInternalView

- (id)init
{
    if (self = [super init]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setData:(TweetMediaInternalViewData *)data playable:(BOOL)playable
{
    _data = data;
    _playable = playable;
    // todo: reuse views if possible
    
    if (_finalImage) {
        [_finalImage removeFromSuperview];
        [_finalImage sd_cancelCurrentImageLoad];
        _finalImage = nil;
    }
    
    if (_internalView1) {
        [_internalView1 removeFromSuperview];
        _internalView1 = nil;
    }
    
    if (_internalView2) {
        [_internalView2 removeFromSuperview];
        _internalView2 = nil;
    }
    
    if (_videoPlayer) {
        [[_videoPlayer player] pause];
        _videoPlayer = nil;
    }
    
    if (_data.media)
    {
        _finalImage = [[UIImageView alloc] init];
        _finalImage.contentMode = UIViewContentModeScaleAspectFill;
        _finalImage.clipsToBounds = YES;
        [self addSubview:_finalImage];
        [_finalImage autoPinEdgeToSuperviewEdges];
        [_finalImage sd_setImageWithURL:[NSURL URLWithString:_data.media.mediaUrl]];
    }
    else
    {
        _internalView1 = [[TweetMediaInternalView alloc] init];
        _internalView2 = [[TweetMediaInternalView alloc] init];
        [self addSubview:_internalView1];
        [self addSubview:_internalView2];
        
        if (data.alignment == TweetMediaInternalViewAlignmentHorizontal)
        {
            [_internalView1 autoPinEdgeToSuperviewEdge:NSLayoutAttributeLeft];
            [_internalView1 autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop];
            [_internalView1 autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom];
            
            [_internalView2 autoPinEdgeToSuperviewEdge:NSLayoutAttributeRight];
            [_internalView2 autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop];
            [_internalView2 autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom];
            
            [_internalView1 autoConstrainAttribute:NSLayoutAttributeWidth toAttribute:NSLayoutAttributeWidth ofView:_internalView2 withOffset:0 relation:NSLayoutRelationEqual];
            [_internalView1 autoPinEdge:NSLayoutAttributeRight toEdge:NSLayoutAttributeLeft ofView:_internalView2 withOffset:-3 relation:NSLayoutRelationEqual];
        }
        else
        {
            [_internalView1 autoPinEdgeToSuperviewEdge:NSLayoutAttributeLeft];
            [_internalView1 autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop];
            [_internalView1 autoPinEdgeToSuperviewEdge:NSLayoutAttributeRight];
            
            [_internalView2 autoPinEdgeToSuperviewEdge:NSLayoutAttributeRight];
            [_internalView2 autoPinEdgeToSuperviewEdge:NSLayoutAttributeLeft];
            [_internalView2 autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom];
            
            [_internalView1 autoConstrainAttribute:NSLayoutAttributeHeight toAttribute:NSLayoutAttributeHeight ofView:_internalView2 withOffset:0 relation:NSLayoutRelationEqual];
            [_internalView1 autoPinEdge:NSLayoutAttributeBottom toEdge:NSLayoutAttributeTop ofView:_internalView2 withOffset:-3 relation:NSLayoutRelationEqual];
        }
        
        [_internalView1 setData:data.data[0] playable:playable];
        [_internalView2 setData:data.data[1] playable:playable];
    }
}

- (void)prepareToPresentation
{
    if ([self.data.media.type isEqualToString:@"video"]) {// ||
//        [self.data.media.type isEqualToString:@"animated_gif"]) {
        // todo: handle gifs correctly
        
        if (!_playable)
            return;
        
        [self finishPresentation];
        
        NSArray *variants = self.data.media.videoInfo[@"variants"];
        NSString *videoUrl = nil;
        NSNumber *bitrate = nil;
        for (NSDictionary *v in variants) {
            if ([v[@"content_type"] isEqualToString:@"video/mp4"] &&
                (!bitrate || [v[@"bitrate"] intValue] < [bitrate intValue])) {
                videoUrl = v[@"url"];
            }
        }
        
        if (!videoUrl) {
            return;
        }
        
        AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
        player.volume = 1;
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        _videoPlayer = [[AVPlayerViewController alloc] init];
        _videoPlayer.player = player;
        _videoPlayer.showsPlaybackControls = NO;
        
        // this controls looks urlgly and gives
        // unsatisfied constraints errors.
        // better way is to replace with your own ui
        
        
    }
}

- (void)finishPresentation
{
    if ([self.data.media.type isEqualToString:@"video"]) {
        [_videoPlayer.player pause];
        [_videoPlayer.view removeFromSuperview];
        _videoPlayer = nil;
    }
}

- (void)startPlayback
{
    if (_videoPlayer == nil) {
        return;
    }
    
    if (_videoPlayer.isViewLoaded &&
        _videoPlayer.view.superview != nil) {
        return;
    }
    
    // todo: autoloop or smth
    
    [self addSubview:_videoPlayer.view];
    [_videoPlayer.view autoPinEdgeToSuperviewEdges];
    _videoPlayer.view.backgroundColor = [UIColor clearColor];
    [self layoutIfNeeded];
    
    [_videoPlayer.player play];
}

@end



@implementation TweetMediaView

- (void)setMedia:(NSArray<__kindof TweetEntityMedia*>*)media playable:(BOOL)playable
{
    assert(media.count > 0);
    TweetMediaInternalViewData *viewData = [[TweetMediaInternalViewData alloc] initWithMedia:media
                                                                           previousAlignment:TweetMediaInternalViewAlignmentNone];
    
    if (_internalView) {
        [_internalView removeFromSuperview];
        _internalView = nil;
    }
    
    _internalView = [[TweetMediaInternalView alloc] init];
    [self addSubview:_internalView];
    [_internalView autoPinEdgeToSuperviewEdges];
    [_internalView setData:viewData playable:playable];
    
}

- (void)prepareToPresentation
{
    [_internalView prepareToPresentation];
}

- (void)finishPresentation
{
    [_internalView finishPresentation];
}

- (void)startPlayback
{
    [_internalView startPlayback];
}

@end
