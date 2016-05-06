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
    _data_array = [NSMutableArray array];
    self.task_model = [[RootTaskListModel alloc] init];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.bounces = NO;
    
    [self startLoading];
    [self loadTaskDetailData];
    
    [self setupLocationManager];
    
    share_date = [NSDate date];
    
  //  [self reloadImagesFromLibrary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self userDidTakeScreenshot:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
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
                
                NSDictionary * dic = [data objectForKey:@"task"];
                wself.task_model.encrypt_id = [dic objectForKey:@"task_id"];
                wself.task_model.content = [dic objectForKey:@"content"];
                wself.task_model.task_img = [dic objectForKey:@"task_img"];
                wself.task_model.task_status = [dic objectForKey:@"task_status"];
                wself.task_model.task_price = [dic objectForKey:@"task_price"];
                wself.task_model.gao_click_price = [dic objectForKey:@"gao_click_price"];
                wself.task_model.spread_type = [dic objectForKey:@"spread_type"];
                
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
        label.text = [NSString stringWithFormat:@"您是高级用户，该任务每次转发点击收益为：￥%@/次",_task_model.gao_click_price];
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

    
    //张少南   这里应该判断如果还可以再上传图片
    if (_task_model.task_status.intValue == 1) {
        
        UIView * share_screenshot_background_view = [[UIView alloc] initWithFrame:CGRectMake(0, share_button.bottom+20, DEVICE_WIDTH, 300)];
        share_screenshot_background_view.backgroundColor = RGBCOLOR(239, 239, 239);
        [footer_view addSubview:share_screenshot_background_view];
        
        UIView * share_selected_image_background_view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, share_screenshot_background_view.height-20)];
        share_selected_image_background_view.backgroundColor = [UIColor whiteColor];
        [share_screenshot_background_view addSubview:share_selected_image_background_view];
        
        UILabel * prompt_label = [ZTools createLabelWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 20) tag:10 text:@"上传转发截图，有机会获取额外奖金" textColor:RGBCOLOR(251, 75, 78) textAlignment:NSTextAlignmentCenter font:15];
        [share_selected_image_background_view addSubview:prompt_label];
        
        selected_photo_imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-200)/2.0f, prompt_label.bottom+20, 200, 200)];
        selected_photo_imageView.clipsToBounds = YES;
        selected_photo_imageView.contentMode = UIViewContentModeScaleAspectFit;
        selected_photo_imageView.image = [UIImage imageNamed:@"share_photo_background_image"];
        [share_selected_image_background_view addSubview:selected_photo_imageView];
        
        UIButton * choose_button = [UIButton buttonWithType:UIButtonTypeCustom];
        choose_button.frame = CGRectMake(0, 0, 43, 43);
        choose_button.center = CGPointMake(selected_photo_imageView.width/2.0f, selected_photo_imageView.height/2.0f);
        [choose_button setImage:[UIImage imageNamed:@"share_choose_photo_image"] forState:UIControlStateNormal];
        [selected_photo_imageView addSubview:choose_button];
        
        //重新选取图片+上传
        NSArray * title_array = @[@"重新选择",@"上 传"];
        for (int i = 0; i < 2; i++) {
            
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake(0, selected_photo_imageView.bottom+30, 70, 30) tag:100+i title:title_array[i] image:nil];
            button.center = CGPointMake(DEVICE_WIDTH/2.0f/2.0f + (DEVICE_WIDTH/2.0f)*i, button.center.y);
            button.titleLabel.font = [ZTools returnaFontWith:15];
            [button addTarget:self action:@selector(choosePhotoButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [share_selected_image_background_view addSubview:button];
        }
        
        share_screenshot_background_view.height = selected_photo_imageView.bottom + 120;
        share_selected_image_background_view.height = share_screenshot_background_view.height-20;
        footer_view.height = share_screenshot_background_view.bottom;

        
    
        
        [self reloadImagesFromLibrary];
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
    
    UIImage *shareImage = _shareImage?_shareImage:[UIImage imageNamed:@"default_share_image"];
    UMSocialUrlResource * url_resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_task_model.task_img];
    __weak typeof(self)wself = self;
    
    //分享到第三方平台的链接地址
    NSLog(@"share_content_url ------   %@",[NSString stringWithFormat:@"%@&user_id=%@&task_id=%@",SHARE_CONTENT_URL,[ZTools getUid],_task_id]);
    NSArray * spread_type;
    if ([[ZTools replaceNullString:_task_model.spread_type WithReplaceString:@""] length] == 0) {
        spread_type = @[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE];
    }else{
        spread_type = [_task_model.spread_type componentsSeparatedByString:@"|"];
    }
    shareView = [[SShareView alloc] initWithTitles:spread_type
                                             title:nil content:title_string
                                               Url:[NSString stringWithFormat:@"%@&user_id=%@&task_id=%@",SHARE_CONTENT_URL,[ZTools getUid],_task_id]
                                             image:shareImage
                                          location:nil
                                       urlResource:url_resource
                               presentedController:self];
    
    shareView.string_copy = [ZTools getInvitationCode];
    [shareView showInView:self.navigationController.view];
    
    __weak typeof(shareView)wShareView = shareView;
    [shareView shareButtonClicked:^(NSString *snsName, NSString *shareType) {
        [wself shareTaskRequestWithType:shareType WithSns:snsName];
    }];
    
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        
    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
    
    /*
    
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",nil];
    [editActionSheet showInView:self.view];
     */
    
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

