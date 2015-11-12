#import <Cocoa/Cocoa.h>

@interface FixedSidebarSplitViewController : NSSplitViewController <NSSplitViewDelegate>

@property IBOutlet NSViewController* sidebarViewController ;
@property IBOutlet NSViewController* bodyViewController ;
@property IBOutlet NSView* sidebarView ;
@property IBOutlet NSView* bodyView ;

@property CGFloat fixedWidth ;

/* The superclass NSSplitViewController does not declare
 this as an outlet.  I want an outlet for Interface Builder.   Note that,
 in the xib, both outlets 'splitView' and 'view' are connected to the
 same NSSplitView.  Strange, but makes sense, and it works.  */
@property IBOutlet NSSplitView* splitView ;

- (IBAction)collapseSidebar:(id)sender ;
- (IBAction)expandSidebar:(id)sender ;

@end
