//
//  ViewController.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "ViewController.h"
#import "MovieModel.h"
#import "breakDownHtml.h"

#import "NSTableView+ContextMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>
#import "MLHudAlert.h"
#import "AppDelegate.h"

@interface ViewController()<NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate,ContextMenuDelegate,WKUIDelegate,WKNavigationDelegate>

@property (weak) IBOutlet NSTextField *searchTextField;
@property (weak) IBOutlet NSProgressIndicator *indicator;
@property (weak) IBOutlet NSTextField *info;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray<MovieModel*> *magnets;
@property (nonatomic, strong) NSString  *searchURLString;
@property (nonatomic, strong) WKWebView*web;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    
//    [self setupTableViewDoubleAction];
    // Do any additional setup after loading the view.
}
#pragma mark - Notification

- (void)observeNotification {
    [MagnetXNotification addObserver:self selector:@selector(changeKeyword) name:MagnetXSiteChangeKeywordNotification];
    [MagnetXNotification addObserver:self selector:@selector(startAnimatingProgressIndicator) name:MagnetXStartAnimatingProgressIndicator];
    [MagnetXNotification addObserver:self selector:@selector(stopAnimatingProgressIndicator) name:MagnetXStopAnimatingProgressIndicator];
    [MagnetXNotification addObserver:self selector:@selector(makeFirstResponder) name:MagnetXMakeFirstResponder];
}
- (void)config{
    self.magnets = [NSMutableArray new];
    self.page = 1;
    self.isLoading = NO;
    
    [self observeNotification];
    [self setupSearchText];
    
    self.web =[[WKWebView alloc]initWithFrame:CGRectZero];
    self.web.UIDelegate = self;
    self.web.navigationDelegate = self;
    [self.view addSubview:self.web];
    
}
- (void)makeFirstResponder{
    [[self.searchTextField window] makeFirstResponder:self.searchTextField];
}
- (IBAction)hideSideVC:(NSButton*)sender {
    [MagnetXNotification postNotificationName:@"hideSideView"];
}
- (NSString*)createGetHTMLJavaScript{
    NSString *js = @"document.getElementsByTagName('html')[0].innerHTML";
    return js;
    
}
#pragma mark - WKNavigationDelegate
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"Commit");
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"Start");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"Finish");
    NSString *jsToGetHTMLSource =  [self createGetHTMLJavaScript];
    
    @WEAKSELF(self);
    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLSource, NSError * _Nullable error) {
        
        [selfWeak.magnets addObjectsFromArray:[MovieModel resultAnalysisFormString:HTMLSource]];
        if (selfWeak.magnets.count>0) {
            [selfWeak reloadDataAndStopIndicator];
        }else{
            [selfWeak setErrorInfoAndStopIndicator:@"源网站没有数据,切换其它源试试！"];
        }
    }];
}
- (BOOL)isURL:(NSString*)str{
    
    NSString *regexString = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    BOOL isUrl = [pred evaluateWithObject:str];
    return isUrl;
    
}

- (void)changeKeyword{

    [self resetData];
    [self startAnimatingProgressIndicator];

    __block BOOL isURL = [self isURL:self.searchTextField.stringValue];
    NSString*url = @"";
    
    if (isURL) {
        url = self.searchTextField.stringValue;
    }else{

        NSString*beseURL = [selectSideRule.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.searchTextField.stringValue];
        beseURL = [beseURL stringByReplacingOccurrencesOfString:@"PPP" withString:[NSString stringWithFormat:@"%ld",self.page]];
        url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    }
    
//    if (isURL) {
//
//        if ([url hasPrefix:@"https"]) {
//            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//        }else{
//            [self downHtmlString:url isUrl:isURL];
//        }
//
//    }else{
        [self downHtmlString:url isUrl:isURL];
//    }

}

- (void)downHtmlString:(NSString*)url isUrl:(BOOL)isURL{
    
    self.isLoading = YES;
    
    @WEAKSELF(self);
    [[breakDownHtml downloader] downloadHtmlURLString:url willStartBlock:^{
        
    } success:^(NSData*data) {
        if (isURL) {
            [selfWeak.magnets addObjectsFromArray:[MovieModel resultAnalysis:data]];
        }else{

            [selfWeak.magnets addObjectsFromArray:[MovieModel HTMLDocumentWithData:data]];
        }
        
        
        if (selfWeak.magnets.count>0) {
            [selfWeak reloadDataAndStopIndicator];
        }else{
            [selfWeak setErrorInfoAndStopIndicator:@"源网站没有数据,切换其它源试试！"];
        }
        selfWeak.isLoading = NO;
    } failure:^(NSError *error) {
        [selfWeak setErrorInfoAndStopIndicator:@"请检查网络，或者等一下再刷新"];
        selfWeak.isLoading = NO;
    }];
}

