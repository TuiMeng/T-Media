//
//  ShareViewController.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ShareViewController.h"
#import "LogInViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WXUtil.h"
#import "UIAlertView+Blocks.h"

@interface ShareViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    /**
     *  被选中标题
     */
    NSString * title_string;
    /**
     *  当前第几个被选中
     */
    int current;
    
    SShareView * shareView;
    
    CLLocationManager * locationManager;
    /**
     *  获取到的地区
     */
    NSString * location_city;
    /**
     *  点击分享的时间
     */
    NSDate * share_date;
    
    UIImageView * selected_photo_imageView;
}


@property(nonatomic,strong)NSMutableArray * data_array;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"抢单页";
//    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"相册"];
    
    
    current = 1000;
    _data_array                 = [NSMutableArray array];
    self.task_model             = [[RootTaskListModel alloc] init];
    
    _myTableView.delegate       = self;
    _myTableView.dataSource     = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.bounces        = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    
    [self startLoading];
    [self loadTaskDetailData];
    
    [self setupLocationManager];
    
    share_date = [NSDate date];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self userDidTakeScreenshot:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    if (shareView) {
        [shareView ShareViewRemoveFromSuperview];
    }
}
-(void)applicationWillEnterForeground:(NSNotification*)notification{
//    [self userDidTakeScreenshot:nil];
    if (_task_model.task_status.intValue == 1) {
        [self reloadImagesFromLibrary];
    }
}


