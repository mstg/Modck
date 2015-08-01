//
//  cDockTile.m
//

#import "Preferences.h"
@import Opee;

extern NSInteger orient;

@interface Tile : NSObject
- (void)setSelected:(BOOL)arg1;
- (void)setLabel:(id)arg1 stripAppSuffix:(_Bool)arg2;
@end

ZKSwizzleInterface(_Modck_Tile, Tile, NSObject);
@implementation _Modck_Tile
- (void)labelAttached {
    ZKOrig(void);
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    // Would not recommend
    // 10.9 causes crash when fLabel is set to "" and 10.10+ sometimes saves fLabel to com.apple.dock plist
    // Which then means if you turn it off later you still have no icon labels, either scenario sucks
    // Instead hook DOCKLabelLayer and set it's sublayers to nil in ModckLabel.m
    
    // object_setInstanceVariable(self, "fLabel", @"");
    // [(Tile*)self setLabel:@"" stripAppSuffix:false];
    
    if ([[[Preferences sharedInstance] objectForKey:@"modck_darkenMouseOver"] boolValue])
        [(Tile*)self setSelected:true];
}

- (void)labelDetached {
    ZKOrig(void);
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    if ([[[Preferences sharedInstance] objectForKey:@"modck_darkenMouseOver"] boolValue])
        [(Tile*)self setSelected:false];
}
@end

ZKSwizzleInterface(_Modck_TileLayer, DOCKTileLayer, CALayer)
@implementation _Modck_TileLayer
- (void)layoutSublayers {
    ZKOrig(void);
    
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    // Icon shadows
    if ([[[Preferences sharedInstance] objectForKey:@"modck_iconShadow"] boolValue]) {
        float red = [[[Preferences sharedInstance] objectForKey:@"modck_iconShadowBGR"] floatValue];
        float green = [[[Preferences sharedInstance] objectForKey:@"modck_iconShadowBGG"] floatValue];
        float blue = [[[Preferences sharedInstance] objectForKey:@"modck_iconShadowBGB"] floatValue];
        float alpha = [[[Preferences sharedInstance] objectForKey:@"modck_iconShadowBGA"] floatValue];
        float size = [[[Preferences sharedInstance] objectForKey:@"modck_iconShadowBGS"] floatValue];
        
        NSSize mySize;
        mySize.width = 0;
        mySize.height = -10;
        
        self.shadowOpacity = alpha / 100.0;
        self.shadowColor = CGColorCreateGenericRGB(red/255.0, green/255.0, blue/255.0, 1.0);
        self.shadowRadius = size;
        self.shadowOffset = mySize;
    }
    
    // Icon reflections
    if ([[[Preferences sharedInstance] objectForKey:@"modck_iconReflection"] boolValue]) {
        CALayer *_iconLayer = ZKHookIvar(self, CALayer *, "_imageLayer");
        NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject: _iconLayer];
        CALayer *_reflectionLayer = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
        [ _reflectionLayer setName:(@"_reflectionLayer")];
        
        CGRect frm = _iconLayer.frame ;
        if (orient == 0) {
            frm.origin.y -= frm.size.height;
            _reflectionLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else if (orient == 1) {
            frm.origin.x -= frm.size.width;
            _reflectionLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        } else {
            frm.origin.x += frm.size.width;
            _reflectionLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        }
        [ _reflectionLayer setFrame:(frm) ];
        _reflectionLayer.opacity = 0.25;
        
        NSMutableArray *mutableArray = (NSMutableArray *)self.sublayers;
        for (CALayer *item in mutableArray)
            if ([item.name  isEqual:@"_reflectionLayer"]) {
                [item removeFromSuperlayer];
                break;
            }
        [ self addSublayer:_reflectionLayer ];
    }
}
@end
