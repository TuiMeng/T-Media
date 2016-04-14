//
//  SWebViewController.m
//  推盟
//
//  Created by joinus on 15/10/21.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "SWebViewController.h"

@interface SWebViewController ()<UIWebViewDelegate>{
    
}

@property(nonatomic,strong)UIWebView * myWebView;

@end

@implementation SWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _myWebView.delegate = self;
    _myWebView.scalesPageToFit = YES;
    [self.view addSubview:_myWebView];
    
    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title_label.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
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
