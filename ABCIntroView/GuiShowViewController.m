//
//  GuiShowViewController.m
//  ABCIntroView
//
//  Created by li on 15/10/21.
//  Copyright © 2015年 Adam Cooper. All rights reserved.
//

#import "GuiShowViewController.h"
#import "ABCIntroView.h"
@interface GuiShowViewController ()<ABCIntroViewDelegate>
@property ABCIntroView *introView;

@end

@implementation GuiShowViewController

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
#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}- (void)didReceiveMemoryWarning {
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
