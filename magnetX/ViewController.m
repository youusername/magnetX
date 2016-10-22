//
//  ViewController.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "ViewController.h"
#import "movieModel.h"
#import "breakDownHtml.h"
#import "nameTableCellView.h"

@interface ViewController()<NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField *searchTextField;
@property (weak) IBOutlet NSProgressIndicator *indicator;
@property (weak) IBOutlet NSTextField *info;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray<movieModel*> *magnets;
@property (nonatomic, strong) NSString  *searchURLString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeNotification];
    [self setupSearchText];
    // Do any additional setup after loading the view.
}
#pragma mark - Notification

- (void)observeNotification {
    [MagnetXNotification addObserver:self selector:@selector(changeKeyword) name:MagnetXSiteChangeKeywordNotification];
    [MagnetXNotification addObserver:self selector:@selector(startAnimatingProgressIndicator) name:MagnetXStartAnimatingProgressIndicator];
    [MagnetXNotification addObserver:self selector:@selector(stopAnimatingProgressIndicator) name:MagnetXStopAnimatingProgressIndicator];
}
- (void)changeKeyword{

    [self.magnets removeAllObjects];
    NSString*beseURL = [selectSideRule.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.searchTextField.stringValue];
    self.magnets = [breakDownHtml breakDownHtmlToUrl:[beseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.magnets.count>0) {
        [self reloadDataAndStopIndicator];
    }else{
        [self setErrorInfoAndStopIndicator];
    }


}
//- (void)resetData {
//    [self.magnets removeAllObjects];
//    [self.tableView reloadData];
//}
- (void)setupSearchText{
    NSArray*searchText = @[@"武媚娘传奇",@"冰与火之歌",@"心花路放",@"猩球崛起",@"行尸走肉",@"分手大师",@"敢死队3"];
    self.searchTextField.stringValue = searchText[arc4random() % 7];
    
    [self changeKeyword];
    [self reloadDataAndStopIndicator];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)setupData:(id)sender {
    
    if (![sender isKindOfClass:[ViewController class]]) {
        return;
    }
    [self changeKeyword];
    
    
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.magnets.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    movieModel *torrent = self.magnets[row];
    if ([identifier isEqualToString:@"nameCell"]) {
        nameTableCellView *cellView   = [tableView makeViewWithIdentifier:@"nameCell" owner:self];
        cellView.textField.stringValue = torrent.name;
        return cellView;
    }
    if ([identifier isEqualToString:@"sizeCell"]) {
        NSTableCellView *cellView      = [tableView makeViewWithIdentifier:@"sizeCell" owner:self];
        cellView.textField.stringValue = torrent.size;
        return cellView;
    }
    if ([identifier isEqualToString:@"countCell"]) {
        NSTableCellView *cellView      = [tableView makeViewWithIdentifier:@"countCell" owner:self];
        cellView.textField.stringValue = torrent.count;
        return cellView;
    }
    if ([identifier isEqualToString:@"sourceCell"]) {
        NSTableCellView *cellView      = [tableView makeViewWithIdentifier:@"sourceCell" owner:self];
        cellView.textField.stringValue = torrent.source;
        return cellView;
    }
    if ([identifier isEqualToString:@"magnetCell"]) {
        NSTableCellView *cellView      = [tableView makeViewWithIdentifier:@"magnetCell" owner:self];
        cellView.textField.stringValue = torrent.magnet;
        return cellView;
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSLog(@"self.tableView.selectedRow__%ld",self.tableView.selectedRow);
}

#pragma mark - Table View Context Menu Delegate

//- (NSMenu *)tableView:(NSTableView *)aTableView menuForRows:(NSIndexSet *)rows {
//    NSMenu *rightClickMenu = [[NSMenu alloc] initWithTitle:@""];
//    NSMenuItem *openItem = [[NSMenuItem alloc] initWithTitle:@"打开介绍页面"
//                                                      action:@selector(openTorrentLink:)
//                                               keyEquivalent:@""];
//    NSMenuItem *downloadItem = [[NSMenuItem alloc] initWithTitle:@"下载"
//                                                          action:@selector(queryDownloadURL:)
//                                                   keyEquivalent:@""];
//    [rightClickMenu addItem:openItem];
//    [rightClickMenu addItem:downloadItem];
//    return rightClickMenu;
//}

#pragma mark - Indicator and reload table view data

- (void)reloadDataAndStopIndicator {
    [self stopAnimatingProgressIndicator];
    [self.tableView reloadData];
    self.info.stringValue = @"加载完成!";
}

- (void)setErrorInfoAndStopIndicator {
    self.info.stringValue = @"请检查网络，或者等一下再刷新";
    [self stopAnimatingProgressIndicator];
}
#pragma mark - ProgressIndicator

- (void)startAnimatingProgressIndicator {
    [self.indicator startAnimation:self];
    self.info.stringValue = @"";
}

- (void)stopAnimatingProgressIndicator {
    [self.indicator stopAnimation:self];
}

@end
