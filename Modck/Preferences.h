//
//  Preferences.h
//  Modck
//
//  Created by Mustafa Gezen on 20.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject {
	NSMutableDictionary *_prefs;
}
+ (instancetype)sharedInstance;
- (id)objectForKey:(NSString *)key;
@end