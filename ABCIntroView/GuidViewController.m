//
//  GuidViewController.m
//  ABCIntroView
//
//  Created by li on 15/10/21.
//  Copyright © 2015年 Adam Cooper. All rights reserved.
//

#import "GuidViewController.h"
#import "ABCIntroView.h"
#import "AppDelegate.h"
#import "MRRequest.h"
@interface GuidViewController ()<ABCIntroViewDelegate,MRRequestDelegate>
@property ABCIntroView *introView;

@end

@implementation GuidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor colorWithWhite:0.149 alpha:1.000];
        [self.view addSubview:self.introView];
    }
}
-(void)getNetwork
{
    MRRequest *request = [[MRRequest alloc] init];
    request.delegate = self;
    NSDictionary *parameters = @{@"cmd": @""};
    [request requestWithPath:@"" method:@"POST" parameters:parameters];
}
- (void)requestSucceeded:(NSDictionary *)userInfo connection:(NSURLConnection *)connection
{
    NSLog(@"输出userInfo%@",userInfo);
    NSLog(@"输出connection%@",connection);
}
#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.introView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.introView removeFromSuperview];
//    }];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [UIView animateWithDuration:.3 animations:^{
        [[app.wzWindow.rootViewController.view subviews] enumerateObjectsUsingBlock:^(UIView * subView, NSUInteger idx, BOOL *stop) {
            subView.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        [app.wzWindow setHidden:YES];
        [app.wzWindow resignKeyWindow];
        [app.window makeKeyAndVisible];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
