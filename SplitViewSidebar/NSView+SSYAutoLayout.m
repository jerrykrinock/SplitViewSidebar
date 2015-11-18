#import "NSView+SSYAutoLayout.h"

@implementation NSView (SSYAutoLayout)

- (void)replaceKeepingLayoutSubview:(NSView *)oldView
                               with:(NSView *)newView {

    /* Remember Auto Layout constraints.  There are two objects which may be
     "holding" relevant constraints.  First, the superview of the old view may
     hold constraints that refer to old view.  We call these "relevant superview
     constraints".  Second, the old view can hold constraints upon itself.
     We call these the "self constraints".  The following code collects each
     in turn. */
    
    NSMutableArray* oldRelevantSuperviewConstraints = [NSMutableArray new] ;
    NSMutableArray* newRelevantSuperviewConstraints = [NSMutableArray new] ;
    for (NSLayoutConstraint* constraint in self.constraints) {
        BOOL isRelevant = NO ;
        NSView* new1stItem ;
        NSView* new2ndItem ;
        if (constraint.firstItem == oldView) {
            isRelevant = YES ;
            new1stItem = newView ;
        }
        if (constraint.secondItem == oldView) {
            isRelevant = YES ;
            new2ndItem = newView ;
        }
        
        if (isRelevant) {
            NSLayoutConstraint* newConstraint = [NSLayoutConstraint constraintWithItem:(new1stItem ? new1stItem : constraint.firstItem)
                                                                             attribute:constraint.firstAttribute
                                                                             relatedBy:constraint.relation
                                                                                toItem:(new2ndItem ? new2ndItem : constraint.secondItem)
                                                                             attribute:constraint.secondAttribute
                                                                            multiplier:constraint.multiplier
                                                                              constant:constraint.constant] ;
            newConstraint.shouldBeArchived = constraint.shouldBeArchived ;
            newConstraint.priority = constraint.priority ;
            
            [oldRelevantSuperviewConstraints addObject:constraint] ;
            [newRelevantSuperviewConstraints addObject:newConstraint] ;
        }
    }
    
    
    NSMutableArray* newSelfConstraints = [NSMutableArray new] ;
    for (NSLayoutConstraint* constraint in oldView.constraints) {
        // WARNING: do not tamper with intrinsic layout constraints
        if ([constraint class] == [NSLayoutConstraint class] && constraint.firstItem == oldView) {
            NSView* new1stItem ;
            NSView* new2ndItem ;
            if (constraint.firstItem == oldView) {
                new1stItem = newView ;
            }
            if (constraint.secondItem == oldView) {
                new2ndItem = newView ;
            }
            NSLayoutConstraint* newConstraint = [NSLayoutConstraint constraintWithItem:(new1stItem ? new1stItem : constraint.firstItem)
                                                                             attribute:constraint.firstAttribute
                                                                             relatedBy:constraint.relation
                                                                                toItem:(new2ndItem ? new2ndItem : constraint.secondItem)
                                                                             attribute:constraint.secondAttribute
                                                                            multiplier:constraint.multiplier
                                                                              constant:constraint.constant] ;
            newConstraint.shouldBeArchived = constraint.shouldBeArchived ;
            newConstraint.priority = constraint.priority ;

            [newSelfConstraints addObject:newConstraint] ;
        }
    }
    
    /* Remember the old frame, in case Auto Layout is not being used. */
    NSRect frame = oldView.frame ;
    
    /* Do the replacement. */
    [self replaceSubview:oldView
                    with:newView] ;
    
    /* Fix up frame and constraints. */
    newView.frame = frame ;
    [newView addConstraints:newSelfConstraints] ;
    [self removeConstraints:oldRelevantSuperviewConstraints] ;
    [self addConstraints:newRelevantSuperviewConstraints] ;
}

- (void)constrainSubview:(NSView*)subview
                   inset:(CGFloat)inset {
    // To avoid exception crap from Auto Layout:
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO] ;

    NSLayoutConstraint* constraint ;
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0
                                               constant:inset] ;
    [self addConstraint:constraint] ;
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0
                                               constant:inset] ;
    [self addConstraint:constraint] ;
    
    /* Measuring *from* a subview *to* its superview (me), the insets must be
     negated to get the intended result. */
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0
                                               constant:-inset] ;
    [self addConstraint:constraint] ;
    constraint = [NSLayoutConstraint constraintWithItem:subview
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:-inset] ;
    [self addConstraint:constraint] ;
}

