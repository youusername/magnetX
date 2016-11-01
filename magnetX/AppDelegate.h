//
//  AppDelegate.h
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSWindow *RootWindow;
- (IBAction)updateRule:(id)sender;
@end

