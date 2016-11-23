//
//  breakDownHtml.h
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
extern sideModel *selectSideRule;

@interface breakDownHtml : NSObject
+ (breakDownHtml *)downloader;
- (void)downloadHtmlURLString:(NSString *)urlString willStartBlock:(void(^)()) startBlock success:(void(^)(NSData*data)) successHandler failure:(void(^)(NSError *error)) failureHandler;

@end