- (void)resetData {
    self.page = 1;
    [self.magnets removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{

    [self.tableView reloadData];
    });
}
- (void)setupSearchText{
    NSArray*searchText = @[@"王牌特工",@"星球大战",@"异形",@"冰与火之歌",@"心花路放",@"猩球崛起",@"行尸走肉",@"分手大师",@"敢死队",@"血族",@"银翼杀手",@"猎凶风河谷",@"暗杀教室",@"我的战争",@"海底总动员",@"咖啡公社"];
    self.searchTextField.stringValue = searchText[arc4random() % searchText.count];
    
    [self changeKeyword];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)setupData:(id)sender {
    
//    if (![sender isKindOfClass:[ViewController class]]) {
//        return;
//    }
    [self changeKeyword];

}
- (void)openUrlLink:(id)sender {
    NSInteger row = -1;
    if ([sender isKindOfClass:[NSButton class]]) {
        row = [self.tableView rowForView:sender];
    } else {
        row = self.tableView.selectedRow;
    }
    
    if (row<0) {
        return;
    }
    NSString*beseURL = [selectSideRule.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.searchTextField.stringValue];
    beseURL = [beseURL stringByReplacingOccurrencesOfString:@"PPP" withString:[NSString stringWithFormat:@"%ld",self.page]];
    NSString*url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL*toURL =[NSURL URLWithString:url];
        [self openMagnetWith:toURL];
    });
}
- (void)copyToPasteboard:(id)sender{
    NSInteger row = -1;
    if ([sender isKindOfClass:[NSButton class]]) {
        row = [self.tableView rowForView:sender];
    } else {
        row = self.tableView.selectedRow;
    }
    
    if (row<0) {
        return;
    }
    MovieModel *torrent = self.magnets[row];
    NSPasteboard*pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [pasteboard setString:torrent.magnet forType:NSStringPboardType];
}
- (IBAction)queryDownloadMagnet:(id)sender {
    NSInteger row = -1;
    if ([sender isKindOfClass:[NSButton class]]) {
        row = [self.tableView rowForView:sender];
    } else {
        row = self.tableView.selectedRow;
    }
    
    if (row<0) {
        return;
    }
    MovieModel *torrent = self.magnets[row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL*url =[NSURL URLWithString:torrent.magnet];
        [self openMagnetWith:url];
    });
}
- (void)openMagnetWith:(NSURL *)magnet {
    [[NSWorkspace sharedWorkspace] openURL:magnet];
}
#pragma mark - NSTextFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    if ([notification.userInfo[@"NSTextMovement"] intValue] == NSReturnTextMovement) {
        [self setupData:self];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    NSInteger count = self.magnets.count;
    if (count>0 && ![self isURL:self.searchTextField.stringValue]) {
        count+=1;
    }
    return count;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    
    if (row >= self.magnets.count) {
        if ([identifier isEqualToString:@"nameCell"]) {
            NSTableCellView *cellView = [self tableView:tableView identifier:identifier setValue:@"        点 击 加 载 更 多                点 击 加 载 更 多                点 击 加 载 更 多        "];
            cellView.textField.textColor = [NSColor redColor];
            return cellView;
        }else{
            return [self tableView:tableView identifier:identifier setValue:@""];
        }
        
    }else{
        MovieModel *torrent = self.magnets[row];
        if ([identifier isEqualToString:@"nameCell"]) {
            return [self tableView:tableView identifier:identifier setValue:torrent.name];
        }
        if ([identifier isEqualToString:@"sizeCell"]) {
            return [self tableView:tableView identifier:identifier setValue:torrent.size];
        }
        if ([identifier isEqualToString:@"countCell"]) {
            return [self tableView:tableView identifier:identifier setValue:torrent.count];
        }
        if ([identifier isEqualToString:@"sourceCell"]) {
            
            NSString * source = [self isURL:self.searchTextField.stringValue] ? @"" : selectSideRule.site;
            return [self tableView:tableView identifier:identifier setValue:source];
        }
        if ([identifier isEqualToString:@"magnetCell"]) {

            return [self tableView:tableView identifier:identifier setValue:torrent.magnet];
        }
    }
    return nil;
}

