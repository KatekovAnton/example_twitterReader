//
//  UIColor.h
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIColor (Additions)

+ (UIColor *)colorFromHex:(NSUInteger)hex alpha:(CGFloat)alphaInPercentage;
+ (UIColor *)colorFromHex:(NSUInteger)hexademical;

@end
