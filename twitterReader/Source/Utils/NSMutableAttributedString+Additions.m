//
//  NSMutableAttributedString.m
//  twitterReader
//
//  Created by Katekov Anton on 10.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "NSMutableAttributedString+Additions.h"
#import "Entities.h"



@implementation TweetEntitiesAppearance

__strong TweetEntitiesAppearance *g_tweetEntitiesAppearance = nil;

+ (TweetEntitiesAppearance*)sharedAppearance
{
    if (!g_tweetEntitiesAppearance) {
        g_tweetEntitiesAppearance = [[TweetEntitiesAppearance alloc] init];
    }
    return g_tweetEntitiesAppearance;
}

@end



@implementation NSMutableAttributedString (Additions)

+ (TweetEntities*)backupForTweetEntities:(TweetEntities*)object
{
    TweetEntities *result = [[TweetEntities alloc] init];
    
    result.pk = object.pk;
    {
        NSMutableArray *copies = [NSMutableArray array];
        for (TweetEntity *entity in object.hastags)
            [copies addObject:[entity copy]];
        result.hastags = copies;
    }
    {
        NSMutableArray *copies = [NSMutableArray array];
        for (TweetEntity *entity in object.media)
            [copies addObject:[entity copy]];
        result.media = copies;
    }
    {
        NSMutableArray *copies = [NSMutableArray array];
        for (TweetEntity *entity in object.symbols)
            [copies addObject:[entity copy]];
        result.symbols = copies;
    }
    {
        NSMutableArray *copies = [NSMutableArray array];
        for (TweetEntity *entity in object.urls)
            [copies addObject:[entity copy]];
        result.urls = copies;
    }
    {
        NSMutableArray *copies = [NSMutableArray array];
        for (TweetEntity *entity in object.userMentions)
            [copies addObject:[entity copy]];
        result.userMentions = copies;
    }
    
    return result;
}

+ (void)correctEntityItems:(NSArray*)entities forCompressingRange:(NSRange)range toNewLength:(NSInteger)newLength
{
    for (TweetEntity *entity in entities) {
        if (entity.indecesFrom.integerValue > range.location) {
            entity.indecesFrom = @(entity.indecesFrom.integerValue - range.length + newLength);
            entity.indecesTo = @(entity.indecesTo.integerValue - range.length + newLength);
        }
    }
}

+ (void)shiftEntityItems:(NSArray*)entities withOffset:(NSUInteger)offset fromIndex:(NSUInteger)index
{
    for (TweetEntity *entity in entities) {
        if (entity.indecesFrom.integerValue > index) {
            entity.indecesFrom = @(entity.indecesFrom.integerValue + offset);
            entity.indecesTo = @(entity.indecesTo.integerValue + offset);
        }
        else if (entity.indecesTo.integerValue > index) {
            entity.indecesTo = @(entity.indecesTo.integerValue + offset);
        }
    }
}

+ (void)highlightEntities:(NSArray*)entities inAttributedString:(NSMutableAttributedString*)string withColor:(UIColor*)color
{
    for (TweetEntity *entity in entities)
    {
        [string addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:[entity rangeInText]];
    }
}

+ (instancetype)attributedStringWithString:(NSString *)str entities:(TweetEntities*)entities
{
    TweetEntities *workingEntities = [self backupForTweetEntities:entities];

    // replace encapsulated characters
    // todo: find better way
    NSMutableArray *stringsToBeReplaced = [NSMutableArray arrayWithObjects:@"&amp;", @"&gt;", @"&lt;", nil];
    NSMutableArray *stringsForReplacement = [NSMutableArray arrayWithObjects:@"&", @">", @"<", nil];
    
    // remove all media links from text
    for (TweetEntityMedia *media in workingEntities.media)
    {
        NSRange range = [media rangeInText];
        [self correctEntityItems:workingEntities.hastags forCompressingRange:range toNewLength:0];
        [self correctEntityItems:workingEntities.symbols forCompressingRange:range toNewLength:0];
        [self correctEntityItems:workingEntities.urls forCompressingRange:range toNewLength:0];
        [self correctEntityItems:workingEntities.userMentions forCompressingRange:range toNewLength:0];
        str = [str stringByReplacingCharactersInRange:range withString:@""];
    }
    
    // some troubles with emojis, I would preffer to use
    // https://github.com/woxtu/NSString-RemoveEmoji/
    for (NSUInteger index = 0; index < str.length; index++)
    {
        if ([str characterAtIndex:index] == 55357) {
            [self shiftEntityItems:workingEntities.hastags withOffset:1 fromIndex:index];
            [self shiftEntityItems:workingEntities.urls withOffset:1 fromIndex:index];
            [self shiftEntityItems:workingEntities.userMentions withOffset:1 fromIndex:index];
        }
    }
    
    
    for (int i = 0; i < stringsToBeReplaced.count; i++)
    {
        NSString *stringToBeReplaced = stringsToBeReplaced[i];
        NSString *stringForReplacement = stringsForReplacement[i];
        NSInteger newLength = stringForReplacement.length;
        
        NSRange range = [str rangeOfString:stringToBeReplaced];
        while (range.length > 0) {
            
            [self correctEntityItems:workingEntities.hastags forCompressingRange:range toNewLength:newLength];
            [self correctEntityItems:workingEntities.symbols forCompressingRange:range toNewLength:newLength];
            [self correctEntityItems:workingEntities.urls forCompressingRange:range toNewLength:newLength];
            [self correctEntityItems:workingEntities.userMentions forCompressingRange:range toNewLength:newLength];
            
            str = [str stringByReplacingCharactersInRange:range withString:stringForReplacement];
            range = [str rangeOfString:stringToBeReplaced];
        }
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:str];
    [result beginEditing];
    [self highlightEntities:workingEntities.hastags inAttributedString:result withColor:[TweetEntitiesAppearance sharedAppearance].colorForHastags];
    [self highlightEntities:workingEntities.symbols inAttributedString:result withColor:[TweetEntitiesAppearance sharedAppearance].colorForHastags];
    [self highlightEntities:workingEntities.urls inAttributedString:result withColor:[TweetEntitiesAppearance sharedAppearance].colorForHastags];
    [self highlightEntities:workingEntities.userMentions inAttributedString:result withColor:[TweetEntitiesAppearance sharedAppearance].colorForHastags];
    
    // todo: replace twitter t.co links with url.displayUrl
    // trouble in re-calculating indices of entities
//    for (TweetEntityUrl *url in workingEntities.urls)
//    {
//        NSRange range = [url rangeInText];
//        [result replaceCharactersInRange:range withString:url.displayUrl];//stringByReplacingCharactersInRange:range withString:url.displayUrl];
//    }
    [result endEditing];
    
    return result;
}

@end



@implementation NSAttributedString (Additions)

- (CGFloat)sizeWithFont:(UIFont*)font constraintWithWidth:(CGFloat)width
{
    NSMutableAttributedString *attributedText = [self mutableCopy];
    [attributedText addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, self.length)];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               context:nil];
    return rect.size.height + 2;
}

@end