-(void)rightButtonTap:(UIButton *)sender{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

#pragma mark -----   获取任务详细信息
-(void)loadTaskDetailData{
    
    __weak typeof(self)wself = self;
    NSLog(@"share ----  %@",[NSString stringWithFormat:@"%@&task_id=%@&user_id=%@",GET_TASK_TITLE_URL,self.task_id,[ZTools getUid]]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&task_id=%@&user_id=%@",GET_TASK_TITLE_URL,self.task_id,[ZTools getUid]] success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] == 1) {
                NSArray * array = [data objectForKey:@"title_list"];
                [wself.data_array addObjectsFromArray:array];
                
                NSDictionary * dic                  = [data objectForKey:@"task"];
                wself.task_model.encrypt_id         = [dic objectForKey:@"task_id"];
                wself.task_model.content            = [dic objectForKey:@"content"];
                wself.task_model.task_img           = [dic objectForKey:@"task_img"];
                wself.task_model.task_status        = [dic objectForKey:@"task_status"];
                wself.task_model.task_price         = [dic objectForKey:@"task_price"];
                wself.task_model.gao_click_price    = [dic objectForKey:@"gao_click_price"];
                wself.task_model.spread_type        = [ZTools replaceNullString:[dic objectForKey:@"spread_type"] WithReplaceString:@""];
                
                wself.task_model.canUploadImage     = [dic objectForKey:@"canUploadImage"];
                wself.task_model.img_num            = [dic objectForKey:@"img_num"];
                wself.task_model.is_upload          = [dic objectForKey:@"is_upload"];
                wself.task_model.refuse             = [dic objectForKey:@"refuse"];
                wself.task_model.imgover_time       = [dic objectForKey:@"imgover_time"];
                wself.task_model.RAStatus           = [dic objectForKey:@"RAStatus"];
                wself.task_model.img_price          = [dic objectForKey:@"img_price"];
                
                [wself createFooterView];
            }
            [wself.myTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

#pragma mark=============   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:15] WithString:_data_array[indexPath.row][@"name"] WithWidth:DEVICE_WIDTH-40];
    return size.height+40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSString * title = _data_array[indexPath.row][@"name"];
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
    
    share_date = [NSDate date];
    
    title_string = _data_array[indexPath.row][@"name"];
    current = (int)indexPath.row;
    [tableView reloadData];
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
        label.text = [NSString stringWithFormat:@"您是高级用户，该任务每次转发点击收益为：%@积分/次",_task_model.gao_click_price];
    }else if([ZTools getGrade] == 1){
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonalInfomation)];
        [label addGestureRecognizer:tap];
        
        NSString * str = [NSString stringWithFormat:@"您是普通用户单次点击积分为%@积分（立即升级为高级用户）单次点击积分为%@积分",_task_model.task_price,_task_model.gao_click_price];
        NSMutableAttributedString * attributed_string = [ZTools labelTextColorWith:str Color:DEFAULT_BACKGROUND_COLOR range:[str rangeOfString:@"立即升级为高级用户"]];
        [attributed_string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[str rangeOfString:@"立即升级为高级用户"]];
        label.attributedText = attributed_string;
    }
    
    UIButton * share_button = [UIButton buttonWithType:UIButtonTypeCustom];
    share_button.frame = CGRectMake((DEVICE_WIDTH-150)/2.0f,label.bottom + 10, 150, 45);
    share_button.layer.cornerRadius = 5;
    share_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [share_button setTitle:@"抢单" forState:UIControlStateNormal];
    [share_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [share_button addTarget:self action:@selector(shareButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [footer_view addSubview:share_button];
    
    
    if (_task_model.task_status.intValue != 1) {
        share_button.backgroundColor = [UIColor lightGrayColor];
        share_button.userInteractionEnabled = NO;
        [share_button setTitle:@"已结束" forState:UIControlStateNormal];
    }
    
    //判断是否可以上传转发截图
    if (_task_model.canUploadImage.intValue == 1 && _task_model.is_upload.intValue == 2) {
        
        UIView * share_screenshot_background_view = [[UIView alloc] initWithFrame:CGRectMake(0, share_button.bottom+20, DEVICE_WIDTH, 300)];
        share_screenshot_background_view.backgroundColor = RGBCOLOR(239, 239, 239);
        [footer_view addSubview:share_screenshot_background_view];
        
        UIView * share_selected_image_background_view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, share_screenshot_background_view.height-20)];
        share_selected_image_background_view.backgroundColor = [UIColor whiteColor];
        [share_screenshot_background_view addSubview:share_selected_image_background_view];
        
        float imageViewTop = 10;
        
        if (_task_model.img_price.intValue != 0) {
            imageViewTop += 40;
            UILabel * prompt_label = [ZTools createLabelWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 40)
                                                             text:[NSString stringWithFormat:@"上传转发截图，有机会获取%@积分奖励,共%@个名额，%@活动截止",_task_model.img_price,_task_model.img_num,[ZTools timechangeWithTimestamp:_task_model.imgover_time WithFormat:@"YYYY-MM-dd"]]
                                                        textColor:RGBCOLOR(251, 75, 78)
                                                    textAlignment:NSTextAlignmentCenter
                                                             font:15];
            prompt_label.numberOfLines = 0;
            [share_selected_image_background_view addSubview:prompt_label];
        }
        
        selected_photo_imageView                = [[UIImageView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-200)/2.0f, imageViewTop+10, 200, 200)];
        selected_photo_imageView.userInteractionEnabled = YES;
        selected_photo_imageView.clipsToBounds  = YES;
        selected_photo_imageView.contentMode    = UIViewContentModeScaleAspectFit;
        selected_photo_imageView.image          = [UIImage imageNamed:@"share_photo_background_image"];
        [share_selected_image_background_view addSubview:selected_photo_imageView];
        
        UITapGestureRecognizer * choosePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [selected_photo_imageView addGestureRecognizer:choosePhotoTap];
        
        //重新选取图片+上传
        NSArray * title_array = @[@"选择图片",@"上 传"];
        for (int i = 0; i < 2; i++) {
            
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake(0, selected_photo_imageView.bottom+30, 70, 30)
                                                          tag:100+i
                                                        title:title_array[i]
                                                        image:nil];
            button.center = CGPointMake(DEVICE_WIDTH/2.0f/2.0f + (DEVICE_WIDTH/2.0f)*i, button.center.y);
            button.titleLabel.font = [ZTools returnaFontWith:15];
            [button addTarget:self action:@selector(choosePhotoButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [share_selected_image_background_view addSubview:button];
        }
        
        share_screenshot_background_view.height         = selected_photo_imageView.bottom + 120;
        share_selected_image_background_view.height     = share_screenshot_background_view.height-20;
        footer_view.height                              = share_screenshot_background_view.bottom;
    }
    
    if (_task_model.is_upload.intValue == 1 && _task_model.img_price.integerValue != 0) {
        UILabel * prompt_label = [ZTools createLabelWithFrame:CGRectMake(10, share_button.bottom+20, DEVICE_WIDTH-20, 60)
                                                         text:@""
                                                    textColor:RGBCOLOR(251, 75, 78)
                                                textAlignment:NSTextAlignmentCenter
                                                         font:15];
        prompt_label.backgroundColor = [UIColor whiteColor];
        prompt_label.numberOfLines = 0;
        [footer_view addSubview:prompt_label];
        
        footer_view.height = prompt_label.bottom;
        
        if (_task_model.RAStatus.intValue == 1) {       //正在审核中
            prompt_label.text = [NSString stringWithFormat:@"已收到您上传的截图，%@活动结束后，后台工作人员审核完毕后，我们会截取前%@名发放奖励",[ZTools timechangeWithTimestamp:_task_model.imgover_time WithFormat:@"MM-dd"],_task_model.img_num];
        }else if (_task_model.RAStatus.intValue == 2){  //审核通过
            prompt_label.text = [NSString stringWithFormat:@"恭喜您通过审核，%@积分奖励已经发放到您的账户",_task_model.img_price];
        }else if (_task_model.RAStatus.intValue == 3){  //被拒绝
            prompt_label.text = _task_model.refuse.length?[NSString stringWithFormat:@"审核未通过：%@",_task_model.refuse]:@"您的截图未通过审核";
        }
    }

    _myTableView.tableFooterView = footer_view;
}

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
    
    UIImage * cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_task_model.task_img];
    
    UIImage *shareImage = cacheImage?cacheImage:(IS_YML?[UIImage imageNamed:@"yml_Icon"]:[UIImage imageNamed:@"Icon"]);
    UMSocialUrlResource * url_resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_task_model.task_img];
    __weak typeof(self)wself = self;
    
    NSArray * spread_type;
    NSString * userId = [ZTools getUid];
    NSString * dateline = [ZTools timechangeToDateline];
    //加密字符串
    NSString * sign = [[WXUtil md5:[NSString stringWithFormat:@"%@%@%@%@",[ZTools getPhoneNum],userId,_task_id,dateline]] lowercaseString];
    
    //分享到第三方平台的链接地址
    NSString * share_string = [NSString stringWithFormat:@"%@&user_id=%@&task_id=%@&sign=%@",SHARE_CONTENT_URL,[ZTools getUid],_task_id,sign];
    NSLog(@"share_content_url ------   %@",share_string);
    
    if ([[ZTools replaceNullString:_task_model.spread_type WithReplaceString:@""] length] == 0) {
        spread_type = @[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE];
    }else{
        spread_type = [_task_model.spread_type componentsSeparatedByString:@"|"];
    }
    shareView = [[SShareView alloc] initWithTitles:spread_type
                                             title:nil
                                           content:title_string
                                               Url:share_string
                                             image:shareImage
                                          location:nil
                                       urlResource:nil
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
    
    /*
    
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",nil];
    [editActionSheet showInView:self.view];
     */
    
}

