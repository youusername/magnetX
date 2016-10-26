//
//  breakDownHtml.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "breakDownHtml.h"
#import "Ono.h"
#import "movieModel.h"

@implementation breakDownHtml
+ (NSMutableArray*)breakDownHtmlToUrl:(NSString*)url{
    NSMutableArray*array = [NSMutableArray new];

    NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
    [doc enumerateElementsWithXPath:selectSideRule.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        movieModel*movie = [movieModel entity:element];
        movie.source = url;
        [array addObject:movie];
    }];

    return array;
}

@end
