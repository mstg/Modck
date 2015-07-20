//
//  ViewController.h
//  ModckPreferences
//
//  Created by Mustafa Gezen on 19.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSButton *fullWidthDock;
@property (weak) IBOutlet NSButton *hideLabels;
@property (weak) IBOutlet NSButton *changeDockBG;
@property (weak) IBOutlet NSTextField *dockBGR;
@property (weak) IBOutlet NSTextField *dockBGG;
@property (weak) IBOutlet NSTextField *dockBGB;
@property (weak) IBOutlet NSButton *labelBG;
@property (weak) IBOutlet NSTextField *labelBGR;
@property (weak) IBOutlet NSTextField *labelBGG;
@property (weak) IBOutlet NSTextField *labelBGB;


@end

NSMutableDictionary *pref;