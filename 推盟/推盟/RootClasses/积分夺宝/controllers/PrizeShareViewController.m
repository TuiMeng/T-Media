//
//  PrizeShareViewController.m
//  推盟
//
//  Created by joinus on 16/6/13.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeShareViewController.h"
#import "PrizeShareModel.h"
#import "WXUtil.h"
#import "SShareView.h"
#import "UIAlertView+Blocks.h"


@interface PrizeShareViewController ()<UITableViewDelegate,UITableViewDataSource>{
    /**
     *  被选中标题
     */
    NSString * title_string;
    /**
     *  当前第几个被选中
     */
    int current;
    
    SShareView * shareView;
    
    AMapLocationManager * locationManager;
    NSString * location_city;

}

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)PrizeShareModel * model;

@end

@implementation PrizeShareViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"分享页";
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.delegate       = self;
    _myTableView.dataSource     = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.bounces        = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    [self createFooterView];
    [self getTitlesData];
}

#pragma mark ------ 初始化
-(PrizeShareModel *)model{
    if (!_model) {
        _model = [PrizeShareModel sharedInstance];
    }
    return _model;
}
#pragma mark --------  创建footer视图
-(void)createFooterView{
    
    UIView * footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
    footer_view.backgroundColor = [UIColor whiteColor];
    
    
    SLabel * label = [[SLabel alloc] initWithFrame:CGRectMake(10,15,DEVICE_WIDTH-20,30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [ZTools returnaFontWith:12];
    label.textColor = DEFAULT_LINE_COLOR;
    label.hidden = ![ZTools isLogIn];
    
    [footer_view addSubview:label];
    
    if ([ZTools getGrade] == 2) {
        label.text = [NSString stringWithFormat:@"您是高级用户，该任务每次转发点击收益为：%@积分/次",_numForLotteryOnce];
    }else if([ZTools getGrade] == 1){
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonalInfomation)];
        [label addGestureRecognizer:tap];
        
        NSString * str = @"您是普通用户无法参与本次活动（立即升级为高级用户）参加此次活动";
        NSMutableAttributedString * attributed_string = [ZTools labelTextColorWith:str Color:DEFAULT_BACKGROUND_COLOR range:[str rangeOfString:@"立即升级为高级用户"]];
        [attributed_string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[str rangeOfString:@"立即升级为高级用户"]];
        label.attributedText = attributed_string;
    }
    
    UIButton * share_button = [UIButton buttonWithType:UIButtonTypeCustom];
    share_button.frame = CGRectMake((DEVICE_WIDTH-150)/2.0f,label.bottom + 10, 150, 45);
    share_button.layer.cornerRadius = 5;
    share_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [share_button setTitle:@"分  享" forState:UIControlStateNormal];
    [share_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [share_button addTarget:self action:@selector(shareButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [footer_view addSubview:share_button];
    
    
//    if (_task_model.task_status.intValue != 1) {
//        share_button.backgroundColor = [UIColor lightGrayColor];
//        share_button.userInteractionEnabled = NO;
//        [share_button setTitle:@"已结束" forState:UIControlStateNormal];
//    }
    
    _myTableView.tableFooterView = footer_view;
}


#pragma mark ------  网络请求
-(void)getTitlesData{
    __WeakSelf__ wself = self;
    [self.model loadTitlesDataWithTaskId:_task_id success:^{
        [wself.myTableView reloadData];
    } failed:^(NSString *errorInfo) {
        [ZTools showMBProgressWithText:errorInfo WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark ------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrizeShareModel * model = _model.dataArray[indexPath.row];
    CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:model.title_name WithWidth:DEVICE_WIDTH-40];
    return size.height+40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    PrizeShareModel * model = _model.dataArray[indexPath.row];
    
    NSString * title = model.title_name;
    CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:title WithWidth:DEVICE_WIDTH-40];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, DEVICE_WIDTH-40, size.height)];
    label.text = title;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [ZTools returnaFontWith:15];
    [cell.contentView addSubview:label];
    if (current == indexPath.row) {
        label.textColor = DEFAULT_BACKGROUND_COLOR;
    }
    
    UIImageView * line_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, size.height+40-0.5, DEVICE_WIDTH-20, 0.5)];
    line_imageView.image = [UIImage imageNamed:@"root_line_view"];
    [cell.contentView addSubview:line_imageView];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    header_view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,DEVICE_WIDTH-40,30)];
    label.text = @"任意选择下方标题";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = DEFAULT_BACKGROUND_COLOR;
    label.font = [ZTools returnaFontWith:18];
    [header_view addSubview:label];
    
    UIImageView * line_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, header_view.height-0.5, DEVICE_WIDTH-20, 0.5)];
    line_imageView.image = [UIImage imageNamed:@"root_line_view"];
    [header_view addSubview:line_imageView];
    
    return header_view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == current) {
        return;
    }
    
    PrizeShareModel * model = _model.dataArray[indexPath.row];
    
    title_string = model.title_name;
    current = (int)indexPath.row;
    [tableView reloadData];
}


