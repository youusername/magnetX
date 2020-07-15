//
//  XTTableView.h
//  
//
//  Created by finn on 2020/6/30.
//  Copyright © 2020 finn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XTMenuDelegate <NSObject>
- (NSMenu*)tableView:(NSTableView*)aTableView menuForRows:(NSIndexSet*)rows;
- (NSMenu*)emptySelectionTableView:(NSTableView*)aTableView;

@end
@interface XTTableView : NSTableView

@end

NS_ASSUME_NONNULL_END
