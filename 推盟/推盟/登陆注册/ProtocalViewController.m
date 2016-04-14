//
//  ProtocalViewController.m
//  推盟
//
//  Created by joinus on 15/9/6.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ProtocalViewController.h"

@interface ProtocalViewController ()

@end

@implementation ProtocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"注册服务协议";
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"system_close_image"];
    
    NSString * str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"protocol.txt" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    
    UITextView * myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, DEVICE_HEIGHT-64-20)];
    myTextView.editable = NO;
    myTextView.text = str;
    myTextView.font = [ZTools returnaFontWith:15];
    myTextView.textAlignment = NSTextAlignmentCenter;
    myTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
    myTextView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    myTextView.layer.borderWidth = 1;
    [self.view addSubview:myTextView];
}

-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
