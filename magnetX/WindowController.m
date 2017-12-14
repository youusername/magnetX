//
//  WindowController.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "WindowController.h"
#import "AppDelegate.h"
#import "GitHubUpdater.h"

@interface WindowController ()
@property BOOL mouseDownInTopToolBar;
@property (assign) NSPoint initialLocation;
@property (atomic, readwrite, strong, nullable) IBOutlet GitHubUpdater *updater;

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // Set to 10.10 Yosemite style window.
    AppDelegate* app =(AppDelegate*)[NSApplication sharedApplication].delegate;
    app.RootWindow = self.window;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    self.window.titlebarAppearsTransparent = YES;
    
    ///检测更新
    [self.updater checkForUpdatesInBackground];
}
- (void)mouseDown:(NSEvent *)event
{
    //    NSPoint originalMouseLocation = [self.window convertBaseToScreen:[event locationInWindow]];
    NSPoint locationInWindow = [event locationInWindow];
    NSPoint originalMouseLocation = [self.window convertRectToScreen:CGRectMake(locationInWindow.x, locationInWindow.y, self.window.frame.size.width, self.window.frame.size.height)].origin;
    NSRect originalFrame = [self.window frame];
    
    while (YES)
    {
        NSEvent *newEvent = [self.window nextEventMatchingMask:(NSEventMaskLeftMouseDragged | NSEventMaskLeftMouseUp)];
        
        if ([newEvent type] == NSEventTypeLeftMouseUp)
        {
            break;
        }
        
        //        NSPoint newMouseLocation = [self.window convertBaseToScreen:[newEvent locationInWindow]];
        NSPoint newLocationInWindow = [newEvent locationInWindow];
        NSPoint newMouseLocation = [self.window convertRectToScreen:CGRectMake(newLocationInWindow.x, newLocationInWindow.y, self.window.frame.size.width, self.window.frame.size.height)].origin;
        NSPoint delta = NSMakePoint(
                                    newMouseLocation.x - originalMouseLocation.x,
                                    newMouseLocation.y - originalMouseLocation.y);
        
        NSRect newFrame = originalFrame;
        
        newFrame.origin.x += delta.x;
        newFrame.origin.y += delta.y;
        
        [self.window setFrame:newFrame display:YES animate:NO];
    }
}
//- (void)mouseDown:(NSEvent *)theEvent
//{
//    self.initialLocation = [theEvent locationInWindow];
//    NSRect windowFrame = [self.window frame];
//    CGFloat heightOfTitleBarAndTopToolBar = 65;
//    NSRect titleFrame = NSMakeRect(0, windowFrame.size.height-heightOfTitleBarAndTopToolBar, windowFrame.size.width, heightOfTitleBarAndTopToolBar);
//
//    if(NSPointInRect(self.initialLocation, titleFrame))
//    {
//        self.mouseDownInTopToolBar = YES;
//        NSLog(@"Mouse IN");
//    }
//}
//
//-(void)mouseUp:(NSEvent *)theEvent
//{
//    self.mouseDownInTopToolBar = NO;
//    NSLog(@"Mouse UP");
//}
//
//- (void)mouseDragged:(NSEvent *)theEvent
//{
//    if( self.mouseDownInTopToolBar )
//    {
//        NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
//        NSRect windowFrame = [self.window frame];
//
//        NSPoint newOrigin = windowFrame.origin;
//        NSPoint currentLocation = [theEvent locationInWindow];
//
//
//
//        // Update the origin with the difference between the new mouse location and the old mouse location.
//        newOrigin.x += (currentLocation.x - self.initialLocation.x);
//        newOrigin.y += (currentLocation.y - self.initialLocation.y);
//
//        // Don't let window get dragged up under the menu bar
//        if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
//            newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
//        }
//
//        [self.window setFrameOrigin:newOrigin];
//    }
//}


@end
