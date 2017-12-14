//
//  MagSplitViewController.m
//  magnetX
//
//  Created by zhangjing on 2017/12/6.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "MagSplitViewController.h"

@interface MagSplitViewController ()

@end

@implementation MagSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [NSColor clearColor].CGColor;
    [MagnetXNotification addObserver:self selector:@selector(hideSideView) name:@"hideSideView"];
}
- (void)hideSideView{
    NSSplitViewItem * item = [self.splitViewItems firstObject];
    item.collapsed = !item.isCollapsed;
    item.minimumThickness = 100;
}
@end
