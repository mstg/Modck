//
//  ViewController.m
//  ModckPreferences
//
//  Created by Mustafa Gezen on 19.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import "ViewController.h"
#define prefPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/modck.plist"]

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:prefPath]) {
		NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
		[pref setObject:[NSNumber numberWithBool:false] forKey:@"modck_fullWidth"];
		[pref setObject:[NSNumber numberWithBool:false] forKey:@"modck_hideLabels"];
		[pref setObject:[NSNumber numberWithBool:false] forKey:@"modck_dockBG"];
		[pref setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGR"];
		[pref setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGG"];
		[pref setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGB"];
		[newDict writeToFile:prefPath atomically:NO];
	}
	
	NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:prefPath];
	pref = [plist mutableCopy];
	
	[_fullWidthDock setState:[[pref objectForKey:@"modck_fullWidth"] integerValue]];
	[_hideLabels setState:[[pref objectForKey:@"modck_hideLabels"] integerValue]];
	[_changeDockBG setState:[[pref objectForKey:@"modck_dockBG"] integerValue]];
	[_dockBGR setFloatValue:[[pref objectForKey:@"modck_dockBGR"] floatValue]];
	[_dockBGG setFloatValue:[[pref objectForKey:@"modck_dockBGG"] floatValue]];
	[_dockBGB setFloatValue:[[pref objectForKey:@"modck_dockBGB"] floatValue]];
	
	if ([_changeDockBG state] == NSOnState) {
		[_dockBGR setHidden:false];
		[_dockBGG setHidden:false];
		[_dockBGB setHidden:false];
	}
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
}

- (IBAction)changeDockBG:(id)sender {
	if ([sender state] == NSOnState) {
		[_dockBGR setHidden:false];
		[_dockBGG setHidden:false];
		[_dockBGB setHidden:false];
	} else if ([sender state] == NSOffState) {
		[_dockBGR setHidden:true];
		[_dockBGG setHidden:true];
		[_dockBGB setHidden:true];
	}
}

- (IBAction)applyPressed:(id)sender {
	[pref setObject:[NSNumber numberWithBool:[_fullWidthDock state]] forKey:@"modck_fullWidth"];
	[pref setObject:[NSNumber numberWithBool:[_hideLabels state]] forKey:@"modck_hideLabels"];
	[pref setObject:[NSNumber numberWithBool:[_changeDockBG state]] forKey:@"modck_dockBG"];
	
	if ((![_dockBGR integerValue] && [_dockBGR integerValue] != 0) || [[_dockBGR stringValue] length] > 3)
		[_dockBGR setIntegerValue:255];
	
	if ((![_dockBGG integerValue] && [_dockBGG integerValue] != 0) || [[_dockBGR stringValue] length] > 3)
		[_dockBGG setIntegerValue:255];
	
	if ((![_dockBGB integerValue] && [_dockBGB integerValue] != 0) || [[_dockBGR stringValue] length] > 3)
		[_dockBGB setIntegerValue:255];
	
	[pref setObject:[NSNumber numberWithFloat:[_dockBGR floatValue]] forKey:@"modck_dockBGR"];
	[pref setObject:[NSNumber numberWithFloat:[_dockBGG floatValue]] forKey:@"modck_dockBGG"];
	[pref setObject:[NSNumber numberWithFloat:[_dockBGB floatValue]] forKey:@"modck_dockBGB"];
	
	NSMutableDictionary *tmpPlist = pref;
	[tmpPlist writeToFile:prefPath atomically:YES];
	system("killall Dock");
}

@end
