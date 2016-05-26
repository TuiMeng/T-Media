//
//  MyViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController (){
    float keyboard_height;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = DEFAULT_BACKGROUND_COLOR;
    
    /*
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBackGroundImage"] forBarMetrics: UIBarMetricsDefault];
    }
    */
    
    _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200, 44)];
    _title_label.textColor = [UIColor whiteColor];
    _title_label.textAlignment = NSTextAlignmentCenter;
    _title_label.font = [ZTools returnaFontWith:18];
    self.navigationItem.titleView = _title_label;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)setMyViewControllerLeftButtonType:(MyViewControllerButtonType)lType WihtLeftString:(NSString *)lString{
    leftType = lType;
    
    if (lString.length != 0)
    {
        NSString * title = @"";
        NSString * image_name = @"";
        if (lType == MyViewControllerButtonTypeBack) {
            image_name = @"backImage";
        }else if (lType == MyViewControllerButtonTypelogo){
            image_name = @"logo.png";
        }else if (lType == MyViewControllerButtonTypePhoto){
            image_name = lString;
        }else if (lType == MyViewControllerButtonTypeText){
            title = lString;
        }
        
        _left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _left_button.frame = CGRectMake(0,0,40,40);
        _left_button.userInteractionEnabled = NO;
        [_left_button setTitle:title forState:UIControlStateNormal];
        [_left_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_left_button setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
        [_left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (image_name.length > 0) {
            UIImage * image = [UIImage imageNamed:image_name];
            [_left_button setImage:image forState:UIControlStateNormal];
            _left_button.width = image.size.width;
            _left_button.left = 0;
        }
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0,0,50,44);
        [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton addSubview:_left_button];

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    }
    
    
}

-(void)setMyViewControllerRightButtonType:(MyViewControllerButtonType)rType WihtRightString:(NSString *)rString{
    rightType = rType;
    if (rString.length != 0)
    {
        NSString * title = @"";
        NSString * image_name = @"";
        if (rType == MyViewControllerButtonTypeBack) {
            image_name = @"back.png";
        }else if (rType == MyViewControllerButtonTypelogo){
            image_name = @"logo.png";
        }else if (rType == MyViewControllerButtonTypePhoto){
            image_name = rString;
        }else if (rType == MyViewControllerButtonTypeText){
            title = rString;
        }
        
        _right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _right_button.frame = CGRectMake(0,0,50,44);
        _right_button.titleLabel.textAlignment = NSTextAlignmentRight;
        _right_button.userInteractionEnabled = NO;
        _right_button.titleLabel.font = [ZTools returnaFontWith:16];
        [_right_button setTitle:title forState:UIControlStateNormal];
        [_right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _right_button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if (image_name.length > 0) {
            UIImage * image = [UIImage imageNamed:image_name];
            [_right_button setImage:image forState:UIControlStateNormal];
            _right_button.width = image.size.width;
            _right_button.right = 50;
        }else if(title.length > 0){
            CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:16] WithString:title WithWidth:MAXFLOAT];
            _right_button.width = size.width;
            _right_button.right = 50;
        }
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0,0,50,44);
        [rightButton addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addSubview:_right_button];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
}

/**
 *  左侧按钮点击方法
 */
-(void)leftButtonTap:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  左侧按钮点击方法
 */
-(void)rightButtonTap:(UIButton *)sender{
    
    
}

-(void)setRight_string:(NSString *)right_string{
    if (rightType == MyViewControllerButtonTypePhoto) {
        [_right_button setImage:[UIImage imageNamed:right_string] forState:UIControlStateNormal];
    }else if (rightType == MyViewControllerButtonTypeText){
        [_right_button setTitle:right_string forState:UIControlStateNormal];
    }
}
-(void)setLeft_string:(NSString *)left_string{
    if (leftType == MyViewControllerButtonTypePhoto) {
        [_left_button setImage:[UIImage imageNamed:left_string] forState:UIControlStateNormal];
    }else if (leftType == MyViewControllerButtonTypeText){
        [_left_button setTitle:left_string forState:UIControlStateNormal];
    }
}

