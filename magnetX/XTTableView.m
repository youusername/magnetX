//
//  XTTableView.m
//  
//
//  Created by finn on 2020/6/30.
//  Copyright © 2020 finn. All rights reserved.
//

#import "XTTableView.h"

@implementation XTTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (NSMenu*)menuForEvent:(NSEvent*)event
{
    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:location];
    if (!(row >= 0) || ([event type] != NSRightMouseDown)) {
        if ([[self delegate] respondsToSelector:@selector(emptySelectionTableView:)]) {
            return [(id)[self delegate] emptySelectionTableView:self];
        }
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
@end
