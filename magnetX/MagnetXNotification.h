//
//  MagnetXNotification.h
//  magnetX
//
//  Created by 张靖 on 16/10/22.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MagnetXNotification : NSObject
+ (void)postNotificationName:(NSString *) name;
+ (void)postNotificationName:(NSString *)name userInfo:(id)info;
+ (void)postNotificationName:(NSString *)name object:(id)object;
+ (void)postNotificationName:(NSString *)name object:(id)object userInfo:(id)info;
+ (void)addObserver:(id)object selector:(SEL) selector name:(NSString *)name;

@end