-(void)shareToThirdPartyWithSNS:(NSString *)snsName Type:(NSString *)type{
    [shareView ShareViewRemoveFromSuperview];
    UIAlertView * alertView = [UIAlertView showWithTitle:[NSString stringWithFormat:@"为确保正常的统计，分享完成后必须返回%@",APP_NAME] message:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        [shareView shareWithSNS:snsName WithShareType:type];
    }];
    [alertView show];
}

/*
#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * share_type = @"";
    //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName;// = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    
    NSString * share_url = [NSString stringWithFormat:SHARE_CONTENT_URL,[ZTools getUid],_task_model.encrypt_id];
    
    switch (buttonIndex) {
        case 0://微信好友
        {
            share_type = @"微信好友";
            snsName = @"wxsession";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = share_url;
            
        }
            break;
        case 1://微信朋友圈
        {
            share_type = @"微信朋友圈";
            snsName = @"wxtimeline";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = share_url;
            
        }
            break;
        case 2://取消
        {
            return;
        }
            break;
            
        default:
            break;
    }
    
    UIImage *shareImage = _shareImage?_shareImage:[UIImage imageNamed:@"default_share_image"];
    __weak typeof(self)bself = self;
    
    UMSocialUrlResource * url_resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_task_model.task_img];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[snsName] content:title_string image:shareImage location:nil urlResource:url_resource presentedController:self completion:^(UMSocialResponseEntity * response)
     {
         if (response.responseCode == UMSResponseCodeSuccess)
         {
             [bself shareTaskRequestWithType:share_type WithSns:snsName];
         } else if(response.responseCode != UMSResponseCodeCancel) {
             [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
         }
     }];
}
 */

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
    
    [[ZAPI manager] sendPost:SHARE_URL myParams:dic success:^(id data) {
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

#pragma mark -----   跳转到个人信息界面
-(void)showPersonalInfomation{
    [self performSegueWithIdentifier:@"showPersonalInfoSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)successLoginWithSource:(NSString*)source{
    if ([source isEqualToString:@"personal"]) {
        [self performSegueWithIdentifier:@"showPersonalCenterSegue" sender:nil];
    }else if ([source isEqualToString:@"share"]){
        [self performSegueWithIdentifier:@"ShowSharePageSegue" sender:nil];
    }
}



#pragma mark ---------  获取用户地理位置信息
- (void) setupLocationManager {
    
    locationManager = [[CLLocationManager alloc] init] ;
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }else{
        //定位未开启
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            location_city = [ZTools CutAreaString:placemark.administrativeArea];
            NSLog(@"city ----  %@",location_city);
        }
    }];
}