-(void)restLeftButtonWithImageName:(NSString*)imageName{
    
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboard_height = keyboardRect.size.height;
}

#pragma mark - 全局文本框

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self animateTextField: textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    float movement = 0;

    if (DEVICE_HEIGHT - keyboard_height - self.view.top < textField.bottom) {
        movement = DEVICE_HEIGHT  - keyboard_height - textField.bottom - 20;

        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration:0.2];
        self.view.top = movement;//CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}

#define kTextFieldDruation 0.25f
#define kTextFieldMovementDistance [UIScreen mainScreen].bounds.size.height * 0.2

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const float movementDuration = kTextFieldDruation; // tweak as needed
    
    float up_distance = 0;
    if ((DEVICE_HEIGHT - 253 - self.view.top < textField.bottom) && up) {
        up_distance = DEVICE_HEIGHT - 220 - self.view.top - textField.bottom;
    }
    
    int movement = (up ? up_distance : 64);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.top = movement;//CGRectOffset(self.view.frame, 0,up?movement:0);
    [UIView commitAnimations];
}

- (void) animateTextView: (UITextView*) textField up: (BOOL) up
{
    const int movementDistance = kTextFieldMovementDistance; // tweak as needed
    const float movementDuration = kTextFieldDruation; // tweak as needed
   
    int movement = (up ? -movementDistance : 0);
    
    if (DEVICE_HEIGHT - textField.bottom < 240 && up) {
        movement = DEVICE_HEIGHT - 44 - 230 - textField.bottom;
    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.top = 64;//CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark -=-=-=-=-   返回前一菜单   -=-=-=-=-=-=
-(void)disappearWithPOP:(BOOL)isPop afterDelay:(float)dur{
    [self performSelector:@selector(disappear:) withObject:[NSString stringWithFormat:@"%d",isPop] afterDelay:dur];
}

-(void)disappear:(NSString*)isPop{
    if (isPop.intValue == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(void)startLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        _loading_hud = [ZTools showMBProgressWithText:@"加载中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    });
}
-(void)startLoadingWithText:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        _loading_hud = [ZTools showMBProgressWithText:text.length?@"加载中...":text WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    });
}
-(void)endLoading{
    [_loading_hud hide:YES];
}

#pragma mark ----------   获取用户当前地理位置
-(void)setupLocationManagerWithSuccess:(SNLocationManagerSuccessBlock)success faild:(SNLocationManagerFailedBlock)failed{
    
    location_manager_success_block  = success;
    location_failed_block           = failed;
    
    locationManager = [[CLLocationManager alloc] init] ;
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        
    } else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"未开启定位服务" message:[NSString stringWithFormat:@"定位服务未开启，请进入系统设置【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务",APP_NAME] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        if (location_failed_block) {
            location_failed_block();
        }
    }
}

#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    [locationManager stopUpdatingLocation];
    
    
    // 停止位置更新
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    // 获取经纬度
    NSLog(@"纬度:%f",currentLocation.coordinate.latitude);
    NSLog(@"经度:%f",currentLocation.coordinate.longitude);
    double lat = currentLocation.coordinate.latitude;
    double lng = currentLocation.coordinate.longitude;
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //            //将获得的所有信息显示到label上
            //            NSLog(@"%@",placemark.name);
            //            //获取城市
            //            for (CityInfo * info in _city_array) {
            //                if ([placemark.locality rangeOfString:info.name].length > 0) {
            //                    location_city = info.name;
            //                }
            //            }
            //            NSLog(@"city -----   %@",location_city);
            
            if (location_manager_success_block) {
                location_manager_success_block(lat,lng,placemark);
            }
        }else{
            if (location_manager_success_block) {
                location_manager_success_block(lat,lng,nil);
            }
        }
        
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    [self.view.layer removeAllAnimations];
    self.left_button    = nil;
    self.left_string    = nil;
    self.right_button   = nil;
    self.right_string   = nil;
    locationManager     = nil;
    self.title_label    = nil;
    location_failed_block = nil;
    location_manager_success_block = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
