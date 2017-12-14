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
 * @file        GitHubRelease.m
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

#import "GitHubRelease.h"
#import "GitHubReleaseAsset.h"

static NSISO8601DateFormatter * __strong dateFormatter;

NS_ASSUME_NONNULL_BEGIN

@interface GitHubRelease()

@property( atomic, readwrite, strong, nullable ) NSURL                           * url;
@property( atomic, readwrite, strong, nullable ) NSURL                           * htmlURL;
@property( atomic, readwrite, strong, nullable ) NSString                        * tagName;
@property( atomic, readwrite, assign           ) BOOL                              draft;
@property( atomic, readwrite, assign           ) BOOL                              prerelease;
@property( atomic, readwrite, strong, nullable ) NSDate                          * created;
@property( atomic, readwrite, strong, nullable ) NSDate                          * published;
@property( atomic, readwrite, strong, nullable ) NSURL                           * tarballURL;
@property( atomic, readwrite, strong, nullable ) NSURL                           * zipballURL;
@property( atomic, readwrite, strong, nullable ) NSString                        * body;
@property( atomic, readwrite, strong, nullable ) NSArray< GitHubReleaseAsset * > * assets;

- ( instancetype )initWithDictionary: ( NSDictionary * )dict;

@end

NS_ASSUME_NONNULL_END

@implementation GitHubRelease

+ ( nullable NSArray< GitHubRelease * > * )releasesWithData: ( NSData * )data error: ( NSError * __autoreleasing * )error
{
    NSArray                           * json;
    NSDictionary                      * dict;
    GitHubRelease                     * release;
    NSMutableArray< GitHubRelease * > * releases;
    NSError                           * e;
    
    e        = nil;
    json     = [ NSJSONSerialization JSONObjectWithData: data options: ( NSJSONReadingOptions )0 error: &e ];
    releases = [ NSMutableArray new ];
    
    if( e != nil )
    {
        if( error )
        {
            *( error ) = e;
        }
        
        return nil;
    }
    
    for( dict in json )
    {
        if( [ dict isKindOfClass: [ NSDictionary class ] ] == NO )
        {
            continue;
        }
        
        release = [ [ GitHubRelease alloc ] initWithDictionary: dict ];
        
        if( release )
        {
            [ releases addObject: release ];
        }
    }
    
    return [ releases copy ];
}

- ( instancetype )initWithDictionary: ( NSDictionary * )dict
{
    static dispatch_once_t once;
    
    NSString * url;
    NSString * htmlURL;
    NSString * tagName;
    NSNumber * draft;
    NSNumber * prerelease;
    NSString * created;
    NSString * published;
    NSString * tarballURL;
    NSString * zipballURL;
    NSString * body;
    NSArray  * assetsArray;
    
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
        htmlURL     = dict[ @"html_url" ];
        tagName     = dict[ @"tag_name" ];
        draft       = dict[ @"draft" ];
        prerelease  = dict[ @"prerelease" ];
        created     = dict[ @"created_at" ];
        published   = dict[ @"published_at" ];
        tarballURL  = dict[ @"tarball_url" ];
        zipballURL  = dict[ @"zipball_url" ];
        body        = dict[ @"body" ];
        assetsArray = dict[ @"assets" ];
        
        if( [ url isKindOfClass: [ NSString class ] ] )
        {
            self.url = [ NSURL URLWithString: url ];
        }
        
        if( [ htmlURL isKindOfClass: [ NSString class ] ] )
        {
            self.htmlURL = [ NSURL URLWithString: htmlURL ];
        }
        
        if( [ tagName isKindOfClass: [ NSString class ] ] )
        {
            self.tagName = tagName;
        }
        
        if( [ draft isKindOfClass: [ NSNumber class ] ] )
        {
            self.draft = draft.boolValue;
        }
        
        if( [ prerelease isKindOfClass: [ NSNumber class ] ] )
        {
            self.prerelease = prerelease.boolValue;
        }
        
        if( [ created isKindOfClass: [ NSString class ] ] )
        {
            self.created = [ dateFormatter dateFromString: created ];
        }
        
        if( [ published isKindOfClass: [ NSString class ] ] )
        {
            self.published = [ dateFormatter dateFromString: published ];
        }
        
        if( [ tarballURL isKindOfClass: [ NSString class ] ] )
        {
            self.tarballURL = [ NSURL URLWithString: tarballURL ];
        }
        
        if( [ zipballURL isKindOfClass: [ NSString class ] ] )
        {
            self.zipballURL = [ NSURL URLWithString: zipballURL ];
        }
        
        if( [ body isKindOfClass: [ NSString class ] ] )
        {
            self.body = body;
        }
        
        if( [ assetsArray isKindOfClass: [ NSArray class ] ] )
        {
            {
                NSDictionary                           * assetDict;
                GitHubReleaseAsset                     * asset;
                NSMutableArray< GitHubReleaseAsset * > * assets;
                
                assets = [ NSMutableArray new ];
                
                for( assetDict in assetsArray )
                {
                    if( [ assetDict isKindOfClass: [ NSDictionary class ] ] == NO )
                    {
                        continue;
                    }
                    
                    asset = [ [ GitHubReleaseAsset alloc ] initWithDictionary: assetDict ];
                    
                    if( asset )
                    {
                        [ assets addObject: asset ];
                    }
                }
                
                if( assets.count )
                {
                    self.assets = [ assets copy ];
                }
            }
        }
    }
    
    return self;
}

- ( NSString * )description
{
    NSString * description;
    
    description = [ super description ];
    
    if( self.tagName.length )
    {
        description = [ description stringByAppendingFormat: @" %@", self.tagName ];
    }
    
    if( self.published )
    {
        description = [ description stringByAppendingFormat: @" - %@", self.published ];
    }
    
    if( self.assets.count == 1 )
    {
        description = [ description stringByAppendingFormat: @" (%lu asset)", ( unsigned long )( self.assets.count ) ];
    }
    else if( self.assets.count )
    {
        description = [ description stringByAppendingFormat: @" (%lu assets)", ( unsigned long )( self.assets.count ) ];
    }
    
    return description;
}

@end
