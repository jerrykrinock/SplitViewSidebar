#import "FixedSidebarSplitViewController.h"
#import "NSView+SSYAutoLayout.h"

@implementation FixedSidebarSplitViewController


/* This is implmented by superclass but not as an IBOutlet, so we need this to
 avoid compiler warning. */
@dynamic splitView ;

/* Because NSSplitViewItem is not available in Interface Builder without using
 Storyboards, we must add our split view items in code, here. */
- (void)viewDidLoad {
    NSSplitViewItem* sidebarItem = [[NSSplitViewItem alloc] init] ;
    sidebarItem.viewController = self.sidebarViewController ;  // See Note 1
    [self insertSplitViewItem:sidebarItem
                      atIndex:0] ;
    
    NSSplitViewItem* bodyItem = [[NSSplitViewItem alloc] init] ;
    bodyItem.viewController = self.bodyViewController ;
    [self insertSplitViewItem:bodyItem
                      atIndex:1] ;  // See Note 1.
    
    [super viewDidLoad] ;
}

- (void)setFixedWidth:(CGFloat)width {
    /* Apparently, NSSplitView uses Auto Layout to set minimum and maximum
     thickness, because without the following line, we get "can't
     simulatenously satisfy constraints exceptions from Auto Layout in the
     sequel.  It is not only because of our initial setting in Interface
     Builder.  For example, if you remove the following line, build, run and
     change the Fixed Width field in the user interface from -1 to 200 you
     get an Auto Layout exception as expected.  But then if you change it from
     200 to 300 you also get an Auto Layout exception.  Seems like this is 
     a bug, that maybe Apple should have built -removeWidthConstraints into
     -setMinimumThickness: and setMaximumThickness:.  NSSplitViewItem would
     need access to its view in order to do that and, it looks like it does
     not have that. */
    [self.sidebarView removeWidthConstraints] ;
    
    [[self.splitViewItems firstObject] setMinimumThickness:width] ;
    [[self.splitViewItems firstObject] setMaximumThickness:width] ;
}

- (CGFloat)fixedWidth {
    return [self.splitViewItems firstObject].minimumThickness ;
    /* Should get same answer with maximum thickness, unless fixedWidth has
     never been set, then you'll get NSSplitViewItemUnspecifiedDimension,
     which is apparently -1.0 */
}

/* Needed so that the initial value, NSSplitViewItemUnspecifiedDimension = -1,
 is displayed in the user interface when the app launches, because the
 splitViewItems does not get populated until after Cocoa Bindings does its
 initial 'get'. */
+ (NSSet*)keyPathsForValuesAffectingFixedWidth {
    return [NSSet setWithObjects:
            @"splitViewItems",
            nil] ;
}

- (IBAction)expandSidebar:(id)sender {
    [[[[self splitViewItems] firstObject] animator] setCollapsed:NO];
}

- (IBAction)collapseSidebar:(id)sender {
    [[[[self splitViewItems] firstObject] animator] setCollapsed:YES];
}

/* 
 
 Note 1:   This line will raise an exception in OS X 10.10 due to a bug
 in OS X 10.10.  See ReadMe.md for workaround.

 Note 2: I spent several hours trying to get the desired expanding and
 collapsingwhen user dragged the divider with the mouse, by overriding
 -splitView:constrainSplitPosition:ofSubviewAt:,
 and also an Apple engineer gave it a try.  Result: All unsuccessful.
 Conclusion: That method is either broken or has no discernable purpose.  The
 only way I could make this work as desired was by overriding the mouse event
 methods as you can see in FixedSidebarSplitView.m.
 
 */


@end
