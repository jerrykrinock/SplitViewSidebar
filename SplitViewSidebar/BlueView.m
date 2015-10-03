#import "BlueView.h"

@implementation BlueView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect] ;
    NSRect bounds = [self bounds] ;
    [[NSColor blueColor] set] ;
    [NSBezierPath fillRect: bounds] ;
}

@end
