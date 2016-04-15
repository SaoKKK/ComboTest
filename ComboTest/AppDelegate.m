//
//  AppDelegate.m
//  ComboTest
//
//  Created by 河野 さおり on 2016/02/03.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate{
    IBOutlet NSComboBox *comboPageRange;
    NSArray *comboData;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //コンボボックスのデータソース用配列を作成
    comboData = [NSArray arrayWithObjects:NSLocalizedString(@"ALL_PAGES", @""),@"e.g. 1-2,5,10",nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - comboBox data source method

//コンボボックスのデータソースのアイテム数を返す
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return comboData.count;
}

//各インデクスのオブジェクトバリューを返す
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [comboData objectAtIndex:index];
}

- (IBAction)comboPageRange:(id)sender {
    if ([sender indexOfSelectedItem] == 0) {
        [sender setStringValue:NSLocalizedString(@"ALL_PAGES", @"")];
        [_window makeFirstResponder:nil];
        [sender setEditable:NO];
    }else if([sender indexOfSelectedItem] == 1){
        [sender setStringValue:@""];
        [sender setEditable:YES];
        [_window makeFirstResponder:sender];
    }
}

#pragma mark - convert action

- (IBAction)pshConvertToIndexes:(id)sender {
    NSUInteger totalPage = 10;   //仮決めのページ総数
    NSString *indexString = comboPageRange.stringValue;
    NSMutableIndexSet *pageRange = [NSMutableIndexSet indexSet];
    if ([indexString isEqualToString:NSLocalizedString(@"ALL_PAGES", @"")]) {
        [pageRange addIndexesInRange:NSMakeRange(1, totalPage)];
    } else {
        //入力値に不正な文字列が含まれないかチェック
        NSCharacterSet *pgRangeChrSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789,-"];
        NSCharacterSet *inputChrSet = [NSCharacterSet characterSetWithCharactersInString:indexString];
        if (! [pgRangeChrSet isSupersetOfSet:inputChrSet]) {
            //入力値が不正文字列を含む
            [self showPageRangeError:@"ページ範囲の指定に不正な文字が使用されています。"];
            return;
        } else {
            //入力値をカンマで分割
            NSArray *ranges = [indexString componentsSeparatedByString:@","];
            for (NSString *range in ranges) {
                //インデクス指定文字列を"-"で分割
                NSArray *pages = [range componentsSeparatedByString:@"-"];
                if (pages.count > 2) {
                    //"-"が2つ以上含まれる場合
                    [self showPageRangeError:@"ページ範囲の指定に不正があります。"];
                    return;
                } else if (pages.count == 1) {
                    //"-"が含まれない場合
                    if ([range integerValue] <= totalPage && [range integerValue] > 0){
                        [pageRange addIndex:[range integerValue]];
                    } else {
                        [self showPageRangeError:@"ページ範囲の指定に不正があります。"];
                        return;
                    }
                } else if ([[pages objectAtIndex:0]isEqualToString:@""]) {
                    //"-"が先頭にある場合
                   if ([[pages objectAtIndex:1]integerValue] > totalPage || [[pages objectAtIndex:0]integerValue] < 1) {
                        [self showPageRangeError:@"ページ範囲の指定に不正があります。"];
                        return;
                    } else {
                        [pageRange addIndexesInRange:NSMakeRange(1,[[pages objectAtIndex:1]integerValue])];
                    }
                } else if ([[pages objectAtIndex:1]isEqualToString:@""]) {
                    //"-"が末尾にある場合
                    if ([[pages objectAtIndex:0]integerValue] > totalPage || [[pages objectAtIndex:0]integerValue] < 1) {
                        [self showPageRangeError:@"ページ範囲の指定に不正があります。"];
                        return;
                    } else {
                        [pageRange addIndexes:[self indexFrom1stIndex:[[pages objectAtIndex:0]integerValue] toLastIndex:totalPage]];
                    }
                } else {
                    //通常の範囲指定
                    if ([[pages objectAtIndex:0]integerValue] < 1 || [[pages objectAtIndex:1]integerValue] > totalPage || [[pages objectAtIndex:0]integerValue] > [[pages objectAtIndex:1]integerValue]) {
                        [self showPageRangeError:@"ページ範囲の指定に不正があります。"];
                        return;
                    } else {
                            [pageRange addIndexes:[self indexFrom1stIndex:[[pages objectAtIndex:0]integerValue] toLastIndex:[[pages objectAtIndex:1]integerValue]]];
                    }
                }
            }
        }
    }
    NSUInteger index = [pageRange firstIndex];
    while(index != NSNotFound) {
        NSLog(@"%li",index);
        index = [pageRange indexGreaterThanIndex:index];
    }
}

- (void)showPageRangeError:(NSString *)infoTxt{
    NSAlert *alert = [[NSAlert alloc]init];
    alert.messageText = @"ページ範囲指定エラー";
    [alert addButtonWithTitle:@"OK"];
    [alert setInformativeText:infoTxt];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode){}];
}

- (NSMutableIndexSet *)indexFrom1stIndex:(NSUInteger)firstIndex toLastIndex:(NSUInteger)lastIndex{
    NSMutableIndexSet *indexset = [NSMutableIndexSet indexSet];
    for (NSUInteger i = firstIndex; i <= lastIndex; i++) {
        [indexset addIndex:i];
    }
    return indexset;
}

@end
