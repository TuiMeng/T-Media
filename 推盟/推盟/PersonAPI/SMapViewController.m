//
//  SMapViewController.m
//  推盟
//
//  Created by joinus on 16/4/15.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "SMapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface SMapViewController ()<MAMapViewDelegate,UIActionSheetDelegate>{
    MAMapView * _mapView;
    /**
     *  当前位置信息
     */
    double user_lat;
    double user_lng;
}

@end

@implementation SMapViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = _stitle;
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"导航"];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [MAMapServices sharedServices].apiKey = IS_YML?YML_AMAP_KEY:AMAP_KEY;
    
    _mapView            = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _mapView.delegate   = self;
    _mapView.mapType    = MAMapTypeStandard;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(_lat, _lng);
    [_mapView setZoomLevel:15 animated:YES];
    [self.view addSubview:_mapView];
    
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_lat, _lng);
    pointAnnotation.title = _stitle;
    [_mapView addAnnotation:pointAnnotation];
}




-(void)rightButtonTap:(UIButton *)sender{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用手机自带地图",@"使用百度地图", nil];
    [sheet showInView:self.view];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.latitude);
        //        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) animated:YES];
        
        user_lat = userLocation.coordinate.latitude;
        user_lng = userLocation.coordinate.longitude;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinColor         = MAPinAnnotationColorRed;
        annotationView.canShowCallout   = YES; //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop     = YES;  //设置标注动画显示，默认为NO
        [annotationView setSelected:YES animated:YES];
        
        return annotationView;
    }
    return nil;
}

#pragma mark -------- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 2:
        {//取消
            
        }
            break;
        case 1:
        {//百度
            [self callMapWithType:@"百度" fromLat:user_lat fromLng:user_lng toLat:_lat toLng:_lng WithTitle:_stitle];
        }
            break;
        case 0:
        {//手机
            [self callMapWithType:@"手机" fromLat:user_lat fromLng:user_lng toLat:_lat toLng:_lng WithTitle:_stitle];
        }
            break;
            
        default:
            break;
    }
}


-(void)callMapWithType:(NSString*)type fromLat:(double)from_lat fromLng:(double)from_lng toLat:(double)to_lat toLng:(double)to_lng WithTitle:(NSString*)title{
    if ([type isEqualToString:@"百度"]) {
        ///name:起始位置
        NSString * string = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=tuimeng",from_lat,from_lng,to_lat,to_lng];
        
        UIApplication *app = [UIApplication sharedApplication];
        
        if ([app canOpenURL:[NSURL URLWithString:string]])
        {
            [app openURL:[NSURL URLWithString:string]];
        }else
        {
            [ZTools showMBProgressWithText:@"您还没有安装百度地图" WihtType:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow isAutoHidden:YES];
        }
    }else{
        
        CLLocationCoordinate2D from = CLLocationCoordinate2DMake(from_lat,from_lng);
        MKPlacemark * fromMark = [[MKPlacemark alloc] initWithCoordinate:from
                                                       addressDictionary:nil];
        MKMapItem * fromLocation = [[MKMapItem alloc] initWithPlacemark:fromMark];
        fromLocation.name = @"我的位置";
        
        
        CLLocationCoordinate2D to = CLLocationCoordinate2DMake(to_lat,to_lng);
        MKPlacemark * toMark = [[MKPlacemark alloc] initWithCoordinate:to
                                                     addressDictionary:nil];
        MKMapItem * toLocation = [[MKMapItem alloc] initWithPlacemark:toMark];
        toLocation.name = title;
        
        NSArray  * values = [NSArray arrayWithObjects:
                             MKLaunchOptionsDirectionsModeDriving,
                             [NSNumber numberWithBool:YES],
                             [NSNumber numberWithInt:2],
                             nil];
        NSArray * keys = [NSArray arrayWithObjects:
                          MKLaunchOptionsDirectionsModeKey,
                          MKLaunchOptionsShowsTrafficKey,
                          MKLaunchOptionsMapTypeKey,nil];
        
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:fromLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:values
                                                                 forKeys:keys]];
    }
}


-(void)dealloc{
    _mapView.delegate = nil;
    _mapView = nil;
}



@end








