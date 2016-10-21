//
//  SideViewController.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/20.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "SideViewController.h"
//#import "DMHYCoreDataStackManager.h"

@interface SideViewController ()


@property (weak) IBOutlet NSOutlineView *outlineView;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong  ) NSMutableArray *keywords;
//@property (nonatomic, strong) DMHYSite *site;

@end

@implementation SideViewController

@synthesize managedObjectContext = _context;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeNotification];
    [self setupPopupButtonData];
    [self expandOutlineViewItem];
    [self setupMenuItems];
}

- (void)expandOutlineViewItem {
    for (int i = 0 ; i < self.keywords.count; i++) {
        [self.outlineView expandItem:self.keywords[i]];
    }
}

#pragma mark - IBAction


//- (IBAction)siteChanged:(NSPopUpButton *)sender {
//    NSMenuItem *item = [self.sitesPopUpButton selectedItem];
//    NSInteger selectIndex = [self.sitesPopUpButton indexOfItem:item];
//    DMHYSite *site = [[[DMHYCoreDataStackManager sharedManager] allSites] objectAtIndex:selectIndex];
//    self.site = site;
//    self.keywords = nil;
//    [self reloadData];
//    [DMHYNotification postNotificationName:DMHYSearchSiteChangedNotification object:site];
//}

#pragma mark - Setup Data

- (void)setupPopupButtonData {
//    NSMutableArray *siteNames = [[NSMutableArray alloc] init];
//    NSArray<DMHYSite *> *sites = [[DMHYCoreDataStackManager sharedManager] allSites];
//    [sites enumerateObjectsUsingBlock:^(DMHYSite * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [siteNames addObject:obj.name];
//    }];
//    [self.sitesPopUpButton addItemsWithTitles:siteNames];
//    [self.sitesPopUpButton selectItemWithTitle:self.site.name];
}

- (void)setupMenuItems {
    NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
    NSMenuItem *editMenuItem = [mainMenu itemWithTitle:@"Edit"];
    NSMenu *editSubMenu = [editMenuItem submenu];
    unichar deleteKey = NSBackspaceCharacter;
    NSString *delete = [NSString stringWithCharacters:&deleteKey length:1];
    NSMenuItem *removeSubKeywordMenuItem = [[NSMenuItem alloc] initWithTitle:@"删除关键字"
                                                                      action:@selector(deleteSubKeyword)
                                                               keyEquivalent:delete];
    [editSubMenu addItem:removeSubKeywordMenuItem];
}

#pragma mark - NSOutlineViewDataSource

//- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(DMHYKeyword *) item {
//    return !item ? [self.keywords count] : [item.subKeywords count];
//    return 5;
//}

//- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(DMHYKeyword *)item {
//    return !item ? YES : [item.subKeywords count] != 0;
//}

//- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(DMHYKeyword *)item {
//    NSLog(@"item -> keyword %@",item.keyword);
//    NSArray *subKeywords = [item.subKeywords allObjects];
//    return !item ? self.keywords[index] : subKeywords[index];
//}

//- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
//    DMHYKeyword *weekday = item;
//    NSString *identifier = tableColumn.identifier;
//    if ([identifier isEqualToString:@"Keyword"]) {
//        return weekday.keyword;
//    }
//    return nil;
//}

//- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
//    DMHYKeyword *keyword = item;
//    NSString *newKeyword = object;
//    
//    if (!keyword.isSubKeyword.boolValue || [newKeyword isEqualToString:@""]) {
//        return;
//    }
//    
//    NSString *identifier = tableColumn.identifier;
//    if ([identifier isEqualToString:@"Keyword"]) {
//        keyword.keyword = newKeyword;
//        [self saveData];
//    }
//}

#pragma mark - NSOutlineViewDelegate

//- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
//    DMHYKeyword *selectedKeyword = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
//    NSString *keyword = selectedKeyword.keyword;
//    if (!selectedKeyword.isSubKeyword.boolValue || keyword.length == 0) {
//        return;
//    }
//    NSNumber *isSubKeyword = selectedKeyword.isSubKeyword;
//    NSDictionary *userInfo = @{kSelectKeyword             : keyword,
//                               kSelectKeywordIsSubKeyword : isSubKeyword};
//    [DMHYNotification postNotificationName:DMHYSelectKeywordChangedNotification object:selectedKeyword userInfo:userInfo];
//}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
    return YES;
}

//- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
//    return ((DMHYKeyword *)item).isSubKeyword.boolValue ? YES : NO;
//}

#pragma mark - NSSplitViewDelegate

- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
    return NSRectFromCGRect(CGRectZero);
}

#pragma mark - Notification

- (void)observeNotification {
//    [DMHYNotification addObserver:self selector:@selector(handleSeedDataComplete) name:DMHYSeedDataCompletedNotification];
//    [DMHYNotification addObserver:self selector:@selector(handleThemeChanged) name:DMHYThemeChangedNotification];
//    [DMHYNotification addObserver:self selector:@selector(handleKeywordAdded:) name:DMHYKeywordAddedNotification];
//    [DMHYNotification addObserver:self selector:@selector(handleSiteAdded) name:DMHYSiteAddedNotification];
}

- (void)handleSiteAdded {
    [self reset];
    [self setupPopupButtonData];
}

- (void)handleKeywordAdded:(NSNotification *)notification {
//    DMHYSite *site = notification.object;
//    if ([site.name isEqualToString:self.site.name]) {
//        self.site = site;
//        self.keywords = nil;
//        [self reloadData];
//    }
}

- (void)reset {
//    self.site = nil;
    self.keywords = nil;
    [self reloadData];
}

- (void)handleSeedDataComplete {
    [self reset];
    [self setupPopupButtonData];
}

- (void)handleThemeChanged {
    [self.view setNeedsDisplay:YES];
}

#pragma mark - MenuItem

- (void)deleteSubKeyword {
    NSInteger selectKeywordIndex = [self.outlineView selectedRow];
//    DMHYKeyword *keyword = [self.outlineView itemAtRow:selectKeywordIndex];
//    if ([keyword.isSubKeyword boolValue]) {
//        DMHYKeyword *parentKeyword = [self.outlineView parentForItem:keyword];
//        [parentKeyword removeSubKeywordsObject:keyword];
//        [self.managedObjectContext deleteObject:keyword];
//        [self saveData];
//        [self reloadData];
//        [DMHYNotification postNotificationName:DMHYDatabaseChangedNotification];
//    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    NSString *title = [menuItem title];
    if ([title isEqualToString:@"删除关键字"]) {
        //什么都没选的时候
        if (self.outlineView.selectedRow == -1) {
            return NO;
        }
//        DMHYKeyword *keyword = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
//        //记得使用 boolValue 获取 BOOL 值 >_<
//        if (![keyword.isSubKeyword boolValue]) {
//            return NO;
//        }
    }
    return YES;
}

#pragma mark - Properties

- (NSMutableArray *)keywords {

    if (!_keywords) {
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSubKeyword != YES"];
//        NSArray *weekdayKeywords = [[self.site.keywords allObjects] filteredArrayUsingPredicate:predicate];
//        _keywords = [[weekdayKeywords sortedArrayUsingDescriptors:@[sortDesc]] mutableCopy];
    }
    return _keywords;
}

//- (DMHYSite *)site {
//    if (!_site) {
//        _site = [[DMHYCoreDataStackManager sharedManager] currentUseSite];
//    }
//    return _site;
//}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_context) {
//        _context = [[DMHYCoreDataStackManager sharedManager] managedObjectContext];
    }
    return _context;
}

#pragma mark - Utils

- (void)saveData {
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]) {
        if (![self.managedObjectContext save:&error]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"删除关键字时出现错误"];
            [alert setInformativeText:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
            [alert addButtonWithTitle:@"OK"];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                if (returnCode == NSAlertFirstButtonReturn) {
                    
                }
            }];
        }
    }
}

- (void)reloadData {
    [self.outlineView reloadData];
    [self expandOutlineViewItem];
}

@end
