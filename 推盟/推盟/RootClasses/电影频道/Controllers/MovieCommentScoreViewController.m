//
//  MovieCommentScoreViewController.m
//  推盟
//
//  Created by joinus on 16/3/8.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieCommentScoreViewController.h"

@interface MovieCommentScoreViewController ()<UITextViewDelegate>{
    UILabel * score_label;
    UILabel * introduce_label;
    DJWStarRatingView * starRatingView;
    CSNPlaceholderTextView * textView;
}

@end

@implementation MovieCommentScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"疯狂动物城";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"system_close_image"];
    
    [self createMainView];
    
}

-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createMainView{
    
    score_label = [ZTools createLabelWithFrame:CGRectMake(30, 40, DEVICE_WIDTH-60, 30) text:@"" textColor:RGBCOLOR(253, 180, 90) textAlignment:NSTextAlignmentCenter font:18];
    [self.view addSubview:score_label];
    
    introduce_label = [ZTools createLabelWithFrame:CGRectMake(30, score_label.bottom+5, DEVICE_WIDTH-60, 20) text:@"请滑动星星评分" textColor:RGBCOLOR(245,146,44) textAlignment:NSTextAlignmentCenter font:15];
    [self.view addSubview:introduce_label];
    //评分
    starRatingView = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(30, 30) numberOfStars:5 rating:5.0 fillColor:STAR_FILL_COLOR unfilledColor:STAR_UNFILL_COLOR strokeColor:STAR_STROKE_COLOR];
    starRatingView.padding = 5;
    starRatingView.minRating = 0.5;
    starRatingView.editable = YES;
    starRatingView.top = introduce_label.bottom+30;
    starRatingView.center = CGPointMake(DEVICE_WIDTH/2.0f, starRatingView.center.y);
    __weak typeof(self)wself = self;
    [starRatingView ratingChangeBlock:^(float rating) {
        
        int score = (int)(rating*2);
        if ([score_label.text intValue] != score) {
            [wself ratingChangedWithScore:(int)(rating*2)];
        }
    }];
    [self.view addSubview:starRatingView];
    
    //评论
    textView = [[CSNPlaceholderTextView alloc] initWithFrame:CGRectMake(25, starRatingView.bottom+30, DEVICE_WIDTH-50, 94)];
    textView.delegate = self;
    textView.placeholder = @"快来说说你的看法吧";
    textView.font = [ZTools returnaFontWith:15];
    textView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.cornerRadius = 3;
    [self.view addSubview:textView];
}


-(void)ratingChangedWithScore:(int)score{
    score_label.text = [NSString stringWithFormat:@"%d分",score];
    
    introduce_label.text = [MovieTools returnStateWithScore:score];
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
