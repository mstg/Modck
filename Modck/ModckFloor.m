//
//  ModckFloor.m
//  Modck
//
//  Created by Mustafa Gezen on 19.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import <objc/runtime.h>
#import "Preferences.h"
@import Opee;

#define DOCKFloorLayer _TtC4Dock10FloorLayer

@interface DOCKFloorLayer : CALayer {
	CALayer *_glassLayer;
}
@end

#pragma mark Full-width Dock
ZKSwizzleInterface(_Modck_ECMaterialLayer, ECMaterialLayer, CALayer);
@implementation _Modck_ECMaterialLayer
- (void)setBounds:(CGRect)arg1 {
	if ([[[Preferences sharedInstance] objectForKey:@"modck_fullWidth"] integerValue] == 1) {
		NSString *groupName = ZKHookIvar(self, NSString *, "_groupName");
		
		if (![groupName isEqualToString:@"background"]) {
			ZKOrig(void, arg1);
			return;
		}
		
		ZKOrig(void, CGRectMake(arg1.origin.x, arg1.origin.y, [[NSScreen mainScreen] frame].size.width, arg1.size.height));
	} else {
		ZKOrig(void, arg1);
	}
}

@end

#pragma mark Dock customization
ZKSwizzleInterface(_Modck_DOCKFloorLayer, DOCKFloorLayer, CALayer);
@implementation _Modck_DOCKFloorLayer
- (void)layoutSublayers {
	ZKOrig(void);
	DOCKFloorLayer *this = (DOCKFloorLayer*)self;
	
	if ([[[Preferences sharedInstance] objectForKey:@"modck_fullWidth"] integerValue] == 1) {
		CALayer *glassLayer = ZKHookIvar(self, CALayer *, "_glassLayer");
		glassLayer.hidden = YES;
		[this setBackgroundColor:[[NSColor clearColor] CGColor]];
	}
	
	if ([[[Preferences sharedInstance] objectForKey:@"modck_dockBG"] integerValue] == 1) {
		float red = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGR"] floatValue];
		float green = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGG"] floatValue];
		float blue = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGB"] floatValue];
	
		NSColor *goodColor = [NSColor colorWithRed:red/255.0 green:green/255 blue:blue/255.0 alpha:1.0];
		[this setBackgroundColor:[goodColor CGColor]];
		
		if ([[[Preferences sharedInstance] objectForKey:@"modck_fullWidth"] integerValue] == 0) {
			[this setBorderWidth:1];
			this.cornerRadius = 0;
			this.masksToBounds = YES;
			[this setBorderColor:[goodColor CGColor]];
		}
	}
}
@end