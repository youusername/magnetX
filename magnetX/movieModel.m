//
//  movieModel.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "movieModel.h"
NSString* beseURL;
@implementation movieModel
+ (movieModel*)entity:(ONOXMLElement *)element{
    movieModel*Model = [[movieModel alloc]init];
    NSString*magnet=[[element firstChildWithXPath:@"//div[@class='dInfo']"].stringValue substringWithRange:NSMakeRange(6,40)];
    Model.magnet = [NSString stringWithFormat:@"magnet:?xt=urn:btih:%@",magnet];
    Model.name = [element.children[0] stringValue];
    Model.size = [[[[element children][1] children][0] children][0] stringValue];
    Model.count = [[[[element children][1] children][0] children][1] stringValue];
    Model.source = [[beseURL substringFromIndex:7] componentsSeparatedByString:@"/"][0];
    return Model;
}
@end
