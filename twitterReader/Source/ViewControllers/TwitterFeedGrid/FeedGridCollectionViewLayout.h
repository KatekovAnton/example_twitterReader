//
//  FeedGridCollectionViewLayout.h
//  twitterReader
//
//  Created by Katekov Anton on 11.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class FeedGridCollectionViewLayout;



@protocol FeedGridCollectionViewLayoutDelegate <NSObject>

- (CGFloat)feedGridCollectionViewLayout:(FeedGridCollectionViewLayout*)collectionViewLayout sizeForItem:(NSIndexPath*)item forWidth:(CGFloat)width;

@end



@interface FeedGridCollectionViewLayout : UICollectionViewLayout {
    
}

@property (nonatomic, weak) id<FeedGridCollectionViewLayoutDelegate> delegate;
@property (nonatomic) NSUInteger numberOfColumns;
@property (nonatomic) CGFloat cellPadding;

@end
