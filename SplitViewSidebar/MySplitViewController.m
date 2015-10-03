#import "MySplitViewController.h"

@implementation MySplitViewController

/* This is implmented by superclass but not as an IBOutlet, so we need this to
 avoid compiler warning. */
@dynamic splitView ;

/* Because NSSplitViewItem is not available in Interface Builder without usinig
 Storyboards, we must add our split view items in code, here. */
- (void)viewDidLoad {
    NSSplitViewItem* sidebarItem = [[NSSplitViewItem alloc] init] ;
    sidebarItem.viewController = self.sidebarViewController ;
    [self insertSplitViewItem:sidebarItem
                      atIndex:0] ;
    
    NSSplitViewItem* bodyItem = [[NSSplitViewItem alloc] init] ;
    bodyItem.viewController = self.bodyViewController ;
    [self insertSplitViewItem:bodyItem
                      atIndex:1] ;
    
    [super viewDidLoad] ;
}

- (void)expandSidebar:(id)sender {
    [[[[self splitViewItems] firstObject] animator] setCollapsed:NO];
    [self.splitView adjustSubviews] ;
}

- (IBAction)collapseSidebar:(id)sender {
    [[[[self splitViewItems] firstObject] animator] setCollapsed:YES];
    [self.splitView adjustSubviews] ;
}

#define SIDEBAR_WIDTH 158.0

- (CGFloat)     splitView:(NSSplitView*)splitView
   constrainSplitPosition:(CGFloat)proposedPosition
              ofSubviewAt:(NSInteger)dividerIndex {
    CGFloat answer = proposedPosition ;
    if (splitView == self.splitView) {
        if (dividerIndex == 0) {
            /*SSYDBL*/ NSLog(@"Proposed=%f  SidebarColl=%hhd  BodyColl=%hhd", proposedPosition, [self.splitView isSubviewCollapsed:self.sidebarView], [self.splitView isSubviewCollapsed:self.bodyView]) ;

            if (proposedPosition < SIDEBAR_WIDTH / 2.0) {
                [self collapseSidebar:self] ;
                // answer = 0.0 ; // Statement has no effect
            }
            else {
                // [self expandSidebar:self] ;
            }
        }
    }
    
    if (proposedPosition > SIDEBAR_WIDTH) {
        answer = SIDEBAR_WIDTH ;
    }
    /*SSYDBL*/ NSLog(@"   Returning %f", answer) ;
    
    return answer ;
}

@end
