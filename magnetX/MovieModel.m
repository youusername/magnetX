//
//  movieModel.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "MovieModel.h"
sideModel *selectSideRule;
@implementation MovieModel
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
+ (MovieModel*)entity:(ONOXMLElement *)element{
    MovieModel*Model = [MovieModel new];
    NSString*firstMagnet = [element firstChildWithXPath:selectSideRule.magnet].stringValue;
    if ([firstMagnet hasSuffix:@".html"]) {
        firstMagnet = [firstMagnet stringByReplacingOccurrencesOfString:@".html"withString:@""];
    }
    if ([firstMagnet componentsSeparatedByString:@"&"].count>1) {
        firstMagnet = [firstMagnet componentsSeparatedByString:@"&"][0];
    }
    NSString*magnet=[firstMagnet substringWithRange:NSMakeRange(firstMagnet.length-40,40)];
    Model.magnet = [NSString stringWithFormat:@"magnet:?xt=urn:btih:%@",magnet];
    Model.name = [[element firstChildWithXPath:selectSideRule.name] stringValue];
    Model.size = [[element firstChildWithXPath:selectSideRule.size] stringValue];
    Model.count = [[element firstChildWithXPath:selectSideRule.count] stringValue];
//    Model.source =selectSideRule.site;
    return Model;
}

+ (NSArray*)HTMLDocumentWithData:(NSData*)data{
    NSMutableArray*array = [NSMutableArray new];
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
    [doc enumerateElementsWithXPath:selectSideRule.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        MovieModel*movie = [MovieModel entity:element];
//        movie.source = url;
        [array addObject:movie];
    }];
    return array;
}
+ (NSArray*)resultAnalysisFormString:(NSString*)htmlString{
    NSMutableArray *resultArray = [NSMutableArray array];
    //电驴搜索结果
    NSString * regulaStr = @"ed2k://.*.\\|\\/";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    [resultArray addObjectsFromArray:[self matchesGetModel:arrayOfAllMatches htmlString:htmlString isEd2k:YES]];
    
    
    //磁力搜索结果
    regulaStr = @"magnet:?[^\"]+";
    regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    NSArray * magnetArray = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    if (magnetArray.count != 0) {
        [resultArray addObjectsFromArray:[self matchesGetModel:magnetArray htmlString:htmlString isEd2k:NO]];
    }
    
    if (resultArray.count == 0) {
        NSLog(@"搜索不动任何结果");
    }
    
    return resultArray;
}

+ (NSArray*)resultAnalysis:(NSData*)htmlData{
    
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    return [self resultAnalysisFormString:htmlString];
}
+ (NSMutableArray *)matchesGetModel:(NSArray *)arrayOfAllMatches htmlString:(NSString *)htmlString isEd2k:(BOOL)isEd2k{
    NSMutableArray * resultArray = [NSMutableArray new];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        
        NSRange range = match.range;
        range.location = 1;
        NSString* substringForMatch = [htmlString substringWithRange:match.range];
        
        //清除不正常的数据
        if (!isEd2k) {
            if (![substringForMatch hasPrefix:@"magnet:?xt="]) {
                continue;
            }
            substringForMatch = [substringForMatch substringToIndex:60];
        }else{
            if (![substringForMatch hasPrefix:@"ed2k:"]) {
                continue;
            }
        }
        
        MovieModel *model = [MovieModel new];
        model.magnet = substringForMatch;
        
        NSString * name = @"";
        if (isEd2k) {
            name = [self searchEd2kName:substringForMatch];
        }else{
            name = substringForMatch;
        }
        model.name      = name;
        model.size      = @"";
        model.source    = @"";
        model.count     = @"";
        [resultArray addObject:model];
    }
    return resultArray;
}
+ (NSString*)searchEd2kName:(NSString*)ed2k{
    //    查找ed2k文件名
    NSArray*strClearArray=[ed2k componentsSeparatedByString:@"|"];
    if (strClearArray.count<2) {
        return ed2k;
    }else{
        NSString*name=[strClearArray[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (name.length<2) {
            //            防止
            return ed2k;
        }else{
            return name;
        }
    }
}
@end
