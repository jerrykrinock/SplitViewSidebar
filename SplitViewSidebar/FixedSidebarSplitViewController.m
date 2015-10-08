#import "FixedSidebarSplitViewController.h"

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

- (IBAction)expandSidebar:(id)sender {
    [[[[self splitViewItems] firstObject] animator] setCollapsed:NO];
    [self.splitView adjustSubviews] ;
}

- (IBAction)collapseSidebar:(id)sender {
    [[[[self splitViewItems] firstObject] animator] setCollapsed:YES];
    [self.splitView adjustSubviews] ;
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
