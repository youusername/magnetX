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

    [self getGithubHtml];

    // Do view setup here.
}

- (void)getGithubHtml{
    [[breakDownHtml downloader]downloadHtmlURLString:MagnetXUpdateAppURL willStartBlock:^{
        
    } success:^(NSData *data) {
        
        githubHtmlData = data;
        [self getNewVersion];
    } failure:^(NSError *error) {
        
    }];
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
- (IBAction)updateAPP:(id)sender {
    NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/youusername/magnetX/releases/download/%@/magnetX.dmg",githubVersion]];
    NSLog(@"url_%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager*manager     = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *downloadDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSLog(@"downloadDirectoryURL_%@",downloadDirectoryURL);
        NSLog(@"AppendingPathComponent_%@",[downloadDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);
           return [downloadDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];

        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                                                  NSString *fileName = [response suggestedFilename];
            NSLog(@"fileName__%@",fileName);
            NSLog(@"filePath_%@",filePath);
//            [[MagnetXNotification] postUserNotificationWithFileName:fileName];

            NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
            [workspace openFile:[filePath path]];
        }];

    [downloadTask resume];

    
}

@end
