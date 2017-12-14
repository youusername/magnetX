/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2017 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        GitHubInstallWindowController.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "GitHubInstallWindowController.h"
#import "GitHubProgressWindowController.h"
#import "GitHubRelease.h"
#import "GitHubReleaseAsset.h"
#import "NSError+GitHubUpdates.h"
#import "NSString+GitHubUpdates.h"
#import "NSBundle+GitHubUpdates.h"

NS_ASSUME_NONNULL_BEGIN

@interface GitHubInstallWindowController() < NSURLSessionDownloadDelegate >

@property( atomic, readwrite, strong, nullable )          GitHubReleaseAsset             * asset;
@property( atomic, readwrite, strong, nullable )          GitHubRelease                  * githubRelease;
@property( atomic, readwrite, strong, nullable )          GitHubProgressWindowController * progressWindowController;
@property( atomic, readwrite, strong, nullable )          NSString                       * title;
@property( atomic, readwrite, strong, nullable )          NSString                       * message;
@property( atomic, readwrite, strong, nullable )          NSAttributedString             * releaseNotes;
@property( atomic, readwrite, assign           )          BOOL                             installingUpdate;
@property( atomic, readwrite, assign           )          BOOL                             canceled;
@property( atomic, readwrite, strong           )          dispatch_queue_t                 queue;
@property( atomic, readwrite, strong, nullable ) IBOutlet NSTextView                     * textView;

- ( IBAction )install: ( nullable id )sender;
- ( IBAction )cancel: ( nullable id )sender;
- ( IBAction )viewOnGitHub: ( nullable id )sender;
- ( void )displayErrorWithMessage: ( NSString * )message;
- ( void )displayErrorWithTitle: ( NSString * )title message: ( NSString * )message;
- ( void )displayError: ( NSError * )error;
- ( void )download;
- ( void )stoppedInstalling;
- ( void )installFromZIP: ( NSURL * )location;
- ( NSString * )temporaryFilePath;
- ( nullable NSURL * )createTemporaryDirectory;
- ( BOOL )unzipFile: ( NSURL * )file toDirectory: ( NSURL * )directory;
- ( nullable NSURL * )findAppInDirectory: ( NSURL * )directory;
- ( BOOL )checkCodeSigning: ( NSURL * )app;
- ( BOOL )replaceApp: ( NSURL * )app;

@end

NS_ASSUME_NONNULL_END

@implementation GitHubInstallWindowController

- ( instancetype )initWithAsset: ( GitHubReleaseAsset * )asset release: ( GitHubRelease * )release
{
    if( ( self = [ self init ] ) )
    {
        self.asset         = asset;
        self.githubRelease = release;
    }
    
    return self;
}

- ( instancetype )init
{
    return [ self initWithWindowNibName: NSStringFromClass( [ self class ] ) ];
}

- ( instancetype )initWithWindow: ( nullable NSWindow * )window
{
    if( ( self = [ super initWithWindow: window ] ) )
    {
        self.queue = dispatch_queue_create( "com.xs-labs.GitHubInstallWindowController", DISPATCH_QUEUE_SERIAL );
    }
    
    return self;
}

- ( nullable instancetype )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {
        self.queue = dispatch_queue_create( "com.xs-labs.GitHubInstallWindowController", DISPATCH_QUEUE_SERIAL );
    }
    
    return self;
}

