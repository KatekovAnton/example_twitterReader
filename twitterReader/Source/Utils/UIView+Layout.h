//
//  UIView.h
//  twitterReader
//
//  Stolen from PureLayout. doesnt contains any hard logic
//

#import <UIKit/UIKit.h>



@interface UIView (Layout)

- (NSArray *)autoPinEdgeToSuperviewEdges;
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(NSLayoutAttribute)edge;
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(NSLayoutAttribute)edge withInset:(CGFloat)inset;
- (NSLayoutConstraint *)autoPinEdgeToSuperviewEdge:(NSLayoutAttribute)edge withInset:(CGFloat)inset relation:(NSLayoutRelation)relation;

- (NSLayoutConstraint *)autoPinEdge:(NSLayoutAttribute)edge toEdge:(NSLayoutAttribute)toEdge ofView:(UIView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)autoConstrainAttribute:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView withOffset:(CGFloat)offset relation:(NSLayoutRelation)relation;

- (NSArray *)autoSetDimensionsToSize:(CGSize)size;
- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size;
- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size relation:(NSLayoutRelation)relation;

@end
