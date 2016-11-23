//
//  UPDateApplicationViewController.m
//  magnetX
//
//  Created by zhangjing on 2016/11/23.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "UPDateApplicationViewController.h"

@interface UPDateApplicationViewController (){
    NSData*githubHtmlData;
}

@end

@implementation UPDateApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    version=MagnetXVersionString;
    self.versionLabel.stringValue = [NSString stringWithFormat:@"当前版本:V%@",version];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 耗时的操作
        [self getGithubHtml];

//    });
    
    // Do view setup here.
}
- (void)getNewVersion{
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:githubHtmlData error:nil];
    [doc enumerateElementsWithXPath:@"//span[@class='css-truncate-target']" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            githubVersion=element.stringValue;
        self.githubVersionLabel.stringValue = [NSString stringWithFormat:@"最新版本:V%@",githubVersion];

        if (githubVersion.floatValue>version.floatValue) {
            
            
            
        }else{
            self.githubVersionLabel.hidden = YES;
        }
        *stop= YES;
    }];
    
}
- (void)getGithubHtml{
    [[breakDownHtml downloader]downloadHtmlURLString:MagnetXUpdateAppURL willStartBlock:^{
        
    } success:^(NSData *data) {
        
        githubHtmlData = data;
        [self getNewVersion];
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)updateAPP:(id)sender {
    

    
}

@end
