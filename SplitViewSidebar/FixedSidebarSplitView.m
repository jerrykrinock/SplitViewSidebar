#import "FixedSidebarSplitView.h"
#import "FixedSidebarSplitViewController.h"

@interface FixedSidebarSplitView ()

@property BOOL userIsDraggingDivider ;
@property CGFloat dividerDragX ;

@end

@implementation FixedSidebarSplitView

- (void)mouseDown:(NSEvent*)event {
    CGFloat x = [self convertPoint:[event locationInWindow] fromView:nil].x ;
    NSRect sidebarFrame = [self.arrangedSubviews objectAtIndex:0].frame ;
    NSRect bodyFrame = [self.arrangedSubviews objectAtIndex:1].frame ;
    /* When the sidebar is collapsed, the frame of the body view changes
     accordingly.  However, the frame of the sidebar view never changes; it
     is always as though it is expanded.  This may be because of its width
     constraint in Interface Builder?  Anyhow, the following asymmetric code
     is necessary to accomodate this fact when computing the right and
     left edge of the divider. */
    CGFloat sidebarRightEdge = sidebarFrame.origin.x + sidebarFrame.size.width ;
    CGFloat dividerRightEdge = bodyFrame.origin.x ;
    CGFloat dividerLeftEdge ;
    /* Alternatively, the following line could be:
     if ([self.splitViewController.splitViewItems objectAtIndex:0].collapsed) {
     although this has not been tested. */
    if (dividerRightEdge < sidebarRightEdge) {
        // Sidebar is collapsed.
        dividerLeftEdge = 0.0 ;
    }
    else {
        // Sidebar is expanded.
        dividerLeftEdge = sidebarRightEdge ;
    }

    if ((x > dividerLeftEdge) && (x < dividerRightEdge)) {
        self.userIsDraggingDivider = YES ;
        self.dividerDragX = 0.0 ;
    }
    else {
        [super mouseDown:event] ;
    }
}

#define STICKY_WIDTH 10.0

- (void)mouseDragged:(NSEvent*)event {
    if (self.userIsDraggingDivider) {
        CGFloat deltaX = event.deltaX ;
        self.dividerDragX += deltaX ;
        if (self.dividerDragX > STICKY_WIDTH) {
            [self.splitViewController expandSidebar:self] ;
        }
        else if (self.dividerDragX < -STICKY_WIDTH) {
            [self.splitViewController collapseSidebar:self] ;
        }
    }
}

- (void)mouseUp:(NSEvent*)event {
    self.userIsDraggingDivider = NO ;
}


@end
