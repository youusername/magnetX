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
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        dispatch_async(dispatch_queue_create("download queue", nil), ^{
            ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
            ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//ul[@class='mlist']"]; //寻找该 XPath 代表的 HTML 节点,
            //遍历其子节点,
            [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:[movieModel entity:element]];
            }];

//        });
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
// 
//    }];
    return array;
}

@end
