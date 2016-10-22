//
//  SideViewController.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "SideViewController.h"
//#import "DMHYCoreDataStackManager.h"

@interface SideViewController ()<NSTableViewDataSource, NSTableViewDelegate, NSSplitViewDelegate>


@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong  ) NSMutableArray *sites;

@end

@implementation SideViewController

@synthesize managedObjectContext = _context;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableViewData];
    [self observeNotification];

    extern sideModel *selectSideRule;
    selectSideRule = self.sites[0];
}
- (void)setupTableViewData{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"rule" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray*array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.sites = [NSMutableArray new];
    
    for (NSDictionary *dic in array) {
        sideModel *side = [sideModel new];
        side.site = dic[@"site"];
        side.group= dic[@"group"];
        side.name = dic[@"name"];;
        side.size = dic[@"size"];;
        side.waiting= dic[@"waiting"];
        side.count  = dic[@"count"];;
        side.source = dic[@"source"];;
        side.magnet = dic[@"magnet"];;
        [self.sites addObject:side];
    }
    [self changeSelectRuleOfIndex:0];
    [self.tableView reloadData];
}
- (void)changeSelectRuleOfIndex:(NSInteger)index{
    if (index<0) {
        return;
    }
    selectSideRule = self.sites[index];
    [MagnetXNotification postNotificationName:MagnetXSiteChangeKeywordNotification object:selectSideRule];
    [MagnetXNotification postNotificationName:MagnetXStartAnimatingProgressIndicator object:nil];
}
#pragma mark - Notification

- (void)observeNotification {
}
#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.sites.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    sideModel *side = self.sites[row];
    
    if ([identifier isEqualToString:@"siteCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"siteCell" owner:self];
        cellView.textField.stringValue = side.site;
        return cellView;
    }

    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self changeSelectRuleOfIndex:self.tableView.selectedRow];
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

@end
