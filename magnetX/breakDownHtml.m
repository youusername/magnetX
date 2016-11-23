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
- (void)downloadHtmlURLString:(NSString *)urlString willStartBlock:(void(^)()) startBlock success:(void(^)(NSData*data)) successHandler failure:(void(^)(NSError *error)) failureHandler{
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_async(dispatch_queue_create("download html queue", nil), ^{
//            NSMutableArray*array = [NSMutableArray new];
//            ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
//            [doc enumerateElementsWithXPath:selectSideRule.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
//                movieModel*movie = [movieModel entity:element];
//                movie.source = urlString;
//                [array addObject:movie];
//            }];
//            if (successHandler) {
//                successHandler(array);
//            }
//        });
//    }];
//    [dataTask resume];
    if (startBlock) {
        startBlock();
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_queue_create("download html queue", nil), ^{
            
            if (successHandler) {
                successHandler(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            failureHandler(error);
        }
    }];
}


@end