#pragma mark ----  分享按钮
#pragma mark ----  分享 ----
-(void)shareButtonTap:(UIButton*)sender{
    
    if (![ZTools isLogIn]) {
        [self performSegueWithIdentifier:@"showLoginSegue" sender:@"share"];
        return;
    }
    
    if (title_string.length == 0)
    {
        [ZTools showMBProgressWithText:@"请选择一个分享标题" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
//    UIImage *shareImage = _shareImage?_shareImage:[UIImage imageNamed:@"default_share_image"];
    UMSocialUrlResource * url_resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_shareImageUrl];
    __weak typeof(self)wself = self;
    
    
    NSArray * spread_type;
    NSString * userId = [ZTools getUid];
    NSString * dateline = [ZTools timechangeToDateline];
    //加密字符串
    NSString * sign = [[WXUtil md5:[NSString stringWithFormat:@"%@%@%@%@",[ZTools getPhoneNum],userId,_task_id,dateline]] lowercaseString];
    
    //分享到第三方平台的链接地址
    NSString * share_string = [NSString stringWithFormat:@"%@&user_id=%@&task_id=%@&sign=%@",SHARE_CONTENT_URL,[ZTools getUid],_task_id,sign];
    NSLog(@"share_content_url ------   %@",share_string);
    
    if ([[ZTools replaceNullString:_model.share_type WithReplaceString:@""] length] == 0) {
        spread_type = @[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE];
    }else{
        spread_type = [_model.share_type componentsSeparatedByString:@"|"];
    }
    shareView = [[SShareView alloc] initWithTitles:spread_type
                                             title:nil
                                           content:title_string
                                               Url:share_string
                                             image:nil
                                          location:nil
                                       urlResource:url_resource
                               presentedController:self];
    
    shareView.string_copy = [ZTools getInvitationCode];
    [shareView showInView:self.navigationController.view];
    
    __weak typeof(shareView)wShareView = shareView;
    [shareView shareButtonClicked:^(NSString *snsName, NSString *shareType) {
        [wself shareToThirdPartyWithSNS:snsName Type:shareType];
    }];
    
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [wself shareTaskRequestWithType:type sign:sign dateline:dateline];
    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

-(void)shareToThirdPartyWithSNS:(NSString *)snsName Type:(NSString *)type{
    [shareView ShareViewRemoveFromSuperview];
    UIAlertView * alertView = [UIAlertView showWithTitle:[NSString stringWithFormat:@"为确保正常的统计，分享完成后必须返回%@",APP_NAME] message:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        [shareView shareWithSNS:snsName WithShareType:type];
    }];
    [alertView show];
}

#pragma mark ----- 分享完成
-(void)shareTaskRequestWithType:(NSString*)type sign:(NSString *)sign dateline:(NSString *)dateline
{
    __weak typeof(self)wself = self;
    NSString * ip = [ZTools getIPAddress];
    
    NSDictionary * dic = @{@"task_id":_task_id,
                           @"user_id":[ZTools getUid],
                           @"share_type":type,
                           @"gps_city":location_city.length?location_city:@"",
                           @"mobile_city":[ZTools getPhoneNumAddress],
                           @"ip_city":ip.length?ip:@"",
                           @"sign":sign,
                           @"dateline":dateline
                           };
    
    NSLog(@"dic -----  %@",dic);
    
    [[ZAPI manager] sendPost:PRIZE_SHARE_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:ERROR_CODE];
            if ([status intValue] == 1)
            {
                [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }else
            {
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [ZTools showMBProgressWithText:@"分享失败，请检查您当前网络" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark ---------  获取用户地理位置信息
- (void) setupLocationManager {
    
    //高德地图
    [AMapLocationServices sharedServices].apiKey = AMAP_KEY;
    
    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    locationManager.locationTimeout = 3;
    locationManager.reGeocodeTimeout = 3;
    
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                
            }
        }
        
        if (regeocode)
        {
            NSLog(@"regeoco.city ----  %@",regeocode.formattedAddress);
            NSString * local = regeocode.city?regeocode.city:regeocode.formattedAddress;
            location_city = [ZTools CutAreaString:local];
        }
    }];
}



@end









