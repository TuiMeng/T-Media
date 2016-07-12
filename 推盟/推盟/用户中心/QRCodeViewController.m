//
//  QRCodeViewController.m
//  推盟
//
//  Created by joinus on 15/9/10.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"二维码";
    
    
    [self setup];
}

-(void)setup{
    UIImageView * qrcode_imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-215)/2.0f, 30, 215, 215)];
    qrcode_imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:qrcode_imageView];
    
    //介绍
    UILabel * prompt_label = [ZTools createLabelWithFrame:CGRectMake(20, qrcode_imageView.bottom+30, DEVICE_WIDTH-40, 30) tag:-11 text:[NSString stringWithFormat:@"扫一扫上面的二维码，加入%@",APP_NAME] textColor:RGBCOLOR(153, 153, 153) textAlignment:NSTextAlignmentCenter font:15];
    [self.view addSubview:prompt_label];
    
    
    for (int i = 0; i < 2; i++) {
        UIImageView * line_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((DEVICE_WIDTH-100)/2.0f+100)*i, DEVICE_HEIGHT-64-120, (DEVICE_WIDTH-100)/2.0f, 1)];
        line_imageView.image = [UIImage imageNamed:@"root_line_view"];
        [self.view addSubview:line_imageView];
    }
    
    UILabel * tuimeng_label = [ZTools createLabelWithFrame:CGRectMake(0, 0, 100, 40) tag:-10 text:APP_NAME textColor:DEFAULT_BACKGROUND_COLOR textAlignment:NSTextAlignmentCenter font:28];
    tuimeng_label.center = CGPointMake(DEVICE_WIDTH/2.0f, DEVICE_HEIGHT-64-120+0.5);
    [self.view addSubview:tuimeng_label];
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
