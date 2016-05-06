//
//  MNearByCinemasViewController.m
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MNearByCinemasViewController.h"
#import "MLocationCinemasModel.h"
#import "MNearbyCinemaTableViewCell.h"
#import "MCinemaScheduleViewController.h"
#import "UIAlertView+Blocks.h"
#import "SListTopBarScrollView.h"
#import "MOrderListController.h"


@interface MNearByCinemasViewController ()<SNRefreshDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    //纬度
    float              locationLat;
    //经度
    float              locationLng;
    
    AMapLocationManager * locationManager;
    //重新定位
    UIImageView         * refreshImageView;
    //位置信息
    UILabel             * addressLabel;
    SListTopBarScrollView * _topScrollView;
    //选中的日期，默认为今天（0：今天 1：明天 2：后天）
    int                 currentDate;
}

@property(nonatomic,strong)SNRefreshTableView       * myTableView;
@property(nonatomic,strong)NSMutableArray           * data_array;


@end

@implementation MNearByCinemasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _movieModel.movieName;
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"我的订单"];
    
    [self createMainView];
    [self setupLocationManager];
}

-(void)rightButtonTap:(UIButton *)sender{
    
//    http://127.0.0.1:8080/pwmobile/mobile/qrSeqSeats?seqId=99920120905033514&adfa=adasd
//    http://www.yingmile.com/pwmobile/mobile/qrMovieSequences?cinemaId=11051601&movieId=20160314100247772&dayKind=1
    
    
    MOrderListController * vc = [[MOrderListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)createMainView{
    [self createScheduleTopView];
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, _topScrollView.bottom, DEVICE_WIDTH, DEVICE_HEIGHT-64-_topScrollView.height) showLoadMore:YES];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [_myTableView removeFooterView];
    _myTableView.tableFooterView    = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_myTableView];
    
    
    UIView * addressView        = [[UIView alloc] initWithFrame:CGRectMake(8, DEVICE_HEIGHT-28-5-64, DEVICE_WIDTH-16, 28)];
    addressView.backgroundColor = [RGBCOLOR(238, 238, 238) colorWithAlphaComponent:0.8];
    [self.view addSubview:addressView];
    
    UITapGestureRecognizer * addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repositionPosition:)];
    [addressView addGestureRecognizer:addressTap];
    
    UIImageView * locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie_location_image"]];
    locationImageView.center        = CGPointMake(10 + 20/2.0f, addressView.height/2.0f);
    [addressView addSubview:locationImageView];
    
    refreshImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie_location_refresh_image"]];
    refreshImageView.center         = CGPointMake(addressView.width-10-20/2.0f, addressView.height/2.0f);
    [addressView addSubview:refreshImageView];
    
    addressLabel = [ZTools createLabelWithFrame:CGRectMake(locationImageView.right+5, 0, refreshImageView.left-locationImageView.right-10, addressView.height)
                                                     text:@""
                                                textColor:RGBCOLOR(150, 150, 150)
                                            textAlignment:NSTextAlignmentLeft
                                                     font:13];
    [addressView addSubview:addressLabel];
}

-(void)createScheduleTopView{
    
    _topScrollView = [[SListTopBarScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,45)];
    __weak typeof(self)wself = self;
    _topScrollView.scrollsToTop = NO;
    _topScrollView.btnWidth                 = 140;
    _topScrollView.lineWidth                = 120;
    _topScrollView.titleNormalColor         = [UIColor whiteColor];
    _topScrollView.titleSelectedColor       = DEFAULT_BACKGROUND_COLOR;
    _topScrollView.titleFont                = [ZTools returnaFontWith:15];
    _topScrollView.listBarItemClickBlock    = ^(NSString *itemName , NSInteger itemIndex){
        currentDate = (int)itemIndex;
        [wself loadCinemasData];
    };
    [self.view addSubview:_topScrollView];
    _topScrollView.visibleItemList          = [MovieTools returnThreeDaysArray];
}


#pragma mark -------  网络请求
-(void)loadCinemasData{
    
    if (!_data_array) {
        _data_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],nil];
    }

    NSLog(@"url--------  %@",[NSString stringWithFormat:@"%@qrLocalCinemas?Lon=%f&Lat=%f&movieId=%@&dayKind=%d",BASE_MOVIE_URL,locationLng?locationLng:116.3972282409668,locationLat?locationLat:39.90960456049752,_movieModel.movieId,currentDate]);
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:_movieModel.movieId forKey:@"movieId"];
    [dic setObject:@(currentDate) forKey:@"dayKind"];
    [dic setObject:[ZTools getSelectedCityId] forKey:@"cityId"];
    [dic setObject:@(locationLng) forKey:@"Lon"];
    [dic setObject:@(locationLat) forKey:@"Lat"];
    
    __weak typeof(self)wself = self;
    
    [self startLoading];
    [[ZAPI manager] sendMoviePost:GET_NEAR_CINEMA_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSArray class]]) {
            for (NSDictionary * item in data) {
                MLocationCinemasModel * model   = [[MLocationCinemasModel alloc] initWithDictionary:item];
                [wself.data_array[currentDate] addObject:model];
            }
            
        }else if (data && [data isKindOfClass:[NSDictionary class]]){
            if ([data[MOVIE_ERROR_CODE] intValue] != 0) {
                [ZTools showMBProgressWithText:data[MOVIE_ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }

        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

#pragma mark --------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data_array[currentDate] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MNearbyCinemaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MNearbyCinemaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MLocationCinemasModel * model = [_data_array[currentDate] objectAtIndex:indexPath.row];
    
    [cell setInfomationWithCinemasModel:model];
    
    return cell;
}

-(void)loadNewData{
    [self loadCinemasData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    MLocationCinemasModel * model = [_data_array[currentDate] objectAtIndex:indexPath.row];

    MCinemaScheduleViewController * viewController = [[MCinemaScheduleViewController alloc] init];
    viewController.cinema_model = model;
    viewController.movie_model  = _movieModel;
    viewController.dayKind      = currentDate;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 80;
    //return 90;
}




#pragma mark ---------  获取用户地理位置信息
- (void) setupLocationManager {
    
    __weak typeof(self)wself = self;
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
                [wself showLocationErrorAlert];
            }
        }
        
        locationLat = location.coordinate.latitude;
        locationLng = location.coordinate.longitude;
        NSString * tempString = addressLabel.text;
        if (regeocode)
        {
            addressLabel.text = [NSString stringWithFormat:@"%@附近",regeocode.AOIName];
            
        }else{
            addressLabel.text = @"未能获取您的位置，点击重试";
        }
        
        if (![tempString isEqualToString:addressLabel.text]) {
            [wself loadCinemasData];
        }
    }];
}

-(void)showLocationErrorAlert{
    UIAlertView * alertView = [UIAlertView showWithTitle:@"打开定位开关" message:[NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务",APP_NAME] cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即开启"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
    }];
    
    [alertView show];
}

#pragma mark ---   重新定位
-(void)repositionPosition:(UITapGestureRecognizer *)sender{
    [self setupLocationManager];
    
    [self startAnimation];
}

-(void) startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = YES;
    [refreshImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

-(void)endAnimation
{
    [refreshImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [_data_array removeAllObjects];
    _data_array = nil;
    _myTableView = nil;
    [self.view.layer removeAllAnimations];
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
