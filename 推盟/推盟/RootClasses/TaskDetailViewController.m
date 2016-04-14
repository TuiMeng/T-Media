//
//  TaskDetailViewController.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "TaskDetailViewController.h"

@interface TaskDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
//顶部背景图
@property (weak, nonatomic) IBOutlet UIView *top_background_view;
//转发按钮
@property (weak, nonatomic) IBOutlet UIButton *share_button;

//单价介绍
@property (weak, nonatomic) IBOutlet UILabel *introduction_label;

//总奖金数
@property (weak, nonatomic) IBOutlet UILabel *all_money_label;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;


@property(nonatomic,assign)float lastPosition;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    _myWebView.delegate = self;
    _myWebView.scrollView.delegate = self;
    _myWebView.scalesPageToFit = YES;
    //加上手机号码，根据手机号码h5判断是否要显示下载按钮，为了通过审核
    if ([[ZTools getPhoneNum] isEqualToString:@"18600755163"] || ![ZTools isLogIn]) {
        [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mobile=18600755163",_task_model.content]]]];
        NSLog(@"----请求带手机号码的 ---  %@",[NSString stringWithFormat:@"%@?mobile=18600755163",_task_model.content]);
    }else{
        [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task_model.content]]];
        NSLog(@"------- 请求不带手机号码的 ---  %@",_task_model.content);
    }
    
    _all_money_label.text = [NSString stringWithFormat:@"奖金￥%@",_task_model.total_task];
    _introduction_label.text = [NSString stringWithFormat:@"普通会员:￥%@/点击\n高级会员:￥%@/点击",_task_model.task_price,_task_model.gao_click_price];
}


-(void)setup{
    _top_background_view.hidden = YES;
    _top_background_view.backgroundColor = DEFAULT_YELLOW_COLOR;
    _share_button.layer.cornerRadius = 5;
    _share_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _all_money_label.numberOfLines = 0;
}

#pragma mark ***************UIWebViewDelegate*****************
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title_label.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*
    float currentPostion = scrollView.contentOffset.y;
    if ((currentPostion > _lastPosition && currentPostion > 0))
    {
        [self setTopViewHidden:YES];
        
    }else if (_lastPosition > currentPostion && scrollView.contentSize.height-(DEVICE_HEIGHT-64) > currentPostion)
    {
        [self setTopViewHidden:NO];
    }
    
    _lastPosition = currentPostion;
     */
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}


-(void)setTopViewHidden:(BOOL)hidden{
    [UIView animateWithDuration:0.4 animations:^{
        _top_background_view.top = hidden?-75:0;
        _myWebView.top = hidden?0:_top_background_view.bottom;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ---  转发按钮
- (IBAction)shareButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"showShareVCSegue" sender:_task_model.encrypt_id];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showShareVCSegue"]) {
        UIViewController * vc = segue.destinationViewController;
        [vc setValue:sender forKey:@"task_id"];
    }
}


@end
