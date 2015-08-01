//
//  ModckFloor.m
//  Modck
//
//  Created by Mustafa Gezen on 19.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import "Preferences.h"
#import "fishhook.h"
#import <dlfcn.h>
@import Opee;

//  We can add support for 10.10 by only swizzling for _TtC4Dock10FloorLayer if minorversion is 11
//  #define DOCKFloorLayer _TtC4Dock10FloorLayer

NSInteger orient = 0;
long osx_minor = 0;

// Fix for icon shadows / reflection layer not intializing on their own...
void _loadShadows(CALayer* layer) {
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            SEL aSel = @selector(layoutSublayers);
            NSArray *tileLayers = layer.superlayer.sublayers;
            for (CALayer *item in tileLayers)
                if (item.class == NSClassFromString(@"DOCKTileLayer")) {
                    if ([item respondsToSelector:aSel])
                        [item performSelector:aSel];
                }
            NSLog(@"Shadows and reflections initialized...");
        });
    });
}

@interface initialize : NSObject
@end
@implementation initialize
+ (void)load {
    // Get OS X version. Major and Patch are irrelivant here
    osx_minor = [[NSProcessInfo processInfo] operatingSystemVersion].minorVersion;
    
    if (osx_minor == 11)
        ZKSwizzle(_Modck_DOCKFloorLayer, _TtC4Dock10FloorLayer);
    if (osx_minor == 10)
        ZKSwizzle(_Modck_DOCKFloorLayer, DOCKFloorLayer);
    
    // https://github.com/b3ll/DarkDock
    if (osx_minor > 9) {
        orig_CFPreferencesCopyAppValue = dlsym(RTLD_DEFAULT, "CFPreferencesCopyAppValue");
        rebind_symbols((struct rebinding[1]){{"CFPreferencesCopyAppValue", hax_CFPreferencesCopyAppValue}}, 1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("AppleInterfaceThemeChangedNotification"), (void *)0x1, NULL, YES);
        });
    }
    
    NSLog(@"OS X 10.%li, Modck loaded...", osx_minor);
}

// Force dock into dark or light mode
static id (*orig_CFPreferencesCopyAppValue)(CFStringRef key, CFStringRef applicationID);
id hax_CFPreferencesCopyAppValue(CFStringRef key, CFStringRef applicationID) {
    if ([(__bridge NSString *)key isEqualToString:@"AppleInterfaceTheme"] || [(__bridge NSString *)key isEqualToString:@"AppleInterfaceStyle"]) {
        if ([[[Preferences sharedInstance] objectForKey:@"modck_darkMode"] intValue] == 1) {
            return @"Light";
        } else if ([[[Preferences sharedInstance] objectForKey:@"modck_darkMode"] intValue] == 2) {
            return @"Dark";
        } else {
            return orig_CFPreferencesCopyAppValue(key, applicationID);
        }
    } else {
        return orig_CFPreferencesCopyAppValue(key, applicationID);
    }
}
@end

