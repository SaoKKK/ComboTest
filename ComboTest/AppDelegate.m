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

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)comboPageRange:(id)sender {
    if ([sender indexOfSelectedItem] == 0) {
        [sender setStringValue:@"All Pages"];
        [_window makeFirstResponder:nil];
        [sender setEditable:NO];
        
    }else if([sender indexOfSelectedItem] == 1){
        [sender setStringValue:@""];
        [sender setEditable:YES];
        [_window makeFirstResponder:sender];
    }
}

@end
