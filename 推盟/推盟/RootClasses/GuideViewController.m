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
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"introduction_view_one.png"] description:@""];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"introduction_view_two.png"] description:@""];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"introduction_view_three.png"] description:@""];
    
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:self.view.bounds panels:@[panel,panel2,panel3] languageDirection:MYLanguageDirectionLeftToRight];//[[MYIntroductionView alloc] initWithFrame:self.view.bounds panels:@[panel,panel2,panel3]];
    NSLog(@"--------%@",NSStringFromCGRect(introductionView.bounds));
    [introductionView setBackgroundColor:[UIColor whiteColor]];
    
    introductionView.SkipButton.hidden = YES;
    introductionView.PageControl.hidden = YES;
    
//    introductionView.PageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:37.0/255.0 green:49.0/255.0 blue:50.0/255.0 alpha:1.0];
//    introductionView.PageControl.pageIndicatorTintColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
    
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
