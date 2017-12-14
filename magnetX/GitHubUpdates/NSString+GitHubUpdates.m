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
 * @file        NSString+GitHubUpdates.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "NSString+GitHubUpdates.h"

@implementation NSString( GitHubUpdates )

+ ( NSString * )stringForSizeInBytes: ( NSUInteger )bytes
{
    double     size;
    NSString * unit;
    
    if( bytes < 1000 )
    {
        return [ NSString stringWithFormat: NSLocalizedString( @"%lu bytes", @"" ), ( unsigned long )bytes ];
    }
    
    if( bytes < 1000UL * 1000UL )
    {
        size = bytes / 1000.0;
        unit = NSLocalizedString( @"KB", @"" );
    }
    else if( bytes < 1000UL * 1000UL * 1000UL )
    {
        size = bytes / ( 1000.0 * 1000.0 );
        unit = NSLocalizedString( @"MB", @"" );
    }
    else
    {
        size = bytes / ( 1000.0 * 1000.0 * 1000.0 );
        unit = NSLocalizedString( @"GB", @"" );
    }
    
    return [ NSString stringWithFormat: NSLocalizedString( @"%.02f %@", @"" ), size, unit ];
}

@end
