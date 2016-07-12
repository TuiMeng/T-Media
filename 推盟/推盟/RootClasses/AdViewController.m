//
//  AdViewController.m
//  推盟
//
//  Created by joinus on 15/12/23.
//  Copyright © 2015年 joinus. All rights reserved.
//

#import "AdViewController.h"
#import "AppDelegate.h"
#import "SWebViewController.h"
#import "ViewController.h"

@interface AdViewController (){
    NSTimer * timer;
    NSDictionary * data_dic;
}
//背景图
@property (strong, nonatomic) UIImageView *ad_background_imageView;
//广告图
@property (strong, nonatomic) UIImageView *ad_imageView;
//取消按钮
@property (strong, nonatomic) UIButton *cancel_button;


@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image;
    if (DEVICE_WIDTH == 320) {
        if (DEVICE_HEIGHT == 480) {
            image = IS_YML?[UIImage imageNamed:@"yml_app4"]:[UIImage imageNamed:@"ad_app4"];
        }else{
            image = IS_YML?[UIImage imageNamed:@"yml_app5"]:[UIImage imageNamed:@"ad_app5"];
        }
    }
    
    if (DEVICE_WIDTH == 375) {
        image = IS_YML?[UIImage imageNamed:@"yml_app6"]:[UIImage imageNamed:@"ad_app6"];
    }
    if (DEVICE_WIDTH == 414) {
        image = IS_YML?[UIImage imageNamed:@"yml_app6p"]:[UIImage imageNamed:@"ad_app6p"];
    }
    
    _ad_background_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _ad_background_imageView.image = image;
    [self.view addSubview:_ad_background_imageView];
    
    CGFloat ad_height = DEVICE_WIDTH*10/7.0;
    if (DEVICE_WIDTH == 320 && DEVICE_HEIGHT==480) {
        ad_height = 772/2.0f;
    }
    _ad_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,ad_height)];
    _ad_imageView.userInteractionEnabled = YES;
    [self.view addSubview:_ad_imageView];
    
    UITapGestureRecognizer * ad_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTap:)];
    [_ad_imageView addGestureRecognizer:ad_tap];
    
    
    _cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel_button.frame = CGRectMake(DEVICE_WIDTH-60, 20, 60, 24);
    _cancel_button.adjustsImageWhenHighlighted = NO;
    [_cancel_button setImage:[UIImage imageNamed:@"ad_cancel_image"] forState:UIControlStateNormal];
    [_cancel_button addTarget:self action:@selector(cancelButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_button];
    
    [self loadAdData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _cancel_button = nil;
    [timer invalidate];
    timer = nil;
    _ad_imageView = nil;
    _ad_background_imageView = nil;
}

-(void)loadAdData{
    __weak typeof(self)wself = self;
    NSURLSessionDataTask * task = [[ZAPI manager] sendGet:GET_GUANGGAO_IMAGE_URL success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            data_dic = (NSDictionary*)data;
            if ([data[@"status"] intValue] == 1) {
                [wself.ad_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"ad_url"]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        [wself cancelButtonTap:nil];
                    }
                }];
                
                [wself addTimerWithDelay:[data[@"dateline"] floatValue]];
            }else{
                [wself cancelButtonTap:nil];
            }
        }
    } failure:^(NSError *error) {
        [wself cancelButtonTap:nil];
    }];
    
    
}
#pragma mark ----  增加计时器
-(void)addTimerWithDelay:(CGFloat)delay{
    timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(cancelButtonTap:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

#pragma mark ----   跳过广告
-(void)cancelButtonTap:(UIButton *)button{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate resetInitialViewController];
}

#pragma mark -----   浏览广告
-(void)adTap:(UITapGestureRecognizer*)sender{
    [timer invalidate];
    timer = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:data_dic[@"link"] forKey:@"adlink"];
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate resetInitialViewController];
    
    
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
