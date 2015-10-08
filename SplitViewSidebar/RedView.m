#import "RedView.h"

@implementation RedView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = [self bounds] ;
    [[NSColor colorWithCalibratedRed:1.0 green:0.7 blue:1.0 alpha:0.7] set] ;
    [NSBezierPath fillRect: bounds] ;
    
    [super drawRect:dirtyRect] ;
}

@end
