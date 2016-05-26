//
//  MPulishCommentViewController.m
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MPublishCommentViewController.h"
#import "UIAlertView+Blocks.h"


@interface MPublishCommentViewController (){
    UILabel * score_label;
    CSNPlaceholderTextView * textView;
    DJWStarRatingView * starRatingView;
}

@end

@implementation MPublishCommentViewController
    

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"我要评论";
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"system_close_image"];
    
    UIButton * rightButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame                       = CGRectMake(0, 0, 45, 25);
    rightButton.layer.cornerRadius          = 3;
    rightButton.layer.borderWidth           = 1;
    rightButton.layer.borderColor           = [UIColor whiteColor].CGColor;
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font             = [ZTools returnaFontWith:13];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(uploadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    [self createMainView];
    
}

-(void)leftButtonTap:(UIButton *)sender{
    __weak typeof(self)wself = self;
    if (starRatingView.rating || textView.text.length != 0) {
        UIAlertView * alertView = [UIAlertView showWithTitle:@"退出此次编辑？" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"退出"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [wself dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [alertView show];
        return;
    }
    [wself dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadButtonClicked:(UIButton *)sender{
    [self uploadComment];
}


-(void)createMainView{
    
    starRatingView = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(30, 30) numberOfStars:5 rating:0 fillColor:STAR_FILL_COLOR unfilledColor:STAR_UNFILL_COLOR strokeColor:[UIColor clearColor]];
    starRatingView.top = 15;
    starRatingView.left = 15;
    starRatingView.editable = YES;
    starRatingView.minRating = 0.5;
    [self.view addSubview:starRatingView];
    __weak typeof(self)wself = self;
    [starRatingView ratingChangeBlock:^(float rating) {
        int score = (int)(rating*2);
        [wself ratingChangedWithRating:score];
    }];
    
    
    score_label = [ZTools createLabelWithFrame:CGRectMake(starRatingView.right+5, starRatingView.top, DEVICE_WIDTH-starRatingView.right-20, starRatingView.height) text:@"" textColor:DEFAULT_ORANGE_TEXT_COLOR textAlignment:NSTextAlignmentRight font:16];
    [self.view addSubview:score_label];
    
    textView = [[CSNPlaceholderTextView alloc] initWithFrame:CGRectMake(15, starRatingView.bottom+10, DEVICE_WIDTH-30, 100)];
    textView.font = [ZTools returnaFontWith:15];
    textView.placeholder = @"快来说说你的看法吧";
    [self.view addSubview:textView];
}

-(void)ratingChangedWithRating:(int)score{
    score_label.text = [NSString stringWithFormat:@"%d分 %@",score,[MovieTools returnStateWithScore:score]];
}


#pragma mark ------  发表评论
-(void)uploadComment{
    
    if (starRatingView.rating == 0) {
        [ZTools showMBProgressWithText:@"请先评分" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    MBProgressHUD * loadingHUD = [ZTools showMBProgressWithText:@"评分提交中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"movieId":_movieId,
                           @"userId":[ZTools getUid],
                           @"content":textView.text.length?textView.text:@"",
                           @"score":[NSString stringWithFormat:@"%d",(int)(starRatingView.rating*2)],
                           @"picUrl":[NSString stringWithFormat:@"http://static.twttmob.com/h5/headImg/%d.png",arc4random()%30+1],
                           @"userName":[ZTools getUserName]};
    
    [[ZAPI manager] sendMoviePost:M_PUBLISH_COMMENTS_URL myParams:dic success:^(id data) {
        [loadingHUD hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[MOVIE_ERROR_CODE] intValue] == 0) {
                [ZTools showMBProgressWithText:@"评论成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                [wself disappearWithPOP:NO afterDelay:1.6f];
            }else{
                [ZTools showMBProgressWithText:data[@"message"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [loadingHUD hide:YES];
    }];
}


@end










