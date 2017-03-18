//
//  UserEditorStatus.h
//  magnetX
//
//  Created by zhangjing on 2017/3/18.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEditorStatus : NSObject
+ (UserEditorStatus *)sharedWorkspace;
///用于判断文件是否被修改过
@property (nonatomic,strong) NSString* jsonFileMD5;
+ (NSString*)getJsonFilePath;
@end
