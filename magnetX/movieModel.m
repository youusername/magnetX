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
-(void)setName:(NSString *)name{
    if (name) {
        _name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else{
        _name = @"";
    }
}
-(void)setMagnet:(NSString *)magnet{
    if (magnet) {
        _magnet = magnet;
    }else{
        _magnet = @"";
    }
}
-(void)setSize:(NSString *)size{
    if (size) {
        _size = size;
    }else{
        _size = @"";
    }
}
-(void)setCount:(NSString *)count{
    if (count) {
        _count = count;
    }else{
        _count = @"";
    }
}
- (void)setSource:(NSString *)source{
    if (source) {
        _source = source;
    }else{
        _source = @"";
    }
}
+ (movieModel*)entity:(ONOXMLElement *)element{
    movieModel*Model = [movieModel new];
    NSString*firstMagnet = [element firstChildWithXPath:selectSideRule.magnet].stringValue;
    NSString*magnet=[firstMagnet substringWithRange:NSMakeRange(firstMagnet.length-40,40)];
    Model.magnet = [NSString stringWithFormat:@"magnet:?xt=urn:btih:%@",magnet];
    Model.name = [[element firstChildWithXPath:selectSideRule.name] stringValue];
    Model.size = [element firstChildWithXPath:selectSideRule.size].stringValue;
    Model.count = [element firstChildWithXPath:selectSideRule.count].stringValue;
//    Model.source =selectSideRule.site;
    return Model;
}












@end
