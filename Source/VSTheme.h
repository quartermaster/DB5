//
//  VSTheme.h
//  Q Branch LLC
//
//  Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
- (BOOL)boolForKey:(NSString*)key defaultValue:(BOOL)defaultValue;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (CGFloat)floatForKey:(NSString *)key;
- (CGFloat)floatForKey:(NSString *)key defaultValue:(CGFloat)defaultValue;
- (UIImage *)imageForKey:(NSString *)key; /*Via UIImage imageNamed:*/
- (UIImage *)imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue; /*Via UIImage imageNamed:*/
- (UIColor *)colorForKey:(NSString *)key; /*123ABC or #123ABC: 6 digits, leading # allowed but not required*/
- (UIColor *)colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue; /*123ABC or #123ABC: 6 digits, leading # allowed but not required*/
- (UIEdgeInsets)edgeInsetsForKey:(NSString *)key; /*xTop, xLeft, xRight, xBottom keys*/
- (UIEdgeInsets)edgeInsetsForKey:(NSString *)key defaultValue:(UIEdgeInsets)defaultValue; /*xTop, xLeft, xRight, xBottom keys*/
- (UIFont *)fontForKey:(NSString *)key; /*x and xSize keys*/
- (UIFont *)fontForKey:(NSString *)key defaultFontName:(NSString*)defaultFontName defaultFontSize:(CGFloat)defaultFontSize;
- (CGPoint)pointForKey:(NSString *)key; /*xX and xY keys*/
- (CGPoint)pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue; /*xX and xY keys*/
- (CGSize)sizeForKey:(NSString *)key; /*xWidth and xHeight keys*/
- (CGSize)sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue; /*xWidth and xHeight keys*/
- (NSTimeInterval)timeIntervalForKey:(NSString *)key;
- (NSTimeInterval)timeIntervalForKey:(NSString *)key defaultValue:(NSTimeInterval)defaultValue;

- (UIViewAnimationOptions)curveForKey:(NSString *)key; /*Possible values: easeinout, easeout, easein, linear*/
- (UIViewAnimationOptions)curveForKey:(NSString *)key defaultValue:(UIViewAnimationOptions)defaultValue; /*Possible values: easeinout, easeout, easein, linear*/
- (VSAnimationSpecifier *)animationSpecifierForKey:(NSString *)key; /*xDuration, xDelay, xCurve*/

- (VSTextCaseTransform)textCaseTransformForKey:(NSString *)key; /*lowercase or uppercase -- returns VSTextCaseTransformNone*/
- (VSTextCaseTransform)textCaseTransformForKey:(NSString *)key defaultValue:(VSTextCaseTransform)defaultValue; /*lowercase or uppercase -- returns VSTextCaseTransformNone*/

@end


@interface VSTheme (Animations)

- (void)animateWithAnimationSpecifierKey:(NSString *)animationSpecifierKey animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

@end


@interface VSAnimationSpecifier : NSObject

@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIViewAnimationOptions curve;

@end

