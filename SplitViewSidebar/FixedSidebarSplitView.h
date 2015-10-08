#import <Cocoa/Cocoa.h>

@class FixedSidebarSplitViewController ;

@interface FixedSidebarSplitView : NSSplitView

@property BOOL userIsDraggingDivider ;
@property CGFloat dividerDragX ;
@property IBOutlet FixedSidebarSplitViewController* splitViewController ;

@end
