//
//  AppDelegate.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "AppDelegate.h"
#import "UserEditorStatus.h"
#import "CocoaSecurity.h"

@interface AppDelegate ()

- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate
#pragma mark - MenuItem
- (IBAction)hideWindow:(id)sender {
    [[NSApplication sharedApplication] hide:self];
}



- (IBAction)help:(id)sender {
    NSArray* urls = [NSArray arrayWithObject:[NSURL URLWithString:@"https://github.com/youusername/magnetX"]];
    [[NSWorkspace sharedWorkspace] openURLs:urls withAppBundleIdentifier:nil options:NSWorkspaceLaunchWithoutActivation additionalEventParamDescriptor:nil launchIdentifiers:nil];
}

- (IBAction)updateRule:(id)sender {
    
    NSURL*url = [NSURL URLWithString:MagnetXUpdateRuleURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *docPath = [[NSBundle mainBundle] resourcePath];
            [data writeToFile:[docPath stringByAppendingString:@"/rule.zip"] atomically:YES ];
            
            [SSZipArchive unzipFileAtPath:[docPath stringByAppendingString:@"/rule.zip"] toDestination:[docPath stringByAppendingString:@"/"]progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                NSLog(@"entry %@",entry);

            } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
                
                NSLog(@"path %@",path);
                [MagnetXNotification postNotificationName:MagnetXUpdateRuleNotification];
            }];

    }];
    [dataTask resume];
    
}


//点击左上角小叉，是否退出软件
//- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
//    return YES;
//}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    // Insert code here to initialize your application
}
//点击Dock重新打开主窗口
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    //    if (!flag){//是否有可见窗口
    //主窗口显示
    //        [NSApp activateIgnoringOtherApps:NO];
    [self.RootWindow makeKeyAndOrderFront:self];
    
    
    //    }
    
    
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    
}

- (void)applicationWillHide:(NSNotification *)notification
{
    
}
- (void)applicationDidHide:(NSNotification *)notification{
    
}
- (void)applicationWillUnhide:(NSNotification *)notification{
    
}
- (void)applicationDidUnhide:(NSNotification *)notification{
    
}

- (void)applicationWillBecomeActive:(NSNotification *)notification{
    //回到应用时让搜索输入框成为第一响应者
    [MagnetXNotification postNotificationName:MagnetXMakeFirstResponder];
    
    if (![[[UserEditorStatus sharedWorkspace] jsonFileMD5] isEqualToString:@"1"]) {
        
        NSData*jsonData = [NSData dataWithContentsOfFile:[UserEditorStatus getJsonFilePath]];
        NSLog(@"applicationWillBecomeActive");
        NSLog(@"hash_%@  jsonmd5_%@",[[UserEditorStatus sharedWorkspace] jsonFileMD5],[CocoaSecurity md5WithData:jsonData].hex);
        
        if (![[[UserEditorStatus sharedWorkspace] jsonFileMD5] isEqualToString:[CocoaSecurity md5WithData:jsonData].hex]) {
            NSLog(@"applicationWillBecomeActive md5_%@",[CocoaSecurity md5WithData:jsonData].hex);
            [[UserEditorStatus sharedWorkspace] setJsonFileMD5:[CocoaSecurity md5WithData:jsonData].hex];
            //切回软件刷新源列表
            [MagnetXNotification postNotificationName:MagnetXUpdateRuleNotification];
            
        }
    }
    
}
- (void)applicationDidBecomeActive:(NSNotification *)notification{
    
}
- (void)applicationWillResignActive:(NSNotification *)notification{
    
}
- (void)applicationDidResignActive:(NSNotification *)notification{
    
    
}
- (void)applicationWillUpdate:(NSNotification *)notification{
    
}
- (void)applicationDidUpdate:(NSNotification *)notification{
    
}

- (void)applicationDidChangeScreenParameters:(NSNotification *)notification{
    
    
}

- (void)applicationDidChangeOcclusionState:(NSNotification *)notification{
    
}

#pragma mark - NSWindowDelegate
-(void)windowWillClose:(NSNotification *)notification{
//    [self hideWindow:nil];
}
#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.214644496.magnetX" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.214644496.magnetX"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"magnetX" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"magnetX.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            // Replace this implementation with code to handle the error appropriately.
             
            /*
             Typical reasons for an error here include:
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    NSManagedObjectContext *context = self.managedObjectContext;

    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    NSManagedObjectContext *context = _managedObjectContext;

    if (!context) {
        return NSTerminateNow;
    }
    
    if (![context commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (!context.hasChanges) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertSecondButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
