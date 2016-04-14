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

@interface MNearByCinemasViewController ()<SNRefreshDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    //纬度
    double              locationLat;
    //经度
    double              locationLng;
    
    AMapLocationManager * locationManager;
    //重新定位
    UIImageView * refreshImageView;
}

@property(nonatomic,strong)SNRefreshTableView       * myTableView;
@property(nonatomic,strong)NSMutableArray           * data_array;


@end

@implementation MNearByCinemasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _movieModel.movieName;
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"筛选"];
    
    [self createMainView];
    [self loadCinemasData];
    [self setupLocationManager];
}

-(void)rightButtonTap:(UIButton *)sender{
    
//    http://127.0.0.1:8080/pwmobile/mobile/qrSeqSeats?seqId=99920120905033514&adfa=adasd
//    http://www.yingmile.com/pwmobile/mobile/qrMovieSequences?cinemaId=11051601&movieId=20160314100247772&dayKind=1
}

-(void)createMainView{
    _myTableView                    = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    [_myTableView removeFooterView];
    _myTableView.tableFooterView    = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_myTableView];
    
    
    UIView * addressView        = [[UIView alloc] initWithFrame:CGRectMake(8, DEVICE_HEIGHT-28-5, DEVICE_WIDTH-16, 28)];
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
    
    UILabel * addressLabel = [ZTools createLabelWithFrame:CGRectMake(locationImageView.right, 0, refreshImageView.left-locationImageView.right-10, addressView.height)
                                                     text:@""
                                                textColor:RGBCOLOR(150, 150, 150)
                                            textAlignment:NSTextAlignmentLeft
                                                     font:13];
    [addressView addSubview:addressLabel];
    
}

#pragma mark -------  网络请求
-(void)loadCinemasData{
    
    if (!_data_array) {
        _data_array = [NSMutableArray array];
    }
//    http://202.108.31.66:8088/tmmobile/mobile/qrMovieAllSequences?cinemaId=11051601&movieId=05120072201201&dayKind=1
//    http://www.yingmile.com/tmmobile/mobile/qrLocalAndAllCinemas?cinemaId=zz_11071201_7&movieId=20160331133212429&dayKind=1
    NSLog(@"url--------  %@",[NSString stringWithFormat:@"%@qrLocalCinemas?Lon=116.315148&Lat=40.060319&movieId=%@",BASE_MOVIE_URL,_movieModel.movieId]);
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendMoviePost:[NSString stringWithFormat:@"%@qrLocalCinemas?Lon=116.315148&Lat=40.060319&movieId=%@",BASE_MOVIE_URL,_movieModel.movieId] myParams:nil success:^(id data) {
        
        if (data && [data isKindOfClass:[NSArray class]]) {
            for (NSDictionary * item in data) {
                MLocationCinemasModel * model   = [[MLocationCinemasModel alloc] initWithDictionary:item];
                //张少南
//                model.cinemaId                  = @"zz_DX20003209_7";
                [wself.data_array addObject:model];
            }
        }

        [wself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MNearbyCinemaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MNearbyCinemaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MLocationCinemasModel * model = [_data_array objectAtIndex:indexPath.row];
    
    [cell setInfomationWithCinemasModel:model];
    
    return cell;
}

-(void)loadNewData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    MLocationCinemasModel * model = [_data_array objectAtIndex:indexPath.row];

    MCinemaScheduleViewController * viewController = [[MCinemaScheduleViewController alloc] init];
    viewController.cinema_model = model;
    viewController.movie_model = _movieModel;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 80;
    //return 90;
}




#pragma mark ---------  获取用户地理位置信息
- (void) setupLocationManager {
    
    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    locationManager.locationTimeout = 3;
    locationManager.reGeocodeTimeout = 3;
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        locationLat = location.coordinate.latitude;
        locationLng = location.coordinate.longitude;
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.AOIName);
            
        }
    }];
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
    rotationAnimation.duration = 3.0f;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
