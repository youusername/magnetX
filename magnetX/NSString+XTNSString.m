//
//  NSString+XTNSString.m
//  magnetX
//
//  Created by finn on 2019/9/6.
//  Copyright © 2019 214644496@qq.com. All rights reserved.
//

#import "NSString+XTNSString.h"

@implementation NSString (XTNSString)
- (NSString*)clearSpace{
    
    NSString *clearStr = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return [clearStr stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end
