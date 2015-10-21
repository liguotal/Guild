//
//  MRAnimation.h
//  LYStore
//
//  Created by MrXir on 14-6-6.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
@interface MRAnimation : NSObject

+ (MRAnimation *)manager;

- (void)makeShakeWith:(UIView *)view duration:(CFTimeInterval)duration spacing:(NSTimeInterval)spacing;

- (void)makeRotateWith:(UIView *)view duration:(CFTimeInterval)duration repeatCount:(CGFloat)count axis:(NSString *)axis spacing:(NSTimeInterval)spacing;

- (void)shake:(UIView *)view duration:(CFTimeInterval)duration;

- (void)rotate:(UIView *)view duration:(CFTimeInterval)duration repeatCount:(CGFloat)count axis:(NSString *)axis;

+ (void)setPrompt:(NSString *)prompt viewController:(UIViewController *)vc;

+ (void)showText:(NSString *)text onTheView:(UIView *)parentView;

@end
