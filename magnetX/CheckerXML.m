//
//  CheckerXML.m
//  magnetX
//
//  Created by phlx-mac1 on 2016/12/5.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "CheckerXML.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerStreamedResponse.h"
#import <Sparkle/Sparkle.h>

#define xmlPath [[NSBundle mainBundle] pathForResource:@"update" ofType:@"xml"]

@interface CheckerXML(){
    NSString*length;
    NSString*shortVersion;
    NSString*description;
    NSString*nowDate;
    NSString *xml;
}

@end

@implementation CheckerXML


- (void)checkUPDateXML{
//    NSString*url = xmlPath;
//    NSString *xml = [NSString stringWithContentsOfFile:url encoding:NSUTF8StringEncoding error:nil];

    [[breakDownHtml downloader]downloadHtmlURLString:MagnetXUpdateAppURL willStartBlock:^{
        
    } success:^(NSData *data) {
        ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
        shortVersion = [doc firstChildWithXPath:@"//span[@class='css-truncate-target']"].stringValue;
        length = [doc firstChildWithXPath:@"//small[@class='text-gray float-right']"].stringValue;
        length = [length componentsSeparatedByString:@" "][0];
        
        description = [doc firstChildWithXPath:@"//div[@class='markdown-body']"].stringValue;
//        nowDate = [doc firstChildWithXPath:@"//relative-time//@datetime"].stringValue;
        nowDate = @"Sun Oct 30 2016 08:55:45 GMT+0800 (CST)";
        self.checkXml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><rss version=\"2.0\" xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\"><channel><title>magnetX</title><link>http://127.0.0.1:8080/</link><description>%@</description><language>zh-CN</language><item><title>AutoUpdate</title><sparkle:releaseNotesLink></sparkle:releaseNotesLink><pubDate>%@</pubDate><enclosure url=\"https://github.com/youusername/magnetX/releases/download/%@/magnetX.app.zip\" sparkle:version=\"%@\" sparkle:shortVersionString=\"%@\" length=\"%@\" type=\"application/octet-stream\" sparkle:dsaSignature=\"\" /><sparkle:minimumSystemVersion>10.10</sparkle:minimumSystemVersion></item></channel></rss>",description,nowDate,shortVersion,shortVersion,shortVersion,length];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self update];
        });
        
    } failure:^(NSError *error) {
        
    }];

}
- (void)update{
    [GCDWebServer setLogLevel:2];
    GCDWebServer* webServer = [[GCDWebServer alloc] init];
    [webServer addDefaultHandlerForMethod:@"GET"
                             requestClass:[GCDWebServerRequest class]
                        asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                GCDWebServerDataResponse* response = [GCDWebServerDataResponse responseWithHTML:self.checkXml];
                                completionBlock(response);
//                            });
                        }];
    [webServer startWithPort:8080 bonjourName:nil];
    
    [[SUUpdater sharedUpdater] checkForUpdates:nil];
}


@end
