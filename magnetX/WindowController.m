//
//  WindowController.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "WindowController.h"
#import "AppDelegate.h"
@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // Set to 10.10 Yosemite style window.
//    AppDelegate* app =(AppDelegate*)[NSApplication sharedApplication].delegate;
//    self.window.delegate = app;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    self.window.titlebarAppearsTransparent = YES;
}

@end
