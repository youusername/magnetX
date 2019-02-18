//
//  MLHudAlertWindow.m
//

#import "MLHudAlertWindow.h"

@implementation MLHudAlertWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    
    if ( self )
    {
        [self setStyleMask:NSBorderlessWindowMask];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    
    return self;
}

- (void)setContentView:(NSView *)aView {
    [aView setWantsLayer:YES];
    aView.layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    aView.layer.cornerRadius = 20;
    aView.layer.masksToBounds = YES;
    [super setContentView:aView];
}

- (void)setCornerRadius:(float)cornerRadius {
    _cornerRadius = cornerRadius;
    NSView *view = self.contentView;
    view.layer.cornerRadius = cornerRadius;
}

@end