// Dock customization
ZKSwizzleInterface(_Modck_DOCKFloorLayer, DOCKFloorLayer, CALayer);
@implementation _Modck_DOCKFloorLayer
- (void)layoutSublayers {
    ZKOrig(void);
    
    // Do nothing
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    // Fix for icon shadows / reflection layer not intializing on their own...
    _loadShadows(self);
    
    // Get dock orientation
    if (osx_minor == 11) {
        object_getInstanceVariable(self, "orientation", (void **)&orient);
    } else {
        object_getInstanceVariable(self, "_orientation", (void **)&orient);
    }
    
    // Hook some layers
    CALayer *_materialLayer = ZKHookIvar(self, CALayer *, "_materialLayer");
    CALayer *_glassLayer = ZKHookIvar(self, CALayer *, "_glassLayer");
    CALayer *_separatorLayer = ZKHookIvar(self, CALayer *, "_separatorLayer");
    CALayer *_superLayer = self;
    
    // Duplicate the frost layer, I'll use this as our base background layer
    NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject: _materialLayer];
    CALayer *_frostDupe = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
    [ _frostDupe setName:(@"_frostDupe")];
    
    // Probably could be done better remove old copy then add new one
    NSMutableArray *mutableArray = (NSMutableArray *)_superLayer.sublayers;
    for (CALayer *item in mutableArray)
        if ([item.name isEqual:@"_frostDupe"]) {
            [item removeFromSuperlayer];
            break;
        }
    [ _superLayer addSublayer:_frostDupe ];
    
    // Picture background code
    /*
    if ([[[Preferences sharedInstance] objectForKey:@"modck_pictureBG"] boolValue]) {
        NSString *picFile = nil;
        if (orient == 0) {
            picFile = [NSString stringWithFormat:@"%@/horizontal.png", prefPath];
        } else {
            picFile = [NSString stringWithFormat:@"%@/vertical.png", prefPath];
        }
        if ([[[Preferences sharedInstance] objectForKey:@"modck_pictureTile"] boolValue]) {
            [ _materialLayer setBackgroundColor:[[NSColor colorWithPatternImage:[[[NSImage alloc] initWithContentsOfFile:picFile] autorelease]] CGColor] ];
        } else {
            _materialLayer.contents = [[[NSImage alloc] initWithContentsOfFile:picFile] autorelease];
        }
        [ _materialLayer setSublayers:[NSArray arrayWithObjects:_separatorLayer, nil] ];
    }
     */
    
    // Color background
    if ([[[Preferences sharedInstance] objectForKey:@"modck_dockBG"] boolValue]) {
        float red = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGR"] floatValue];
        float green = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGG"] floatValue];
        float blue = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGB"] floatValue];
        float alpha = [[[Preferences sharedInstance] objectForKey:@"modck_dockBGA"] floatValue];
        NSColor *goodColor = [NSColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
        _materialLayer.cornerRadius = 0;
        _materialLayer.borderWidth = 0;
        [_frostDupe setBackgroundColor:[goodColor CGColor]];
        [_frostDupe setOpacity:(alpha / 100.0)];
    }
    
    // Full width
    if ([[[Preferences sharedInstance] objectForKey:@"modck_fullWidth"] boolValue]) {
        CGRect rect = _materialLayer.bounds;
        if (orient == 0) {
            rect.size.width = [[NSScreen mainScreen] frame].size.width * 2;
            rect.origin.x -= [[NSScreen mainScreen] frame].size.width / 2;
        } else {
            rect.size.height = [[NSScreen mainScreen] frame].size.height * 2;
            rect.origin.y -= [[NSScreen mainScreen] frame].size.height;
        }
        [ _materialLayer setFrame:rect ];
    } else {
        // If not full width round corners
        CGRect rect = _superLayer.bounds;
        float cornerSize = [[[Preferences sharedInstance] objectForKey:@"modck_cornerRadius"] floatValue];
        if (cornerSize > (float)0) {
            [ _frostDupe setCornerRadius:cornerSize ];
            [ _materialLayer setCornerRadius:cornerSize ];
            _glassLayer.hidden = YES;
            if (orient == 0) {
                rect.size.height += cornerSize;
                rect.origin.y -= cornerSize;
            } else {
                rect.size.width += cornerSize;
            }
            if (orient == 1) {
                rect.origin.x -= cornerSize;
            }
        }
        [ _materialLayer setFrame:rect ];
    }
    
    // Why does this work? if I color the original frost layer I lose the frost
    // same with the superlayer, so I create this dupe layer
    // but if I don't move it out of the frame I only see the uncolored frost
    // very magical, there must be a better way...
    CGRect rect = _materialLayer.bounds;
    rect.origin.y += rect.size.height;
    [_frostDupe setBounds:rect];
    _frostDupe.hidden = NO;
    
    // Pinning except the actual clickable tile areas don't move, not sure how to do that...
    //    static dispatch_once_t once;
    //    dispatch_once(&once, ^ {
    //        CGRect r1 = _superLayer.bounds;
    //        CGRect rect = _superLayer.superlayer.frame;
    //        NSLog(@"%f", r1.size.width);
    //        rect.origin.x -= ([[NSScreen mainScreen] frame].size.width - r1.size.width) / 2;
    //        _superLayer.superlayer.frame = rect;
    //    });
    
    // Hide layers if we want to
    if (![[[Preferences sharedInstance] objectForKey:@"modck_showFrost"] boolValue])
        _materialLayer.hidden = YES;
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_showGlass"] boolValue]) {
        _glassLayer.hidden = YES;
    } else {
        // Glass layer looks odd in full width
        if ([[[Preferences sharedInstance] objectForKey:@"modck_fullWidth"] boolValue])
            _glassLayer.hidden = YES;
        // Glass layer wont respond to corner radius so lets hide it
        if ([[[Preferences sharedInstance] objectForKey:@"modck_dockBG"] boolValue])
            _glassLayer.hidden = YES;
    }
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_showSeparator"] boolValue])
        _separatorLayer.hidden = YES;
    
    // Setting sublayer to just the separator seems to work nice for this
    if ([[[Preferences sharedInstance] objectForKey:@"modck_isTransparent"] boolValue])
        [ _superLayer setSublayers:[NSArray arrayWithObjects:_separatorLayer, nil] ];
}
@end