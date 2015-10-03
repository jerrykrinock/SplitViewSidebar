#import "RedView.h"

@implementation RedView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect] ;
    NSRect bounds = [self bounds] ;
    [[NSColor redColor] set] ;
    [NSBezierPath fillRect: bounds] ;
    
}

@end
