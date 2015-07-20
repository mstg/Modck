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
		[pref setObject:[NSNumber numberWithBool:false] forKey:@"modck_labelBG"];
		[pref setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGR"];
		[pref setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGG"];
		[pref setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGB"];
		[newDict writeToFile:prefPath atomically:NO];
	}
	
	NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:prefPath];
	pref = [plist mutableCopy];
	
	[_fullWidthDock setState:[[pref objectForKey:@"modck_fullWidth"] integerValue]];
	[_hideLabels setState:[[pref objectForKey:@"modck_hideLabels"] integerValue]];
	[_changeDockBG setState:[[pref objectForKey:@"modck_dockBG"] integerValue]];
	[_labelBG setState:[[pref objectForKey:@"modck_labelBG"] integerValue]];
	[_dockBGR setFloatValue:[[pref objectForKey:@"modck_dockBGR"] floatValue]];
	[_dockBGG setFloatValue:[[pref objectForKey:@"modck_dockBGG"] floatValue]];
	[_dockBGB setFloatValue:[[pref objectForKey:@"modck_dockBGB"] floatValue]];
	[_labelBGR setFloatValue:[[pref objectForKey:@"modck_labelBGR"] floatValue]];
	[_labelBGG setFloatValue:[[pref objectForKey:@"modck_labelBGG"] floatValue]];
	[_labelBGB setFloatValue:[[pref objectForKey:@"modck_labelBGB"] floatValue]];
	
	if ([_changeDockBG state] == NSOnState) {
		[_dockBGR setHidden:false];
		[_dockBGG setHidden:false];
		[_dockBGB setHidden:false];
	}
	
	if ([_labelBG state] == NSOnState) {
		[_labelBGR setHidden:false];
		[_labelBGG setHidden:false];
		[_labelBGB setHidden:false];
	}
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
}

- (IBAction)changeLabelBG:(id)sender {
	if ([sender state] == NSOnState) {
		[_labelBGR setHidden:false];
		[_labelBGG setHidden:false];
		[_labelBGB setHidden:false];
	} else if ([sender state] == NSOffState) {
		[_labelBGR setHidden:true];
		[_labelBGG setHidden:true];
		[_labelBGB setHidden:true];
	}
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
	[pref setObject:[NSNumber numberWithBool:[_labelBG state]] forKey:@"modck_labelBG"];
	
	if ((![_dockBGR integerValue] && [_dockBGR integerValue] != 0) || [[_dockBGR stringValue] length] > 3)
		[_dockBGR setIntegerValue:255];
	
	if ((![_dockBGG integerValue] && [_dockBGG integerValue] != 0) || [[_dockBGR stringValue] length] > 3)
		[_dockBGG setIntegerValue:255];
	
	if ((![_dockBGB integerValue] && [_dockBGB integerValue] != 0) || [[_dockBGR stringValue] length] > 3)
		[_dockBGB setIntegerValue:255];
	
	if ((![_labelBGR integerValue] && [_labelBGR integerValue] != 0) || [[_labelBGR stringValue] length] > 3)
		[_labelBGR setIntegerValue:255];
	
	if ((![_labelBGG integerValue] && [_labelBGG integerValue] != 0) || [[_labelBGG stringValue] length] > 3)
		[_labelBGG setIntegerValue:255];
	
	if ((![_labelBGB integerValue] && [_labelBGB integerValue] != 0) || [[_labelBGB stringValue] length] > 3)
		[_labelBGB setIntegerValue:255];
	
	[pref setObject:[NSNumber numberWithFloat:[_dockBGR floatValue]] forKey:@"modck_dockBGR"];
	[pref setObject:[NSNumber numberWithFloat:[_dockBGG floatValue]] forKey:@"modck_dockBGG"];
	[pref setObject:[NSNumber numberWithFloat:[_dockBGB floatValue]] forKey:@"modck_dockBGB"];
	
	[pref setObject:[NSNumber numberWithFloat:[_labelBGR floatValue]] forKey:@"modck_labelBGR"];
	[pref setObject:[NSNumber numberWithFloat:[_labelBGG floatValue]] forKey:@"modck_labelBGG"];
	[pref setObject:[NSNumber numberWithFloat:[_labelBGB floatValue]] forKey:@"modck_labelBGB"];
	
	NSMutableDictionary *tmpPlist = pref;
	[tmpPlist writeToFile:prefPath atomically:YES];
	system("killall Dock");
}

@end
