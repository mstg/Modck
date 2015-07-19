//
//  ModckLabel.m
//  Modck
//
//  Created by Mustafa Gezen on 19.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import <objc/runtime.h>
#import "Preferences.h"
@import Opee;

@interface Tile : NSObject
- (void)setSelected:(BOOL)arg1;
@end

ZKSwizzleInterface(_Modck_Tile, Tile, NSObject);
@implementation _Modck_Tile

- (void)setLabel:(id)arg1 stripAppSuffix:(_Bool)arg2 {
	if ([[[Preferences sharedInstance] objectForKey:@"modck_hideLabels"] integerValue] == 0) {
		ZKOrig(void, arg1, arg2);
		return;
	}
	
	object_setInstanceVariable(self, "fLabel", @"");
}
- (void)labelAttached {
	if ([[[Preferences sharedInstance] objectForKey:@"modck_hideLabels"] integerValue] == 0) {
		ZKOrig(void);
		return;
	}
	
	[(Tile*)self setSelected:true];
}

- (void)labelDetached {
	if ([[[Preferences sharedInstance] objectForKey:@"modck_hideLabels"] integerValue] == 0) {
		ZKOrig(void);
		return;
	}
	
	[(Tile*)self setSelected:false];
}
@end