-(void)shareTaskRequestWithType:(NSString*)type WithSns:(NSString *)snsName
{
    if (shareView) {
        [shareView removeFromSuperview];
    }
    MBProgressHUD * load_hud = [ZTools showMBProgressWithText:@"准备分享..." WihtType:MBProgressHUDModeIndeterminate addToView:[UIApplication sharedApplication].keyWindow isAutoHidden:NO];
    __weak typeof(self)wself = self;
    NSLog(@"dadasd ----  %@",[NSString stringWithFormat:@"%@&task_id=%@&user_id=%@&share_type=%@&gps_city=%@&mobile_city=%@&ip_city=%@",SHARE_URL,_task_id,[ZTools getUid],type,location_city,[ZTools getPhoneNumAddress],[ZTools getIPAddress]]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&task_id=%@&user_id=%@&share_type=%@&gps_city=%@&mobile_city=%@&ip_city=%@",SHARE_URL,_task_id,[ZTools getUid],type,location_city,[ZTools getPhoneNumAddress],[ZTools getIPAddress]] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [load_hud hide:YES];
            NSString * status = [data objectForKey:@"status"];
            if ([status intValue] == 1)
            {
                [ZTools showMBProgressWithText:@"开始分享" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                [shareView shareWithSNS:snsName WithShareType:type];
                
            }else
            {
                [ZTools showErrorWithStatus:status InView:wself.view isShow:YES];
            }
        }
    } failure:^(NSError *error) {
        [load_hud hide:YES];
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
    UIImage * newImage = [ZTools OriginImage:image scaleToSize:CGSizeMake(320, 580)];
    
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
    }else if (sender.tag == 101)//上传图片
    {
        [self uploadImageData];
    }
}


- (void)uploadImageData {
    
    [self startLoading];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"user_id":[ZTools getUid],@"task_id":@"b0b64fb2938460562bc73798edf9a38f"};
    
    [manager POST:@"http://test.twttmob.com/test_version.php?m=User&a=upload_forward_image" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage * image = [UIImage imageNamed:@"Icon"];
        NSData * data = UIImageJPEGRepresentation(image, 1);
        
        [formData appendPartWithFileData:data name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        
        NSLog(@"Success: %@", [responseObject objectForKey:@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        
        NSLog(@"Error: %@", error);
    }];
    
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
