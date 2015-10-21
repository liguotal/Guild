//
//  MRAnimation.m
//  LYStore
//
//  Created by MrXir on 14-6-6.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "MRAnimation.h"

@implementation MRAnimation

+ (MRAnimation *)manager
{
    static MRAnimation *s_Manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_Manager = [[MRAnimation alloc] init];
    });
    return s_Manager;
}

- (void)makeShakeWith:(UIView *)view duration:(CFTimeInterval)duration spacing:(NSTimeInterval)spacing
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:view forKey:@"view"];
    [userInfo setValue:@(duration) forKey:@"duration"];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:spacing target:self selector:@selector(shakeWithTimer:) userInfo:userInfo repeats:YES];
    [timer fire];
}

- (void)shakeWithTimer:(NSTimer *)timer
{
    id userInfo = [timer userInfo];
    UIView *view =[userInfo objectForKey:@"view"];
    CFTimeInterval duration = [[userInfo objectForKey:@"duration"] floatValue];
    [self shake:view duration:duration];
}


- (void)makeRotateWith:(UIView *)view duration:(CFTimeInterval)duration repeatCount:(CGFloat)count axis:(NSString *)axis spacing:(NSTimeInterval)spacing
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:view forKey:@"view"];
    [userInfo setValue:@(duration) forKey:@"duration"];
    [userInfo setValue:@(count) forKey:@"count"];
    [userInfo setValue:axis forKey:@"axis"];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:spacing target:self selector:@selector(rotateWithTimer:) userInfo:userInfo repeats:YES];
    [timer fire];
}

- (void)rotateWithTimer:(NSTimer *)timer
{
    id userInfo = [timer userInfo];
    UIView *view = [userInfo objectForKey:@"view"];
    CFTimeInterval duration = [[userInfo objectForKey:@"duration"] floatValue];
    CGFloat count = [[userInfo objectForKey:@"count"] floatValue];
    NSString *axis = [userInfo objectForKey:@"axis"];
    [self rotate:view duration:duration repeatCount:count axis:axis];
}

- (void)shake:(UIView *)view duration:(CFTimeInterval)duration
{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:duration];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      nil];
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [view.layer addAnimation:keyAn forKey:@"TextAnim"];
}


- (void)rotate:(UIView *)view duration:(CFTimeInterval)duration repeatCount:(CGFloat)count axis:(NSString *)axis
{
    NSString *keyPath = [NSString stringWithFormat:@"transform.rotation.%@",axis];
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:keyPath];
    rotation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotation.duration = duration;
    rotation.cumulative = YES;
    rotation.repeatCount = count;
    [view.layer addAnimation:rotation forKey:[NSString stringWithFormat:@"%@",view.class]];
    
}

+ (void)setPrompt:(NSString *)prompt viewController:(UIViewController *)vc
{
    if (!vc.navigationItem.prompt) {
        vc.navigationItem.prompt = prompt;
        [vc.navigationItem performSelector:@selector(setPrompt:) withObject:nil afterDelay:3];
    }
}

+ (UILabel *)theTextViewOnTheView:(UIView *)view
{
    static UILabel *s_textView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = CGRectMake(0, 0, 160, 80);
        CGPoint center = view.center;
        s_textView = [[UILabel alloc] init];
        s_textView.frame = frame;
        s_textView.center = center;
        s_textView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        s_textView.layer.cornerRadius = 4;
        s_textView.layer.masksToBounds = YES;
        s_textView.alpha = 0;
        s_textView.textAlignment  = NSTextAlignmentCenter;
        s_textView.textColor = [UIColor colorWithWhite:0.9 alpha:1.000];
        s_textView.font = [UIFont systemFontOfSize:16];
        s_textView.numberOfLines = 0;
        s_textView.lineBreakMode = NSLineBreakByCharWrapping;
    });
    return s_textView;
}

+ (void)showText:(NSString *)text onTheView:(UIView *)parentView
{
    UILabel *label = [MRAnimation theTextViewOnTheView:parentView];
    label.text = text;
    [parentView addSubview:label];
    if (label.alpha==0) {
        label.alpha=1;
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            label.alpha = 0;
        } completion:NULL];
    }
}

@end
