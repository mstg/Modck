//
//  Initialize.m
//  Modck
//
//  Created by Mustafa Gezen on 20.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

@import Opee;
#define prefPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/modck.plist"]

OPInitialize {
	if (![[NSFileManager defaultManager] fileExistsAtPath:prefPath]) {
		NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
		[newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_fullWidth"];
		[newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_hideLabels"];
		[newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_dockBG"];
		[newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGR"];
		[newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGG"];
		[newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGB"];
		[newDict writeToFile:prefPath atomically:NO];
	}
}