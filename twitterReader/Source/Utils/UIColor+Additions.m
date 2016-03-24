//
//  UIColor.m
//  twitterReader
//
//  Created by Katekov Anton on 09.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "UIColor+Additions.h"



@implementation UIColor (Additions)

+ (UIColor *)colorFromHex:(NSUInteger)hex alpha:(CGFloat)alphaInPercentage {
    
    CGFloat componets[] = {
        ((float)((hex & 0xFF0000) >> 16))/255.0,
        ((float)((hex & 0xFF00) >> 8))/255.0,
        ((float)((hex & 0xFF) >> 0))/255.0
    };

    return [UIColor colorWithRed:componets[0] green:componets[1] blue:componets[2] alpha:alphaInPercentage/100.0];
}

+ (UIColor *)colorFromHex:(NSUInteger)hexademical {
    return [UIColor colorFromHex:hexademical alpha:100];
}


@end
