//
//  VSTheme.m
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import "VSTheme.h"


static BOOL stringIsEmpty(NSString *s);
static UIColor *colorWithHexString(NSString *hexString);


@interface VSTheme ()

@property (nonatomic, strong) NSDictionary *themeDictionary;
@property (nonatomic, strong) NSCache *colorCache;
@property (nonatomic, strong) NSCache *fontCache;

@end


@implementation VSTheme


#pragma mark Init

- (id)initWithDictionary:(NSDictionary *)themeDictionary {
	
	self = [super init];
	if (self == nil)
		return nil;
	
	_themeDictionary = themeDictionary;

	_colorCache = [NSCache new];
	_fontCache = [NSCache new];

	return self;
}


- (id)objectForKey:(NSString *)key {

	id obj = [self.themeDictionary valueForKeyPath:key];
	if (obj == nil && self.parentTheme != nil)
		obj = [self.parentTheme objectForKey:key];
	return obj;
}


- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {

	id obj = [self objectForKey:key];
	if (obj == nil)
		return defaultValue;
	return [obj boolValue];
}

- (BOOL)boolForKey:(NSString *)key {
    
    return [self boolForKey:key defaultValue:NO];
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
	
	id obj = [self objectForKey:key];
	if (obj == nil)
		return defaultValue;
	if ([obj isKindOfClass:[NSString class]])
		return obj;
	if ([obj isKindOfClass:[NSNumber class]])
		return [obj stringValue];
	return defaultValue;
}

