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
 * @file        GitHubReleaseAsset.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "GitHubReleaseAsset.h"

static NSISO8601DateFormatter * __strong dateFormatter;

NS_ASSUME_NONNULL_BEGIN

@interface GitHubReleaseAsset()

@property( atomic, readwrite, strong, nullable ) NSURL         * url;
@property( atomic, readwrite, strong, nullable ) NSURL         * downloadURL;
@property( atomic, readwrite, strong, nullable ) NSString      * name;
@property( atomic, readwrite, strong, nullable ) NSString      * contentType;
@property( atomic, readwrite, strong, nullable ) NSDate        * created;
@property( atomic, readwrite, strong, nullable ) NSDate        * updated;
@property( atomic, readwrite, assign           ) NSUInteger      size;

@end

NS_ASSUME_NONNULL_END

@implementation GitHubReleaseAsset


- ( nullable instancetype )initWithDictionary: ( NSDictionary * )dict
{
    static dispatch_once_t once;
    
    NSString * url;
    NSString * downloadURL;
    NSString * name;
    NSString * contentType;
    NSString * created;
    NSString * updated;
    NSNumber * size;
    
    dispatch_once
    (
        &once,
        ^( void )
        {
            dateFormatter = [ NSISO8601DateFormatter new ];
        }
    );
    
    if( ( self = [ self init ] ) )
    {
        url         = dict[ @"url" ];
        downloadURL = dict[ @"browser_download_url" ];
        name        = dict[ @"name" ];
        contentType = dict[ @"content_type" ];
        created     = dict[ @"created_at" ];
        updated     = dict[ @"updated_at" ];
        size        = dict[ @"size" ];
        
        if( [ url isKindOfClass: [ NSString class ] ] )
        {
            self.url = [ NSURL URLWithString: url ];
        }
        
        if( [ downloadURL isKindOfClass: [ NSString class ] ] )
        {
            self.downloadURL = [ NSURL URLWithString: downloadURL ];
        }
        
        if( [ name isKindOfClass: [ NSString class ] ] )
        {
            self.name = name;
        }
        
        if( [ contentType isKindOfClass: [ NSString class ] ] )
        {
            self.contentType = contentType;
        }
        
        if( [ created isKindOfClass: [ NSString class ] ] )
        {
            self.created = [ dateFormatter dateFromString: created ];
        }
        
        if( [ updated isKindOfClass: [ NSString class ] ] )
        {
            self.updated = [ dateFormatter dateFromString: updated ];
        }
        
        if( [ size isKindOfClass: [ NSNumber class ] ] )
        {
            self.size = size.unsignedIntegerValue;
        }
    }
    
    return self;
}

- ( NSString * )description
{
    NSString * description;
    
    description = [ super description ];
    
    if( self.name.length )
    {
        description = [ description stringByAppendingFormat: @" %@", self.name ];
    }
    
    if( self.created )
    {
        description = [ description stringByAppendingFormat: @" - %@", self.created ];
    }
    
    if( self.size > 0 )
    {
        description = [ description stringByAppendingFormat: @" (%lu bytes)", ( unsigned long )( self.size ) ];
    }
    
    return description;
}

@end
