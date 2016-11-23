//
//  UPDateApplicationViewController.h
//  magnetX
//
//  Created by zhangjing on 2016/11/23.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UPDateApplicationViewController : NSViewController{
    NSString*version;
    NSString*githubVersion;
}
@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSTextField *githubVersionLabel;
@property (weak) IBOutlet NSLevelIndicator *level;
@property (weak) IBOutlet NSButton *downButton;

@end
