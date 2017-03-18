//
//  UserEditorStatus.m
//  magnetX
//
//  Created by zhangjing on 2017/3/18.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "UserEditorStatus.h"

@implementation UserEditorStatus
-(instancetype)init{
    self = [super init];
    if (self) {
        self.jsonFileMD5 = @"1";
    }
    return self;
}
+ (UserEditorStatus *)sharedWorkspace{
    static UserEditorStatus *downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[UserEditorStatus alloc] init];
    });
    return downloader;
}
+(NSString*)getJsonFilePath{
    NSString *url = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/rule-master/rule.json"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        return url;
    }else{
        url = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@"json"];
        return url;
    }
    
}
@end
