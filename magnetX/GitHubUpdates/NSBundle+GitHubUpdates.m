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
 * @file        NSBundle+GitHubUpdates.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "NSBundle+GitHubUpdates.h"

@implementation NSBundle( GitHubUpdates )

- ( BOOL )isCodeSigned
{
    NSTask * task;
    
    task            = [ NSTask new ];
    task.launchPath = @"/usr/bin/codesign";
    task.arguments  = @[ @"-dv", self.bundlePath ];
    
    @try
    {
        [ task launch ];
        [ task waitUntilExit ];
    }
    @catch( NSException * e )
    {
        ( void )e;
        
        return NO;
    }
    
    return task.terminationStatus == 0;
}

- ( nullable NSString * )codeSigningIdentity
{
    NSTask                * task;
    NSPipe                * pipe;
    NSData                * data;
    NSArray< NSString * > * lines;
    NSString              * line;
    
    pipe                = [ NSPipe pipe ];
    task                = [ NSTask new ];
    task.launchPath     = @"/usr/bin/codesign";
    task.arguments      = @[ @"-dvvv", self.bundlePath ];
    task.standardError  = pipe;
    
    @try
    {
        [ task launch ];
        [ task waitUntilExit ];
    }
    @catch( NSException * e )
    {
        ( void )e;
        
        return nil;
    }
    
    if( task.terminationStatus != 0 )
    {
        return nil;
    }
    
    data = [ pipe.fileHandleForReading readDataToEndOfFile ];
    
    if( data.length == 0 )
    {
        return nil;
    }
    
    lines = [ [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ] componentsSeparatedByString: @"\n" ];
    
    for( line in lines )
    {
        line = [ line stringByTrimmingCharactersInSet: [ NSCharacterSet whitespaceAndNewlineCharacterSet ] ];
        
        if( [ line hasPrefix: @"Authority=" ] == NO )
        {
            continue;
        }
        
        return [ line substringFromIndex: 10 ];
    }
    
    return nil;
}

@end
