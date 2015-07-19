//
//  Preferences.m
//  Modck
//
//  Created by Mustafa Gezen on 20.07.2015.
//  Copyright © 2015 Mustafa Gezen. All rights reserved.
//

#import "Preferences.h"
#define prefPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/modck.plist"]

@implementation Preferences
+ (instancetype)sharedInstance {
	static Preferences *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self.class alloc] init];
		NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:prefPath];
		sharedInstance->_prefs = [plist mutableCopy];
	});
	
	return sharedInstance;
}

- (id)objectForKey:(NSString *)key {
	if ([self->_prefs objectForKey:key]) {
		return [self->_prefs objectForKey:key];
	} else {
		return nil;
	}
}
@end
