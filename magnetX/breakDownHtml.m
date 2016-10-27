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
#import "AFHTTPSessionManager.h"
@implementation breakDownHtml
+ (breakDownHtml *)downloader{
    static breakDownHtml *downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[breakDownHtml alloc] init];
    });
    return downloader;
}
- (void)downloadHtmlURLString:(NSString *)urlString willStartBlock:(void(^)()) startBlock success:(void(^)(NSArray*array)) successHandler failure:(void(^)(NSError *error)) failureHandler{
    if (startBlock) {
        startBlock();
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_queue_create("download html queue", nil), ^{
            NSMutableArray*array = [NSMutableArray new];
            ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:responseObject error:nil];
            [doc enumerateElementsWithXPath:selectSideRule.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                movieModel*movie = [movieModel entity:element];
                movie.source = urlString;
                [array addObject:movie];
            }];
            if (successHandler) {
                successHandler(array);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            failureHandler(error);
        }
    }];
}


@end
