//
//  movieModel.h
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ono.h"
extern sideModel *selectSideRule;

@interface movieModel : NSObject
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* size;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* source;
@property (nonatomic,strong)NSString* magnet;
+ (movieModel*)entity:(ONOXMLElement *)element;
@end
