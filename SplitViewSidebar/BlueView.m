#import "BlueView.h"

@implementation BlueView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = [self bounds] ;
    [[NSColor colorWithCalibratedRed:0.7 green:0.7 blue:1.0 alpha:1.0] set] ;
    [NSBezierPath fillRect: bounds] ;

    [super drawRect:dirtyRect] ;
}

@end
