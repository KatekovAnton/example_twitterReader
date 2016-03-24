//
//  NSMutableAttributedString.h
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TweetEntities;



@interface TweetEntitiesAppearance : NSObject

@property (nonatomic) UIColor *colorForHastags;

+ (TweetEntitiesAppearance*)sharedAppearance;

@end



@interface NSMutableAttributedString (Additions)

+ (instancetype)attributedStringWithString:(NSString *)str entities:(TweetEntities*)entities;

@end

@interface NSAttributedString (Additions)

- (CGFloat)sizeWithFont:(UIFont*)font constraintWithWidth:(CGFloat)width;

@end
