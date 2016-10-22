//
//  movieModel.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "movieModel.h"
sideModel *selectSideRule;

@implementation movieModel
+ (movieModel*)entity:(ONOXMLElement *)element{
    movieModel*Model = [movieModel new];
    NSString*firstMagnet = [element firstChildWithXPath:selectSideRule.magnet].stringValue;
    NSString*magnet=[firstMagnet substringWithRange:NSMakeRange(firstMagnet.length-40,40)];
    Model.magnet = [NSString stringWithFormat:@"magnet:?xt=urn:btih:%@",magnet];
    Model.name = [[element firstChildWithXPath:selectSideRule.name] stringValue];
    Model.size = [element firstChildWithXPath:selectSideRule.size].stringValue;
    Model.count = [element firstChildWithXPath:selectSideRule.count].stringValue;
    Model.source =selectSideRule.site;
    return Model;
}












@end
