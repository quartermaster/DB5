//
//  VSThemeLoader.m
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import "VSThemeLoader.h"
#import "VSTheme.h"


@interface VSThemeLoader ()

@property (nonatomic, strong, readwrite) VSTheme *defaultTheme;
@property (nonatomic, strong, readwrite) NSArray *themes;
@end


@implementation VSThemeLoader


+ (id)newWithContentsOfFile:(NSString *)path {
	
	return [[self alloc] initWithContentsOfFile:path];
}


+ (NSString*)defaultFilePath {
	
	return [[NSBundle mainBundle] pathForResource:@"DB5" ofType:@"plist"];
}


- (id)init {
	
	return [self initWithContentsOfFile:[[self class] defaultFilePath]];
}


- (id)initWithContentsOfFile:(NSString *)path {
	
	self = [super init];
	if (self == nil)
		return nil;
	
	NSDictionary *themesDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	NSMutableArray *themes = [NSMutableArray array];
	for (NSString *oneKey in themesDictionary) {
		
		VSTheme *theme = [[VSTheme alloc] initWithDictionary:themesDictionary[oneKey]];
		if ([[oneKey lowercaseString] isEqualToString:@"default"])
			_defaultTheme = theme;
		theme.name = oneKey;
		[themes addObject:theme];
	}

    for (VSTheme *oneTheme in themes) { /*All themes inherit from the default theme.*/
		if (oneTheme != _defaultTheme)
			oneTheme.parentTheme = _defaultTheme;
    }
    
	_themes = themes;
	
	return self;
}


- (VSTheme *)themeNamed:(NSString *)themeName {

	for (VSTheme *oneTheme in self.themes) {
		if ([themeName isEqualToString:oneTheme.name])
			return oneTheme;
	}

	return nil;
}

@end

