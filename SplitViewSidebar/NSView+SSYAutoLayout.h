#import <Cocoa/Cocoa.h>

@interface NSView (SSYAutoLayout)

/*!
 @brief    Replaces a given subview of the receiver with another given view,
 without changing the layout of the receiver (superview)
 @details  This method is handy for replacing placeholder views with real
 views.  It will transfer both the frame and the Auto Layout constraints, so it
 works whether or not Auto Layout is in use.  It is a wrapper around
 -[NSView replaceSubview:with:].
 @param    newView  The view to replace the old view.  It is assumed that this
 view currently has no constraints.
 @param    oldView  The view to be replaced.  All we do with this is remove
 it from the superview.  We do not remove any of its constraints.  That should
 be fine if you are going to discard this view.
 */
- (void)replaceKeepingLayoutSubview:(NSView *)oldView
                               with:(NSView *)newView ;


- (void)constrainSubview:(NSView*)subview
                   inset:(CGFloat)inset ;

- (void)removeWidthConstraints ;
- (void)removeHeightConstraints ;
- (void)removeBottomConstraints ;

- (void)replaceWidthConstraintsWithWidth:(CGFloat)width ;

/*!
 @details  Handy for debugging
 */
@property (readonly) NSString* subviewsDescription ;
@property (readonly) NSString* frameString ;
@property (readonly) NSString* longDescription ;
@end