- ( void )windowDidLoad
{
    NSString * app;
    NSString * version;
    
    [ super windowDidLoad ];
    
    self.window.title                      = NSLocalizedString( @"Software Update", @"" );
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility            = NSWindowTitleHidden;
    
    self.textView.textContainerInset = NSMakeSize( 10.0, 15.0 );
    
    app     = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    version = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleShortVersionString" ];
    
    if( app.length == 0 )
    {
        self.title = NSLocalizedString( @"A software update is available available!", @"" );
    }
    else
    {
        self.title = [ NSString stringWithFormat: NSLocalizedString( @"A new version of %@ is available!", @"" ), app ];
    }
    
    if( version.length == 0 )
    {
        self.message = [ NSString stringWithFormat: NSLocalizedString( @"Version %@ can be is available. Would you like to install it now?", @"" ), self.githubRelease.tagName ];
    }
    else
    {
        self.message = [ NSString stringWithFormat: NSLocalizedString( @"Version %@ is available. You have version %@. Would you like to install the new version now?", @"" ), self.githubRelease.tagName, version ];
    }
    
    self.releaseNotes = [ [ NSAttributedString alloc ] initWithString: self.githubRelease.body attributes: nil ];
}

- ( IBAction )install: ( nullable id )sender
{
    NSString * app;
    
    ( void )sender;
    
    app = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    
    self.window.isVisible                       = NO;
    self.installingUpdate                       = YES;
    self.progressWindowController               = [ GitHubProgressWindowController new ];
    self.progressWindowController.progress      = 0.0;
    self.progressWindowController.progressMin   = 0.0;
    self.progressWindowController.progressMax   = self.asset.size;
    self.progressWindowController.indeterminate = YES;
    
    if( app.length == 0 )
    {
        self.progressWindowController.title = NSLocalizedString( @"Downloading software update", @"" );
    }
    else
    {
        self.progressWindowController.title = [ NSString stringWithFormat: NSLocalizedString( @"Downloading %@ %@", @"" ), app, self.githubRelease.tagName ];
    }
    
    [ self download ];
    [ self.progressWindowController showWindow: nil ];
    [ self.progressWindowController.window center ];
    [ NSApp runModalForWindow: self.progressWindowController.window ];
}

- ( IBAction )cancel: ( nullable id )sender
{
    ( void )sender;
    
    [ self.window close ];
}

- ( IBAction )viewOnGitHub: ( nullable id )sender
{
    ( void )sender;
    
    [ [ NSWorkspace sharedWorkspace ] openURL: self.githubRelease.htmlURL ];
}

- ( void )displayErrorWithMessage: ( NSString * )message
{
    [ self displayErrorWithTitle: NSLocalizedString( @"Error", @"" ) message: message ];
}

- ( void )displayErrorWithTitle: ( NSString * )title message: ( NSString * )message;
{
    NSError * error;
    
    error = [ NSError errorWithDomain: NSCocoaErrorDomain code: -1 userInfo: @{ NSLocalizedDescriptionKey : title, NSLocalizedRecoverySuggestionErrorKey : message } ];
    
    [ self displayError: error ];
}

- ( void )displayError: ( NSError * )error
{
    dispatch_async
    (
        dispatch_get_main_queue(),
        ^( void )
        {
            NSAlert * alert;
            
            alert = [ NSAlert alertWithError: error ];
            
            [ alert runModal ];
        }
    );
}

- ( void )download
{
    self.canceled                         = NO;
    self.progressWindowController.message = NSLocalizedString( @"Connecting...", @"" );
                    
    dispatch_async
    (
        self.queue,
        ^( void )
        {
            NSURLSession             * session;
            NSURLSessionDownloadTask * task;
            
            session = [ NSURLSession sessionWithConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] delegate: self delegateQueue: [ NSOperationQueue mainQueue ] ];
            task    = [ session downloadTaskWithURL: self.asset.downloadURL ];
            
            [ task resume ];
            
            dispatch_sync
            (
                dispatch_get_main_queue(),
                ^( void )
                {
                    __weak __typeof__( self ) ws = self;
                    
                    self.progressWindowController.cancel = ^( void )
                    {
                        __strong __typeof__( self ) ss = ws;
                        
                        ss.canceled = YES;
                        
                        [ task cancel ];
                        [ ss stoppedInstalling ];
                    };
                }
            );
        }
    );
}

