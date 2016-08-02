//
//  GuideViewController.m
//  FirstTestOfXcode6
//
//  Created by soulnear on 14-12-9.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()<MYIntroductionDelegate>
{
    UIPageControl * pageControl;
    
    NSArray * font_array;
}

@end

@implementation GuideViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //隐藏status bar
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //STEP 1 Construct Panels
    MYIntroductionPanel * panel1 = [[MYIntroductionPanel alloc] initWithFrame:self.view.bounds title:@"" description:@"" image:[UIImage imageNamed:@"guide_one"]];
    MYIntroductionPanel * panel2 = [[MYIntroductionPanel alloc] initWithFrame:self.view.bounds title:@"" description:@"" image:[UIImage imageNamed:@"guide_two"]];
    MYIntroductionPanel * panel3 = [[MYIntroductionPanel alloc] initWithFrame:self.view.bounds title:@"" description:@"" image:[UIImage imageNamed:@"guide_three"]];
    MYIntroductionPanel * panel4 = [[MYIntroductionPanel alloc] initWithFrame:self.view.bounds title:@"" description:@"" image:[UIImage imageNamed:@"guide_four"]];
    MYIntroductionPanel * panel5 = [[MYIntroductionPanel alloc] initWithFrame:self.view.bounds title:@"" description:@"" image:[UIImage imageNamed:@"guide_five"]];

    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [introductionView buildIntroductionWithPanels:@[panel1,panel2,panel3,panel4,panel5]];
    [introductionView setBackgroundColor:[UIColor whiteColor]];
    introductionView.LanguageDirection = MYLanguageDirectionLeftToRight;
    
//    introductionView.SkipButton.hidden = NO;
//    introductionView.PageControl.hidden = NO;
    
    introductionView.PageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:37.0/255.0 green:49.0/255.0 blue:50.0/255.0 alpha:1.0];
    introductionView.PageControl.pageIndicatorTintColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    
    [introductionView.RightSkipButton setTitleColor:RGBCOLOR(175, 174, 174) forState:UIControlStateNormal];
    [introductionView.RightSkipButton setTitle:@"跳过>>" forState:UIControlStateNormal];
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [self.view addSubview:introductionView];
    
}
-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton || finishType == MYFinishTypeSwipeOut) {
        [self closeIntroductionView];
    }
}
-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
   
}

-(void)closeIntroductionView{
    AppDelegate* application  = [[UIApplication sharedApplication] delegate];
    [application resetInitialViewController];
    
    [[NSUserDefaults standardUserDefaults]
     setValue:CURRENT_BUILD
     forKey: @"isNeedToShowGuildView"];
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    AppDelegate* application  = [[UIApplication sharedApplication] delegate];
    [application resetInitialViewController];
    
    [[NSUserDefaults standardUserDefaults]
     setValue:CURRENT_BUILD
     forKey: @"isNeedToShowGuildView"];
}
-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
