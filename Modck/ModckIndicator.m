//
//  cDockIndicator.m
//

#import "Preferences.h"
@import Opee;

extern NSInteger orient;

ZKSwizzleInterface(_Modck_IndicatorLayer, DOCKIndicatorLayer, CALayer)
@implementation _Modck_IndicatorLayer
- (void)updateIndicatorForSize:(float)arg1 {
    ZKOrig(void, arg1);
    
    // Do nothing
    if (![[[Preferences sharedInstance] objectForKey:@"modck_enabled"] boolValue])
        return;
    
    // Custom indicator code
    /*
    if ([[[Preferences sharedInstance] objectForKey:@"modck_customIndicator"] boolValue]) {
        self.backgroundColor = NSColor.clearColor.CGColor;
        self.cornerRadius = 0.0;
        
        NSString *iconFile = @"";
        NSString *file_orient = @"";
        if (orient == 0) {
            file_orient = @"";
        } else {
            file_orient = @"_simple";
        }
 
        if (arg1 > 100) {
            iconFile=[NSString stringWithFormat:@"%@/indicator_large%@.png", prefPath, file_orient];
        } else if (arg1 < 35 ) {
            iconFile=[NSString stringWithFormat:@"%@/indicator_small%@.png", prefPath, file_orient];
        } else {
            iconFile=[NSString stringWithFormat:@"%@/indicator_medium%@.png", prefPath, file_orient];
        }
        
        NSImage *image = [[[NSImage alloc] initWithContentsOfFile:iconFile] autorelease];
        NSImageRep *rep = [[image representations] objectAtIndex:0];
        NSSize imageSize = NSMakeSize(rep.pixelsWide, rep.pixelsHigh);
        
        self.contents = (__bridge id)image;
        self.contentsGravity = kCAGravityBottom;
        
        // Questionable whether or not it looks better without this adjustment
        self.frame = CGRectMake(self.frame.origin.x, 0, imageSize.width / self.contentsScale, imageSize.height / self.contentsScale);
    }
    */
}
@end