- ( void )stoppedInstalling
{
    [ self.progressWindowController.window close ];
    [ NSApp stopModal ];
    
    self.window.isVisible         = YES;
    self.progressWindowController = nil;
    self.installingUpdate         = NO;
}

- ( void )installFromZIP: ( NSURL * )location
{
    ( void )location;
    
    self.progressWindowController.indeterminate = YES;
    self.progressWindowController.progress      = 0.0;
    self.progressWindowController.progressMax   = 0.0;
    self.progressWindowController.message       = NSLocalizedString( @"Expanding archive...", @"" );
    
    if( [ [ NSFileManager defaultManager ] fileExistsAtPath: location.path isDirectory: nil ] == NO )
    {
        [ self stoppedInstalling ];
        [ self displayErrorWithMessage: NSLocalizedString( @"Cannot find the downloaded file.", @"" ) ];
        
        return;
    }
    
    dispatch_async
    (
        self.queue,
        ^( void )
        {
            BOOL    success;
            NSURL * tempURL;
            NSURL * appURL;
            
            success = NO;
            
            if( ( tempURL = [ self createTemporaryDirectory ] ) == nil )
            {
                goto end;
            }
            
            if( [ self unzipFile: location toDirectory: tempURL ] == NO )
            {
                goto end;
            }
            
            if( ( appURL = [ self findAppInDirectory: tempURL ] ) == nil )
            {
                goto end;
            }
            
            if( [ self checkCodeSigning: appURL ] == NO )
            {
                goto end;
            }
            
            if( [ self replaceApp: appURL ] == NO )
            {
                goto end;
            }
            
            success = YES;
            
            end:
            
            dispatch_async
            (
                dispatch_get_main_queue(),
                ^( void )
                {
                    NSAlert  * alert;
                    NSTask   * task;
                    NSString * path;
                    
                    [ self stoppedInstalling ];
                    [ self.window close ];
                    
                    if( success )
                    {
                        alert                 = [ NSAlert new ];
                        alert.messageText     = NSLocalizedString( @"Installation Successfull", @"" );
                        alert.informativeText = NSLocalizedString( @"The application will now be restarted.", @"" );
                        
                        [ alert addButtonWithTitle: NSLocalizedString( @"Relaunch", @"" ) ];
                        [ alert runModal ];
                        
                        path            = [ NSBundle bundleForClass: [ self class ] ].bundlePath;
                        path            = [ path stringByAppendingPathComponent: @"Versions" ];
                        path            = [ path stringByAppendingPathComponent: @"A" ];
                        path            = [ path stringByAppendingPathComponent: @"Relauncher" ];
                        task            = [ NSTask new ];
                        task.launchPath = path;
                        task.arguments  = @[ [ NSBundle mainBundle ].bundlePath ];
                        
                        @try
                        {
                            [ task launch ];
                        }
                        @catch( NSException * e )
                        {
                            ( void )e;
                        }
                        
                        [ NSApp terminate: nil ];
                    }
                }
            );
        }
    );
}

- ( NSString * )temporaryFilePath
{
    return [ NSTemporaryDirectory() stringByAppendingPathComponent: [ NSProcessInfo processInfo ].globallyUniqueString ];
}

- ( nullable NSURL * )createTemporaryDirectory;
{
    NSURL   * url;
    NSError * error;
    
    error = nil;
    url   = [ NSURL fileURLWithPath: [ self temporaryFilePath ] isDirectory: YES ];
    
    if( [ [ NSFileManager defaultManager ] createDirectoryAtURL: url withIntermediateDirectories: YES attributes: nil error: &error ] == NO )
    {
        if( error )
        {
            [ self displayError: error ];
        }
        else
        {
            [ self displayErrorWithMessage: NSLocalizedString( @"Cannot create temporary directory.", @"" ) ];
        }
        
        return nil;
    }
    
    return url;
}

