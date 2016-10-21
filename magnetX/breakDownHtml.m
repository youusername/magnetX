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
            [doc enumerateElementsWithXPath:@"//ul[@class='mlist']//li" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                [array addObject:[movieModel entity:element]];
            }];

    return array;
}

@end