#pragma mark --------  UIImagePickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * newImage = [ZTools scaleImage:[ZTools OriginImage:image scaleToSize:CGSizeMake(image.size.width*0.75, image.size.height*0.75)] toScale:0.5];
    
    image = nil;
    
    if (newImage) {
        selected_photo_imageView.image = newImage;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -------  检测系统截屏通知
-(void)userDidTakeScreenshot:(NSNotification*)notification{
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image_ = [self imageWithScreenshot];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160,280, 160, 280)];
    imageView.image = image_;
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
}

- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

#pragma mark --------   选取相册图片
-(void)choosePhotoButtonTap:(UIButton*)sender{
    
    if (sender.tag == 100)//重新选择图片
    {
        [self choosePhoto];
    }else if (sender.tag == 101)//上传图片
    {
        [self uploadImageData];
    }
}

-(void)choosePhoto{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    pickerImage.navigationBar.barTintColor = DEFAULT_BACKGROUND_COLOR;
    pickerImage.navigationBar.tintColor = [UIColor whiteColor];
    
    [self presentViewController:pickerImage animated:YES completion:nil];
}


- (void)uploadImageData {
    
    [self startLoading];
    __weak typeof(self)wself = self;
    
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                               URLString:TASK_UPLOAD_IMAGE_URL
                                                                                              parameters:@{@"user_id":[ZTools getUid],@"task_id":_task_id}
                                                                               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        
        NSData * ImageData = UIImageJPEGRepresentation(selected_photo_imageView.image, 1);
        
        [formData appendPartWithFileData:ImageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];

    } error:nil];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSURLSessionUploadTask * uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            [wself endLoading];
            NSData* data= (NSData *)responseObject;
            NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"string ---  %@",string);
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                if ([dict[ERROR_CODE] intValue] == 1) {
                    [ZTools showMBProgressWithText:@"图片上传成功，等待后台人员审核" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                }else{
                    [ZTools showMBProgressWithText:dict[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                }
            }
        }

    }];
    
    
    [uploadTask resume];
    
}




#pragma mark --------  获取相册图片
- (void)reloadImagesFromLibrary
{
    /*ios8
     // 获取所有资源的集合，并按资源的创建时间排序
     PHFetchOptions *options = [[PHFetchOptions alloc] init];
     options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
     PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
     // 这时 assetsFetchResults 中包含的，应该就是各个资源（PHAsset）
     //    for (NSInteger i = 0; i < fetchResult.count; i++) {
     //        // 获取一个资源（PHAsset）
     //        PHAsset *asset = fetchResult[i];
     //    }
     
     // 在资源的集合中获取第一个集合，并获取其中的图片
     PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
     PHAsset *asset = assetsFetchResults[assetsFetchResults.count-1];
     [imageManager requestImageForAsset:asset
     targetSize:CGSizeMake(640, 1136)
     contentMode:PHImageContentModeAspectFill
     options:nil
     resultHandler:^(UIImage *result, NSDictionary *info) {
     
     // 得到一张 UIImage，展示到界面上
     
     UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160,280, 160, 280)];
     imageView.image = result;
     imageView.center = self.view.center;
     [self.view addSubview:imageView];
     
     }];
     */
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                
                NSDate * date = [alAsset valueForProperty:ALAssetPropertyDate];
                
                if ([share_date timeIntervalSinceDate:date] > 0) {
                    UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    *stop = YES; *innerStop = YES;
                    
                    selected_photo_imageView.image = [ZTools OriginImage:latestPhoto scaleToSize:CGSizeMake(latestPhoto.size.width*0.75, latestPhoto.size.height*0.75)];
                }
            }
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"Error : %@", error);
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showLoginSegue"]) {
        UINavigationController * navc = (UINavigationController*)segue.destinationViewController;
        LogInViewController * login;
        for (UIViewController * vc in navc.viewControllers) {
            if ([vc isKindOfClass:[LogInViewController class]]) {
                login = (LogInViewController*)vc;
                [login successLogin:^(NSString *source) {
                    [self createFooterView];
                }];
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