- (NSString *)stringForKey:(NSString *)key {
    
    return [self stringForKey:key defaultValue:nil];
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {

	id obj = [self objectForKey:key];
	if (obj == nil)
		return defaultValue;
	return [obj integerValue];
}

- (NSInteger)integerForKey:(NSString *)key {

    return [self integerForKey:key defaultValue:0];
}

- (CGFloat)floatForKey:(NSString *)key defaultValue:(CGFloat)defaultValue {
	
	id obj = [self objectForKey:key];
	if (obj == nil)
		return  defaultValue;
	return [obj floatValue];
}

- (CGFloat)floatForKey:(NSString *)key {

    return [self floatForKey:key defaultValue:0.0f];
}

- (NSTimeInterval)timeIntervalForKey:(NSString *)key defaultValue:(NSTimeInterval)defaultValue {

	id obj = [self objectForKey:key];
	if (obj == nil)
		return defaultValue;
	return [obj doubleValue];
}

- (NSTimeInterval)timeIntervalForKey:(NSString *)key {
    
    return [self timeIntervalForKey:key defaultValue:0.0];
}

- (UIImage *)imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue {
	
	NSString *imageName = [self stringForKey:key];
	if (stringIsEmpty(imageName))
		return defaultValue;
	
	return [UIImage imageNamed:imageName];
}

- (UIImage *)imageForKey:(NSString *)key {
    
    return [self imageForKey:key defaultValue:nil];
}

- (UIColor *)colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue {

	UIColor *cachedColor = [self.colorCache objectForKey:key];
	if (cachedColor != nil)
		return cachedColor;
    
	UIColor *color = nil;
	NSString *colorString = [self stringForKey:key];
	if (colorString == nil) {
		color = defaultValue;
	} else {
		color = colorWithHexString(colorString);
		if (color == nil)
			color = defaultValue;
	}

	[self.colorCache setObject:color forKey:key];

	return color;
}

- (UIColor *)colorForKey:(NSString *)key {
    
    return [self colorForKey:key defaultValue:[UIColor blackColor]];
}

- (UIEdgeInsets)edgeInsetsForKey:(NSString *)key defaultValue:(UIEdgeInsets)defaultValue {

	CGFloat left = [self floatForKey:[key stringByAppendingString:@"Left"] defaultValue:defaultValue.left];
	CGFloat top = [self floatForKey:[key stringByAppendingString:@"Top"] defaultValue:defaultValue.top];
	CGFloat right = [self floatForKey:[key stringByAppendingString:@"Right"] defaultValue:defaultValue.right];
	CGFloat bottom = [self floatForKey:[key stringByAppendingString:@"Bottom"] defaultValue:defaultValue.bottom];

	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
	return edgeInsets;
}

- (UIEdgeInsets)edgeInsetsForKey:(NSString *)key {
    
    return [self edgeInsetsForKey:key defaultValue:UIEdgeInsetsZero];
}

- (UIFont *)fontForKey:(NSString *)key {

	UIFont *cachedFont = [self.fontCache objectForKey:key];
	if (cachedFont != nil)
		return cachedFont;
    
	NSString *fontName = [self stringForKey:key];
	CGFloat fontSize = [self floatForKey:[key stringByAppendingString:@"Size"]];

	if (fontSize < 1.0f)
		fontSize = 15.0f;

	UIFont *font = nil;
    
	if (stringIsEmpty(fontName))
		font = [UIFont systemFontOfSize:fontSize];
	else
		font = [UIFont fontWithName:fontName size:fontSize];

	if (font == nil)
		font = [UIFont systemFontOfSize:fontSize];
    
	[self.fontCache setObject:font forKey:key];

	return font;
}

- (UIFont *)fontForKey:(NSString *)key defaultFontName:(NSString*)defaultFontName defaultFontSize:(CGFloat)defaultFontSize {
    
	UIFont *cachedFont = [self.fontCache objectForKey:key];
	if (cachedFont != nil)
		return cachedFont;
    
	NSString *fontName = [self stringForKey:key];
	CGFloat fontSize = [self floatForKey:[key stringByAppendingString:@"Size"]];
    
    if (fontSize < 1.0f)
        fontSize = defaultFontSize >= 1.0f ? defaultFontSize : 15.0f;
    
	UIFont *font = nil;
    
	if (stringIsEmpty(fontName))
		font = [UIFont fontWithName:defaultFontName size:fontSize];
	else
		font = [UIFont fontWithName:fontName size:fontSize];
    
	if (font == nil)
		font = [UIFont systemFontOfSize:fontSize];
    
	[self.fontCache setObject:font forKey:key];
    
	return font;
}

- (CGPoint)pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue {

	CGFloat pointX = [self floatForKey:[key stringByAppendingString:@"X"] defaultValue:defaultValue.x];
	CGFloat pointY = [self floatForKey:[key stringByAppendingString:@"Y"] defaultValue:defaultValue.y];

	CGPoint point = CGPointMake(pointX, pointY);
	return point;
}


- (CGPoint)pointForKey:(NSString *)key {
    
	return [self pointForKey:key defaultValue:CGPointZero];
}

- (CGSize)sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue {

	CGFloat width = [self floatForKey:[key stringByAppendingString:@"Width"] defaultValue:defaultValue.width];
	CGFloat height = [self floatForKey:[key stringByAppendingString:@"Height"] defaultValue:defaultValue.height];

	CGSize size = CGSizeMake(width, height);
	return size;
}

- (CGSize)sizeForKey:(NSString *)key {
    
    return [self sizeForKey:key defaultValue:CGSizeZero];
}

- (UIViewAnimationOptions)curveForKey:(NSString *)key defaultValue:(UIViewAnimationOptions)defaultValue {
    
	NSString *curveString = [self stringForKey:key];
	if (stringIsEmpty(curveString))
		return defaultValue;

	curveString = [curveString lowercaseString];
	if ([curveString isEqualToString:@"easeinout"])
		return UIViewAnimationOptionCurveEaseInOut;
	else if ([curveString isEqualToString:@"easeout"])
		return UIViewAnimationOptionCurveEaseOut;
	else if ([curveString isEqualToString:@"easein"])
		return UIViewAnimationOptionCurveEaseIn;
	else if ([curveString isEqualToString:@"linear"])
		return UIViewAnimationOptionCurveLinear;
    
	return defaultValue;
}

- (UIViewAnimationOptions)curveForKey:(NSString *)key {
    
    return [self curveForKey:key defaultValue:UIViewAnimationOptionCurveEaseInOut];
}

- (VSAnimationSpecifier *)animationSpecifierForKey:(NSString *)key {

	VSAnimationSpecifier *animationSpecifier = [VSAnimationSpecifier new];

	animationSpecifier.duration = [self timeIntervalForKey:[key stringByAppendingString:@"Duration"]];
	animationSpecifier.delay = [self timeIntervalForKey:[key stringByAppendingString:@"Delay"]];
	animationSpecifier.curve = [self curveForKey:[key stringByAppendingString:@"Curve"]];

	return animationSpecifier;
}

- (VSTextCaseTransform)textCaseTransformForKey:(NSString *)key defaultValue:(VSTextCaseTransform)defaultValue {

	NSString *s = [self stringForKey:key];
	if (s == nil)
		return defaultValue;

	if ([s caseInsensitiveCompare:@"lowercase"] == NSOrderedSame)
		return VSTextCaseTransformLower;
	else if ([s caseInsensitiveCompare:@"uppercase"] == NSOrderedSame)
		return VSTextCaseTransformUpper;

	return defaultValue;
}

- (VSTextCaseTransform)textCaseTransformForKey:(NSString *)key {

    return [self textCaseTransformForKey:key defaultValue:VSTextCaseTransformNone];
}

@end


@implementation VSTheme (Animations)


- (void)animateWithAnimationSpecifierKey:(NSString *)animationSpecifierKey animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {

    VSAnimationSpecifier *animationSpecifier = [self animationSpecifierForKey:animationSpecifierKey];

    [UIView animateWithDuration:animationSpecifier.duration delay:animationSpecifier.delay options:animationSpecifier.curve animations:animations completion:completion];
}

@end


#pragma mark -

@implementation VSAnimationSpecifier

@end


static BOOL stringIsEmpty(NSString *s) {
	return s == nil || [s length] == 0;
}


static UIColor *colorWithHexString(NSString *hexString) {

	/*Picky. Crashes by design.*/
	
	if (stringIsEmpty(hexString))
		return [UIColor blackColor];

	NSMutableString *s = [hexString mutableCopy];
	[s replaceOccurrencesOfString:@"#" withString:@"" options:0 range:NSMakeRange(0, [hexString length])];
	CFStringTrimWhitespace((__bridge CFMutableStringRef)s);

	NSString *redString = [s substringToIndex:2];
	NSString *greenString = [s substringWithRange:NSMakeRange(2, 2)];
	NSString *blueString = [s substringWithRange:NSMakeRange(4, 2)];

	unsigned int red = 0, green = 0, blue = 0;
	[[NSScanner scannerWithString:redString] scanHexInt:&red];
	[[NSScanner scannerWithString:greenString] scanHexInt:&green];
	[[NSScanner scannerWithString:blueString] scanHexInt:&blue];

	return [UIColor colorWithRed:(CGFloat)red/255.0f green:(CGFloat)green/255.0f blue:(CGFloat)blue/255.0f alpha:1.0f];
}
