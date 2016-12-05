//
//  CheckerXML.m
//  magnetX
//
//  Created by phlx-mac1 on 2016/12/5.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "CheckerXML.h"
#define xmlPath [[NSBundle mainBundle] pathForResource:@"update" ofType:@"xml"]
@implementation CheckerXML
- (NSString*)getXML{
    NSString *url = xmlPath;
    NSString *xml = [NSString stringWithContentsOfFile:url encoding:NSUTF8StringEncoding error:nil];
    return xml;
}
- (void)checkUPDateXML{
    NSString*url = xmlPath;
    NSString *xml = [NSString stringWithContentsOfFile:url encoding:NSUTF8StringEncoding error:nil];

    if (xml.length<100) {
        xml = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><rss version=\"2.0\" xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\"><channel><title>magnetX</title><link>http://127.0.0.1:8080/</link><description></description><language>zh-CN</language><item><title>AutoUpdate</title><sparkle:releaseNotesLink></sparkle:releaseNotesLink><pubDate>Sun Oct 30 2016 08:55:45 GMT+0800 (CST)</pubDate><enclosure url=\"https://github.com/youusername/magnetX/releases/download/1.1/magnetX.dmg\" sparkle:shortVersionString=\"1.1\" length=\"4029952\" type=\"application/octet-stream\" sparkle:dsaSignature=\"\" /><sparkle:minimumSystemVersion>10.10</sparkle:minimumSystemVersion></item></channel></rss>";
        [xml writeToFile:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        
        [[breakDownHtml downloader]downloadHtmlURLString:MagnetXUpdateAppURL willStartBlock:^{
            
        } success:^(NSData *data) {

        } failure:^(NSError *error) {
            
        }];
        
        NSString*length;
        NSString*shortVersion;
        NSString*description;
        NSDate*nowDate;
        
        xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><rss version=\"2.0\" xmlns:sparkle=\"http://www.andymatuschak.org/xml-namespaces/sparkle\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\"><channel><title>magnetX</title><link>http://127.0.0.1:8080/</link><description>%@</description><language>zh-CN</language><item><title>AutoUpdate</title><sparkle:releaseNotesLink></sparkle:releaseNotesLink><pubDate>%@</pubDate><enclosure url=\"https://github.com/youusername/magnetX/releases/download/%@/magnetX.dmg\" sparkle:shortVersionString=\"%@\" length=\"%@\" type=\"application/octet-stream\" sparkle:dsaSignature=\"\" /><sparkle:minimumSystemVersion>10.10</sparkle:minimumSystemVersion></item></channel></rss>",description,nowDate,shortVersion,shortVersion,length];
        [xml writeToFile:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
@end