- (id)tableView:(NSTableView *)tableView identifier:(NSString*)identifier setValue:(NSString*)value{
    
    NSTableCellView *cellView      = [tableView makeViewWithIdentifier:identifier owner:self];
    cellView.textField.stringValue = value;
    cellView.textField.textColor = [NSColor blackColor];
    
    if (cellView) {
        return cellView;
        
    }else{
        return nil;
    }
    
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 30;
}

//- (void)tableViewSelectionDidChange:(NSNotification *)notification {
//    NSLog(@"self.tableView.selectedRow__%ld",self.tableView.selectedRow);
//    if (self.tableView.selectedRow>= self.magnets.count) {
//        NSLog(@"下一页");
//    }
//
//}

#pragma mark - Table View Context Menu Delegate
- (void)tableView:(NSTableView *)aTableView clickForRow:(NSInteger)row{
    if (row >= self.magnets.count && !self.isLoading) {
//        NSLog(@"下一页");
        self.page += 1;
        
        NSString*beseURL = [selectSideRule.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.searchTextField.stringValue];
        beseURL = [beseURL stringByReplacingOccurrencesOfString:@"PPP" withString:[NSString stringWithFormat:@"%ld",self.page]];
        NSString* url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [self downHtmlString:url isUrl:NO];
    }
}
- (NSMenu *)tableView:(NSTableView *)aTableView menuForRows:(NSIndexSet *)rows {
    NSMenu *rightClickMenu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem *downloadItem = [[NSMenuItem alloc] initWithTitle:@"下载"
                                                          action:@selector(queryDownloadMagnet:)
                                                   keyEquivalent:@""];
    NSMenuItem *copyMagnetItem = [[NSMenuItem alloc] initWithTitle:@"复制链接"
                                                          action:@selector(copyToPasteboard:)
                                                   keyEquivalent:@""];
    NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"打开介绍页面"
                                                      action:@selector(openUrlLink:)
                                               keyEquivalent:@""];
    NSMenuItem *playMagnet = [[NSMenuItem alloc] initWithTitle:@"在线播放"
                                                        action:@selector(playMagnet:)
                                               keyEquivalent:@""];
    if (self.tableView.selectedRow < self.magnets.count) {
        
        [rightClickMenu addItem:downloadItem];
        [rightClickMenu addItem:copyMagnetItem];
        [rightClickMenu addItem:openItem];
        [rightClickMenu addItem:playMagnet];
    }
    return rightClickMenu;
}


- (void)playMagnet:(id)sender{
    NSInteger row = -1;
    if ([sender isKindOfClass:[NSButton class]]) {
        row = [self.tableView rowForView:sender];
    } else {
        row = self.tableView.selectedRow;
    }
    
    if (row<0) {
        return;
    }

    if([[NSWorkspace sharedWorkspace] launchApplication:@"WebTorrent"]){

        MovieModel *torrent = self.magnets[row];
        NSPasteboard*pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard declareTypes:@[NSStringPboardType] owner:nil];
        [pasteboard setString:torrent.magnet forType:NSStringPboardType];
        [self openWebTorrent];

    }else{
        AppDelegate* app =(AppDelegate*)[NSApplication sharedApplication].delegate;
         [self setErrorInfoAndStopIndicator:@"请下载安装 WebTorrent"];
        [MLHudAlert alertWithWindow:app.RootWindow type:MLHudAlertTypeError message:@"未找到 WebTorrent"];
    }

}

- (void)openWebTorrent{
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"v\" using command down"];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    
    if (returnDescriptor != NULL)
    {
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
            if (cAEList == [returnDescriptor descriptorType])
            {
            }else{
                
            }
        }
    }else{
        
    }
}

#pragma mark - Indicator and reload table view data

- (void)reloadDataAndStopIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
    [self stopAnimatingProgressIndicator];
    self.info.stringValue = @"加载完成!";

    [self.tableView reloadData];
    });
}

- (void)setErrorInfoAndStopIndicator:(NSString*)string{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.info.stringValue = string;
        [self stopAnimatingProgressIndicator];
    });
}
#pragma mark - ProgressIndicator

- (void)startAnimatingProgressIndicator {
    self.indicator.hidden = NO;
    [self.indicator startAnimation:self];
    self.info.stringValue = @"努力加载中.....";
}

- (void)stopAnimatingProgressIndicator {
    self.indicator.hidden = YES;
    [self.indicator stopAnimation:self];
}

@end
