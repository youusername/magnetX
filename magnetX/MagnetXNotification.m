//
//  MagnetXNotification.m
//  magnetX
//
//  Created by 张靖 on 16/10/22.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "MagnetXNotification.h"

@implementation MagnetXNotification
+ (void)postNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

+ (void)postNotificationName:(NSString *)name userInfo:(id)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:info];
}

+ (void)postNotificationName:(NSString *)name object:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

+ (void)postNotificationName:(NSString *)name object:(id)object userInfo:(id)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:info];
}

+ (void)addObserver:(id)object selector:(SEL)selector name:(NSString *)name {
    [[NSNotificationCenter defaultCenter] addObserver:object
                                             selector:selector
                                                 name:name
                                               object:nil];
}

@end
