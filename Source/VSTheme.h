//
//  VSTheme.h
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
#define TargetAppKit 1
#endif

/* Interchangable classes */
#ifdef TargetAppKit
#define COLORCLASS NSColor
#define FONTCLASS NSFont
#define IMAGECLASS NSImage
#define EDGEINSETS NSEdgeInsets
#define EDGEINSETSMAKE NSEdgeInsetsMake
#else
#define COLORCLASS UIColor
#define FONTCLASS UIFont
#define IMAGECLASS UIImage
#define EDGEINSETS UIEdgeInsets
#define EDGEINSETSMAKE UIEdgeInsetsMake
#endif


typedef NS_ENUM(NSUInteger, VSTextCaseTransform) {
    VSTextCaseTransformNone,
    VSTextCaseTransformUpper,
    VSTextCaseTransformLower
};


@class VSAnimationSpecifier;

@interface VSTheme : NSObject

- (id)initWithDictionary:(NSDictionary *)themeDictionary;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) VSTheme *parentTheme; /*can inherit*/

- (BOOL)boolForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (CGFloat)floatForKey:(NSString *)key;
- (IMAGECLASS *)imageForKey:(NSString *)key; /*Via UIImage imageNamed:*/
- (COLORCLASS *)colorForKey:(NSString *)key; /*123ABC or #123ABC: 6 digits, leading # allowed but not required*/
- (EDGEINSETS)edgeInsetsForKey:(NSString *)key; /*xTop, xLeft, xRight, xBottom keys*/
- (FONTCLASS *)fontForKey:(NSString *)key; /*x and xSize keys*/
- (CGPoint)pointForKey:(NSString *)key; /*xX and xY keys*/
- (CGSize)sizeForKey:(NSString *)key; /*xWidth and xHeight keys*/
- (NSTimeInterval)timeIntervalForKey:(NSString *)key;

#ifndef TargetAppKit
- (UIViewAnimationOptions)curveForKey:(NSString *)key; /*Possible values: easeinout, easeout, easein, linear*/
- (VSAnimationSpecifier *)animationSpecifierForKey:(NSString *)key; /*xDuration, xDelay, xCurve*/
#endif

- (VSTextCaseTransform)textCaseTransformForKey:(NSString *)key; /*lowercase or uppercase -- returns VSTextCaseTransformNone*/

@end

#ifndef TargetAppKit
@interface VSTheme (Animations)

- (void)animateWithAnimationSpecifierKey:(NSString *)animationSpecifierKey animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end

@interface VSAnimationSpecifier : NSObject

@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIViewAnimationOptions curve;


@end
#endif
