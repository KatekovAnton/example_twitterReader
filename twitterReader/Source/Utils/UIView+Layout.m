//
//  UIView.m
//  twitterReader
//
//  Stolen from PureLayout. doesnt contains any hard logic
//

#import "UIView+Layout.h"



@implementation UIView (Layout)

- (NSArray *)autoPinEdgeToSuperviewEdges
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:NSLayoutAttributeLeft]];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:NSLayoutAttributeRight]];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop]];
    [constraints addObject:[self autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom]];
    return constraints;
}

- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(NSLayoutAttribute)edge
{
    return [self autoPinEdgeToSuperviewEdge:edge withInset:0.0];
}

- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(NSLayoutAttribute)edge withInset:(CGFloat)inset
{
    return [self autoPinEdgeToSuperviewEdge:edge withInset:inset relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(NSLayoutAttribute)edge withInset:(CGFloat)inset relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *superview = self.superview;
    
    if (edge == NSLayoutAttributeBottom || edge == NSLayoutAttributeRight || edge == NSLayoutAttributeTrailing)
    {
        inset = -inset;
        if (relation == NSLayoutRelationLessThanOrEqual) {
            relation = NSLayoutRelationGreaterThanOrEqual;
        }
        else if (relation == NSLayoutRelationGreaterThanOrEqual) {
            relation = NSLayoutRelationLessThanOrEqual;
        }
    }
    return [self autoPinEdge:edge toEdge:edge ofView:superview withOffset:inset relation:relation];
}

- (NSLayoutConstraint *)autoPinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    return [self autoConstrainAttribute:edge toAttribute:toEdge ofView:otherView withOffset:offset relation:relation];
}

- (NSLayoutConstraint *)autoConstrainAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:relation toItem:otherView attribute:toAttribute multiplier:1.0 constant:offset];
    constraint.active = YES;
    return constraint;
}

- (NSArray *)autoSetDimensionsToSize:(CGSize)size
{
    NSMutableArray *constraints = [NSMutableArray new];
    [constraints addObject:[self autoSetDimension:NSLayoutAttributeWidth toSize:size.width]];
    [constraints addObject:[self autoSetDimension:NSLayoutAttributeHeight toSize:size.height]];
    return constraints;
}

- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size
{
    return [self autoSetDimension:dimension toSize:size relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutAttribute layoutAttribute = dimension;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:layoutAttribute relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:size];
    constraint.active = YES;
    return constraint;
}


@end
