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

        // Stuff
        [newDict setObject:[NSNumber numberWithBool:true] forKey:@"modck_enabled"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_fullWidth"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_hideLabels"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_darkenMouseOver"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_customIndicator"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_iconReflection"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_isTransparent"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_cornerRadius"];
        [newDict setObject:[NSNumber numberWithInt:0] forKey:@"modck_darkMode"];    // 0 sys, 1 light, 2 dark
        
        // Default layers
        [newDict setObject:[NSNumber numberWithBool:true] forKey:@"modck_showFrost"];
        [newDict setObject:[NSNumber numberWithBool:true] forKey:@"modck_showGlass"];
        [newDict setObject:[NSNumber numberWithBool:true] forKey:@"modck_showSeparator"];
        
        //        Dock background frame adjustments x pos, y pos, width, height
        //        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_increaseX"];
        //        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_increaseY"];
        //        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_increaseW"];
        //        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_increaseH"];
        
        // Icon shadows
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_iconShadow"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_iconShadowBGR"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_iconShadowBGG"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_iconShadowBGB"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_iconShadowBGA"];  // Alpha
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_iconShadowBGS"];  // Size
        
        // Dock background coloring
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_dockBG"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGR"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGG"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGB"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_dockBGA"];
        
        // Label background coloring
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"modck_labelBG"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGR"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGG"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGB"];
        [newDict setObject:[NSNumber numberWithFloat:0.0] forKey:@"modck_labelBGA"];
        
		[newDict writeToFile:prefPath atomically:NO];
	}
}