- ( BOOL )unzipFile: ( NSURL * )file toDirectory: ( NSURL * )directory
{
    NSTask * task;
    
    task            = [ NSTask new ];
    task.launchPath = @"/usr/bin/unzip";
    task.arguments  = @[ @"-o", file.path, @"-d", directory.path ];
    
    @try
    {
        [ task launch ];
        [ task waitUntilExit ];
    }
    @catch( NSException * e )
    {
        [ self displayError: [ NSError errorWithException: e ] ];
        
        return NO;
    }
    
    if( task.terminationStatus != 0 )
    {
        [ self displayErrorWithMessage: NSLocalizedString( @"Error expanding the ZIP archive.", @"" ) ];
        
        return NO;
    }
    
    return YES;
}

- ( nullable NSURL * )findAppInDirectory: ( NSURL * )directory
{
    NSURL    * url;
    NSBundle * bundle;
    NSString * bundleID;
    NSString * version;
    
    dispatch_sync
    (
        dispatch_get_main_queue(),
        ^( void )
        {
            self.progressWindowController.message = NSLocalizedString( @"Finding application...", @"" );
        }
    );
    
    for( url in [ [ NSFileManager defaultManager ] contentsOfDirectoryAtURL: directory includingPropertiesForKeys: nil options: NSDirectoryEnumerationSkipsSubdirectoryDescendants error: NULL ] )
    {
        if( [ url.pathExtension isEqualToString: @"app" ] == NO )
        {
            continue;
        }
        
        bundle = [ NSBundle bundleWithURL: url ];
        
        if( bundle == nil )
        {
            continue;
        }
        
        bundleID = [ bundle objectForInfoDictionaryKey: @"CFBundleIdentifier" ];
        version  = [ bundle objectForInfoDictionaryKey: @"CFBundleShortVersionString" ];
        
        if( bundleID == nil || version == nil )
        {
            continue;
        }
        
        if( [ [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleIdentifier" ] isEqualToString: bundleID ] == NO )
        {
            continue;
        }
        
        if( [ version isEqualToString: self.githubRelease.tagName ] == NO )
        {
            {
                NSString * message;
                
                message = [ NSString stringWithFormat: NSLocalizedString( @"Invalid application version for %@. Expected %@, found %@.", @"" ), bundleID, self.githubRelease.tagName, version ];
                
                [ self displayErrorWithTitle: NSLocalizedString( @"Version mismatch", @"" ) message: message ];
            }
            
            return nil;
        }
        
        return url;
    }
    
    [ self displayErrorWithMessage: NSLocalizedString( @"Cannot find a valid application in the extracted archive.", @"" ) ];
    
    return nil;
}

- ( BOOL )checkCodeSigning: ( NSURL * )app
{
    NSBundle * b1;
    NSBundle * b2;
    BOOL       cs1;
    BOOL       cs2;
    NSString * id1;
    NSString * id2;
    
    dispatch_sync
    (
        dispatch_get_main_queue(),
        ^( void )
        {
            self.progressWindowController.message = NSLocalizedString( @"Verifying code-signing...", @"" );
        }
    );
    
    b1  = [ NSBundle mainBundle ];
    b2  = [ NSBundle bundleWithURL: app ];
    cs1 = b1.isCodeSigned;
    cs2 = b2.isCodeSigned;
    id1 = b1.codeSigningIdentity;
    id2 = b2.codeSigningIdentity;
    
    if( cs1 == YES && cs2 == NO )
    {
        [ self displayErrorWithTitle: NSLocalizedString( @"Code-Signing Error", @"" ) message: NSLocalizedString( @"Downloaded update is not code-signed, while installed version is code-signed.", @"" ) ];
        
        return NO;
    }
    
    if( cs1 == YES && cs2 == YES && ( id1 == nil || id2 == nil ) )
    {
        [ self displayErrorWithTitle: NSLocalizedString( @"Code-Signing Error", @"" ) message: NSLocalizedString( @"Cannot verify code-signing identity.", @"" ) ];
        
        return NO;
    }
    
    if( cs1 == YES && cs2 == YES && [ id1 isEqualToString: id2 ] == NO )
    {
        [ self displayErrorWithTitle: NSLocalizedString( @"Code-Signing Error", @"" ) message: [ NSString stringWithFormat: NSLocalizedString( @"Code signing identity mismatch. %@ vs %@", @"" ), id1, id2 ] ];
        
        return NO;
    }
    
    return YES;
}

- ( BOOL )replaceApp: ( NSURL * )app
{
    NSError * error;
    NSURL   * trashURL;
    
    if( [ [ NSFileManager defaultManager ] trashItemAtURL: [ NSBundle mainBundle ].bundleURL resultingItemURL: &trashURL error: &error ] == NO )
    {
        [ self displayErrorWithMessage: NSLocalizedString( @"Cannot move the original application to the trash.", @"" ) ];
        
        return NO;
    }
    
    if( [ [ NSFileManager defaultManager ] moveItemAtURL: app toURL: [ NSBundle mainBundle ].bundleURL error: &error ] == NO )
    {
        if( [ [ NSFileManager defaultManager ] moveItemAtURL: trashURL toURL: [ NSBundle mainBundle ].bundleURL error: &error ] == NO )
        {
            [ self displayErrorWithMessage: NSLocalizedString( @"Cannot move the new application.", @"" ) ];
        }
        else
        {
            [ self displayErrorWithMessage: NSLocalizedString( @"Cannot move the new application. Original application is in your Trash", @"" ) ];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - NSURLSessionDownloadDelegate

- ( void )URLSession: ( NSURLSession * )session downloadTask: ( NSURLSessionDownloadTask * )downloadTask didWriteData: ( int64_t )bytesWritten totalBytesWritten: ( int64_t )totalBytesWritten totalBytesExpectedToWrite: ( int64_t )totalBytesExpectedToWrite
{
    NSString * message;
    
    ( void )session;
    ( void )downloadTask;
    ( void )bytesWritten;
    
    if( totalBytesWritten > 0 && totalBytesExpectedToWrite > 0 )
    {
        message = [ NSString stringWithFormat: NSLocalizedString( @"%@ of %@", @"" ), [ NSString stringForSizeInBytes: ( NSUInteger )totalBytesWritten ], [ NSString stringForSizeInBytes: ( NSUInteger )totalBytesExpectedToWrite ] ];
    }
    
    self.progressWindowController.indeterminate = NO;
    self.progressWindowController.progress      = totalBytesWritten;
    self.progressWindowController.progressMax   = totalBytesExpectedToWrite;
    self.progressWindowController.message       = message;
}

- ( void )URLSession: ( NSURLSession * )session task: ( NSURLSessionTask * )task didCompleteWithError: ( NSError * )error
{
    ( void )session;
    ( void )task;
    
    if( error != nil && self.canceled == NO )
    {
        [ self stoppedInstalling ];
        [ self displayError: error ];
    }
}

- ( void )URLSession: ( NSURLSession * )session downloadTask: ( NSURLSessionDownloadTask * )downloadTask didFinishDownloadingToURL: ( NSURL * )location
{
    NSURL   * url;
    NSError * error;
    
    ( void )session;
    ( void )downloadTask;
    
    error = nil;
    url   = [ NSURL fileURLWithPath: [ self temporaryFilePath ] ];
    
    if( [ [ NSFileManager defaultManager ] moveItemAtURL: location toURL: url error: &error ] == NO )
    {
        [ self stoppedInstalling ];
        
        if( error )
        {
            [ self displayError: error ];
        }
        else
        {
            [ self displayErrorWithMessage: NSLocalizedString( @"Cannot move downloaded file.", @"" ) ];
        }
        
        return;
    }
    
    [ self installFromZIP: url ];
}

@end
