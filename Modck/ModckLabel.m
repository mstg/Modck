//
//  ModckLabel.m
//  Modck
//
//  Created by Mustafa Gezen on 19.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import "Preferences.h"
@import Opee;

@interface ECMaterialLayer : CALayer
{
    CALayer *_backdropLayer;
    CALayer *_tintLayer;
    NSString *_groupName;
    _Bool _reduceTransparency;
    NSUInteger _material;
}
@end

ZKSwizzleInterface(__Modck_Label, DOCKLabelLayer, CALayer);
@implementation __Modck_Label
-(void)layoutSublayers {
    ZKOrig(void);
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    if ([[[Preferences sharedInstance] objectForKey:@"modck_hideLabels"] boolValue])
        self.sublayers = nil;
}
@end

ZKSwizzleInterface(_Modck_ECMaterialLayer, ECMaterialLayer, CALayer);
@implementation _Modck_ECMaterialLayer
- (void)setBounds:(CGRect)arg1 {
    ZKOrig(void, arg1);
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    NSUInteger _material = ZKHookIvar(self, NSUInteger, "_material");
    
    if (_material != 0) {
        ZKOrig(void, arg1);
        if ([[[Preferences sharedInstance] objectForKey:@"modck_labelBG"] boolValue]) {
            float red = [[[Preferences sharedInstance] objectForKey:@"modck_labelBGR"] floatValue];
            float green = [[[Preferences sharedInstance] objectForKey:@"modck_labelBGG"] floatValue];
            float blue = [[[Preferences sharedInstance] objectForKey:@"modck_labelBGB"] floatValue];
            float alpha = [[[Preferences sharedInstance] objectForKey:@"modck_labelBGA"] floatValue];
            
            NSColor *goodColor = [NSColor colorWithRed:red/255.0 green:green/255 blue:blue/255.0 alpha:1.0];
            CALayer *tintLayer = ZKHookIvar(self, CALayer *, "_backdropLayer");
            [tintLayer setBackgroundColor:[goodColor CGColor]];
            [tintLayer setOpacity:( alpha / 100.0 )];
        }
    }
    
    // Not sure if necessary so I'll leave this here
    if (_material == 0) {
        if (![[[Preferences sharedInstance] objectForKey:@"modck_showFrost"] boolValue]) {
            CALayer *tintLayer = ZKHookIvar(self, CALayer *, "_backdropLayer");
            tintLayer.hidden = YES;
        }
    }
}
@end