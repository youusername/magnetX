//
//  NSTableView+ContextMenu.h
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ContextMenuDelegate <NSObject>
- (NSMenu*)tableView:(NSTableView*)aTableView menuForRows:(NSIndexSet*)rows;
- (void)tableView:(NSTableView*)aTableView clickForRow:(NSInteger)row;

@end

@interface NSTableView (ContextMenu)

@end