- (void)removeWidthConstraints {
    NSMutableArray* widthConstraints = [[NSMutableArray alloc] init] ;
    NSArray* constraints ;
    
    // See Note 1 below
    
    constraints = [self constraints] ;
    for (NSLayoutConstraint* constraint in constraints) {
        if (constraint.firstItem == self) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                [widthConstraints addObject:constraint] ;
            }
        }
    }
    
    constraints = [self.superview constraints] ;
    for (NSLayoutConstraint* constraint in constraints) {
        if (constraint.firstItem == self) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                [widthConstraints addObject:constraint] ;
            }
        }
    }
    
    [NSLayoutConstraint deactivateConstraints:widthConstraints] ;
}

- (void)removeHeightConstraints {
    NSMutableArray* heightConstraints = [[NSMutableArray alloc] init] ;
    NSArray* constraints ;
    
    // See Note 1 below
    
    constraints = [self constraints] ;
    for (NSLayoutConstraint* constraint in constraints) {
        if (constraint.firstItem == self) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                [heightConstraints addObject:constraint] ;
            }
        }
    }
    
    constraints = [self.superview constraints] ;
    for (NSLayoutConstraint* constraint in constraints) {
        if (constraint.firstItem == self) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                [heightConstraints addObject:constraint] ;
            }
        }
    }
    
    [NSLayoutConstraint deactivateConstraints:heightConstraints] ;
}

- (void)removeBottomConstraints {
    NSMutableArray* bottomConstraints = [[NSMutableArray alloc] init] ;
    NSArray* constraints ;
    
    // See Note 1 below
    
    constraints = [self constraints] ;
    for (NSLayoutConstraint* constraint in constraints) {
        if ((constraint.secondItem == self) || (constraint.firstItem == self)) {
            if (constraint.firstAttribute == NSLayoutAttributeBottom) {
                if (constraint.secondAttribute == NSLayoutAttributeBottom) {
                    [bottomConstraints addObject:constraint] ;
                }
            }
        }
    }

    constraints = [self.superview constraints] ;
    for (NSLayoutConstraint* constraint in constraints) {
        if ((constraint.secondItem == self) || (constraint.firstItem == self)) {
            if (constraint.firstAttribute == NSLayoutAttributeBottom) {
                if (constraint.secondAttribute == NSLayoutAttributeBottom) {
                    [bottomConstraints addObject:constraint] ;
                }
            }
        }
    }
    
    [NSLayoutConstraint deactivateConstraints:bottomConstraints] ;
}

- (void)replaceWidthConstraintsWithWidth:(CGFloat)width {
    [self removeWidthConstraints] ;
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:0.0
                                                                   constant:width] ;
    /* Priority must be less than NSLayoutPriorityWindowSizeStayPut (which is
     500.0); otherwise the window will grow bigger when areas overflow, and also
     vertical resizing of the window by the user will be disabled. */
    constraint.priority = NSLayoutPriorityWindowSizeStayPut - 1.0 ;
    [self addConstraint:constraint] ;
}

- (NSString*)subviewsDescription {
    NSMutableString* s = [NSMutableString new] ;
    for (NSView* subview in self.subviews) {
        [s appendFormat:@"\n%@ with frame=%@ itc=%@", subview, NSStringFromRect(subview.frame), NSStringFromSize(subview.intrinsicContentSize)] ;
    }
    [s appendString:@"\n"] ;
    return [s copy] ;
}

- (NSString*)frameString {
    return NSStringFromRect(self.frame) ;
}

- (NSString*)longDescription {
    return [[NSString alloc] initWithFormat:
            @"%@ %@",
            [self description],
            self.frameString] ;
}

@end

/* Note 1
 
 From -[NSView addConstraint:] documentation:
 
 “The constraint must involve only views that are within scope of the receiving view. Specifically, any views involved must be either the receiving view itself, or a subview of the receiving view. Constraints that are added to a view are said to be held by that view…”
 
 The fact that constraints may be “held” by either of *two* views makes it a little ambiguous to replace constraints, which is necessary to rearrange views while running.  Prior to adding new constraints, you need to remove conflicting old constraints.  To find them, you need to consider the -constraints of *two* views.  
 */
