//
//  NSTableView+ContextMenu.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "NSTableView+ContextMenu.h"

@implementation NSTableView (ContextMenu)

- (NSMenu*)menuForEvent:(NSEvent*)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:location];
    if (!(row >= 0) || ([event type] != NSRightMouseDown)) {
        return [super menuForEvent:event];
    }
    NSIndexSet *selected = [self selectedRowIndexes];
    if (![selected containsIndex:row]) {
        selected = [NSIndexSet indexSetWithIndex:row];
        [self selectRowIndexes:selected byExtendingSelection:NO];
    }
    if ([[self delegate] respondsToSelector:@selector(tableView:menuForRows:)]) {
        return [(id)[self delegate] tableView:self menuForRows:selected];
    }
    return [super menuForEvent:event];
}

- (void)mouseDown:(NSEvent *)event{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:location];
    if (!(row >= 0) || ([event type] != NSRightMouseDown)) {

    }
    NSIndexSet *selected = [self selectedRowIndexes];
    if (![selected containsIndex:row]) {
        selected = [NSIndexSet indexSetWithIndex:row];
        [self selectRowIndexes:selected byExtendingSelection:NO];
    }
    if ([[self delegate] respondsToSelector:@selector(tableView:clickForRow:)]) {
        [(id)[self delegate] tableView:self clickForRow:row];
    }
    [super mouseDown:event];

}

@end
