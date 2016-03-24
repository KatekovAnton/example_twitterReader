//
//  FeedGridCollectionViewLayout.m
//  twitterReader
//
//  Created by Katekov Anton on 11.01.16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "FeedGridCollectionViewLayout.h"



@interface FeedGridLayoutAttributes:UICollectionViewLayoutAttributes {
    
}

@end



@implementation FeedGridLayoutAttributes

@end



@interface FeedGridCollectionViewLayout () {
    
    NSMutableArray <__kindof FeedGridLayoutAttributes*> *_cache;
    NSMutableArray <__kindof NSNumber*> *_yOffsets;
    CGFloat _resultContentHeight;
    CGFloat _cellWidth;
}

@end



@implementation FeedGridCollectionViewLayout

+ (Class)layoutAttributesClass
{
    return [FeedGridLayoutAttributes class];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> * layoutAttributes = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attributes  in _cache)
    {
        if (CGRectIntersectsRect(attributes.frame, rect))
            [layoutAttributes addObject:attributes];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedGridLayoutAttributes *cachedLayoutAttributes = [self cachedLayoutAttributesForItemAtIndexPath:indexPath];
    if (cachedLayoutAttributes)
        return cachedLayoutAttributes;
    
    [self calculateLayoutParametersForItemAtIdexPath:indexPath];
    
    return [self cachedLayoutAttributesForItemAtIndexPath:indexPath];
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    FeedGridLayoutAttributes *result = (FeedGridLayoutAttributes *)[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    result.center = CGPointMake(result.center.x, result.center.y - 300);
    return result;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, _resultContentHeight);
}

- (void)prepareLayout
{
    for (NSUInteger item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:0];
        [self calculateLayoutParametersForItemAtIdexPath:indexPath];
    }
}

#pragma mark - custom layout

- (FeedGridLayoutAttributes*)cachedLayoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
    for (FeedGridLayoutAttributes *attributes  in _cache)
    {
        if ([attributes.indexPath isEqual:indexPath])
            return attributes;
    }
    return nil;
}

- (CGFloat)xOffsetForColumn:(NSUInteger)column
{
    return _cellPadding * (column + 1) + _cellWidth * column;
}

- (void)calculateLayoutParametersAtStart
{
    _resultContentHeight = 0;
    _cellWidth = (self.collectionView.bounds.size.width - _cellPadding * (_numberOfColumns + 1))/_numberOfColumns;
    _yOffsets = [NSMutableArray array];
    for (int i = 0; i < _numberOfColumns; i++) {
        [_yOffsets addObject:@(_cellPadding)];
    }
}

- (NSUInteger)minimumHeightColumn
{
    CGFloat minimumHeight = 10000;
    NSUInteger minimumHeightColumn = 0;
    for (NSUInteger i = 0; i < _yOffsets.count; i++)
    {
        if ([_yOffsets[i] floatValue] < minimumHeight) {
            minimumHeight = [_yOffsets[i] floatValue];
            minimumHeightColumn = i;
        }
    }
    return minimumHeightColumn;
}

- (void)increaseColumn:(NSUInteger)column byCellHeight:(CGFloat)cellHeight
{
    CGFloat newYOffset = [_yOffsets[column] floatValue] + cellHeight + _cellPadding;
    [_yOffsets replaceObjectAtIndex:column withObject:@(newYOffset)];
    
    _resultContentHeight = MAX(_resultContentHeight, newYOffset);
}

- (void)calculateLayoutParametersForItemAtIdexPath:(NSIndexPath*)indexPath
{
    if (!_cache)
    {
        _cache = [NSMutableArray array];
        [self calculateLayoutParametersAtStart];
    }
    
    CGFloat height = 40;
    if (self.delegate)
        height = [self.delegate feedGridCollectionViewLayout:self sizeForItem:indexPath forWidth:_cellWidth];
    
    NSUInteger column = [self minimumHeightColumn];
    CGRect frame = CGRectMake([self xOffsetForColumn:column], [_yOffsets[column] floatValue], _cellWidth, height);
    
    FeedGridLayoutAttributes *attributes = [FeedGridLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    [_cache addObject:attributes];
    
    [self increaseColumn:column byCellHeight:height];
}

@end
