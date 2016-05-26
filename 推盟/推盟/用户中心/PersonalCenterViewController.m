//
//  PersonalCenterViewController.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "UserInfoModel.h"
#import "UserTaskModel.h"
#import "PersonalCenterCell.h"
#import "MOrderListController.h"

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SNRefreshDelegate>{
    //当前选中项（抢单中任务/已完成任务）
    int current_index;
    //姓名+电话
    UILabel * user_name_phone_label;
    //等级
    UIButton * user_level_button;
    //当前余额
    UILabel * rest_money_label;
    //当前余额提示
    UILabel * rest_label;
    
    ///头视图
    UIView * section_view;
    ///金钱相关视图(当前余额，总额，可用余额，申请提现背景视图)
    UIView * money_background_view;
}

@property(nonatomic,strong)UserInfoModel * info;
@property(nonatomic,strong)NSMutableArray * data_array;

@property (weak, nonatomic) IBOutlet SNRefreshTableView *myTableView;

@end

@implementation PersonalCenterViewController
-(void)awakeFromNib{
    
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title_label.text = @"个人中心";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"personal_setting_image"];
    
    _data_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],nil];
    
    _myTableView.isHaveMoreData     = NO;
    _myTableView.refreshDelegate    = self;
    _myTableView.dataSource         = self;
    _myTableView.tableHeaderView.frame = CGRectMake(0,0,0,300);
    
    current_index = 0;
    
    [self loadPersonalInfo];
    [self loadTaskDataWithType:!current_index];
    
    [self createSectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPersonalInfomation:) name:@"modifyUserInfomation" object:nil];
}
#pragma mark ----   跳转到设置界面 ------
-(void)rightButtonTap:(UIButton*)sender{
    [self performSegueWithIdentifier:@"showSettingSegue" sender:nil];
}
#pragma mark --- 任务按钮切换
- (void)segmentControlChanged:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex != current_index) {
        current_index = (int)sender.selectedSegmentIndex;
        if ([_data_array[!current_index] count] > 0) {
            [_myTableView finishReloadigData];
            return;
        }
        [self loadTaskDataWithType:!current_index];
    }
}


-(void)createSectionView{
    
    if (!section_view) {
        section_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 300)];
        section_view.backgroundColor = [UIColor whiteColor];
        _myTableView.tableHeaderView = section_view;
        
        ///用户名手机号背景图
        UIView * background_view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
        background_view1.backgroundColor = DEFAULT_LIGHT_BLACK_COLOR;
        [section_view addSubview:background_view1];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonalInfomationView:)];
        [background_view1 addGestureRecognizer:tap];
        
        UIImageView * arrow_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-30, 15, 15, 18)];
        arrow_imageView.image = [UIImage imageNamed:@"personal_info_arrow_image"];
        [background_view1 addSubview: arrow_imageView];
        
        //用户名+手机号
        user_name_phone_label = [ZTools createLabelWithFrame:CGRectMake(20, 0, 0, 50) tag:100 text:@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:18];
        user_name_phone_label.adjustsFontSizeToFitWidth = YES;
        [background_view1 addSubview:user_name_phone_label];
        
        //用户等级
        user_level_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-40-80, 10, 80, 30) tag:101 title:@"普通用户" image:[UIImage imageNamed:@"personal_all_level_image"]];
        user_level_button.enabled = NO;
        [user_level_button setTitleColor:DEFAULT_BACKGROUND_COLOR forState:UIControlStateNormal];
        user_level_button.backgroundColor = [UIColor clearColor];
        user_level_button.titleLabel.font = [ZTools returnaFontWith:13];
        [user_level_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [user_level_button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, -25)];
        [background_view1 addSubview:user_level_button];
        
        ///金钱相关视图
        money_background_view = [[UIView alloc] initWithFrame:CGRectMake(0, background_view1.bottom, DEVICE_WIDTH, 120)];
        money_background_view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        [section_view addSubview:money_background_view];
        
        ///当前余额
        NSString * rest_money_string = @"￥0.0";
        CGSize rest_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:40] WithString:rest_money_string WithWidth:MAXFLOAT];
        rest_money_label = [ZTools createLabelWithFrame:CGRectMake((DEVICE_WIDTH-rest_size.width)/2.0f, 10, rest_size.width, 50) tag:102 text:rest_money_string textColor:RGBCOLOR(254, 239, 3) textAlignment:NSTextAlignmentCenter font:40];
        [money_background_view addSubview:rest_money_label];
        
        rest_label = [ZTools createLabelWithFrame:CGRectMake((DEVICE_WIDTH-rest_size.width)/2.0f-70, 10,65, 50) tag:103 text:@"当前积分:" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight font:15];
        rest_label.font = [ZTools returnaFontWith:15];
        [money_background_view addSubview:rest_label];
        
        ///横线
        UIView * h_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, 70, DEVICE_WIDTH, 0.5)];
        h_line_view.backgroundColor = [UIColor whiteColor];
        [money_background_view addSubview:h_line_view];
        ///总额 余额  申请提现
        for (int i = 0; i < 3; i++) {
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake(5+((DEVICE_WIDTH-20)/3.0 + 5)*i, 75, (DEVICE_WIDTH-20)/3.0, 40) tag:1000+i title:@"" image:nil];
            button.backgroundColor = [UIColor clearColor];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, 0)];
            button.titleLabel.numberOfLines = 0;
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [ZTools returnaFontWith:16];
            [button setTitleColor:RGBCOLOR(254, 239, 3) forState:UIControlStateNormal];
            [money_background_view addSubview:button];
            
            UILabel * label = [ZTools createLabelWithFrame:CGRectMake(0, button.height-20, button.width, 20)
                                                      text:@""
                                                 textColor:[UIColor whiteColor]
                                             textAlignment:NSTextAlignmentCenter
                                                      font:15];
            label.font = [ZTools returnaFontWith:14];
            [button addSubview:label];
            
            if (i == 0) {
                label.text = @"总积分";
                [button setTitle:@"0" forState:UIControlStateNormal];
            }else if (i == 1){
                label.text = @"累计提现";
                [button setTitle:@"0" forState:UIControlStateNormal];
                
            }else if (i == 2) {
                label.hidden = YES;
                button.frame = CGRectMake(DEVICE_WIDTH/3.0*2 + DEVICE_WIDTH/3.0/2.0-35, 80, 70, 30);
                [button setTitle:@"立即提现" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [ZTools returnaFontWith:15];
                [button setTitleEdgeInsets:UIEdgeInsetsZero];
                button.layer.cornerRadius = 5;
                button.layer.borderColor = [UIColor whiteColor].CGColor;
                button.layer.borderWidth = 1;
                [button addTarget:self action:@selector(applyButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(-0.5+DEVICE_WIDTH/3.0f*i, 85, 0.5, 20)];
            line_view.backgroundColor = [UIColor whiteColor];
            [money_background_view addSubview:line_view];
        }
        
        //邀请好友、我的电影票、礼品兑换
        NSArray * dataArray = @[[UIImage imageNamed:@"personal_invitation_image"],[UIImage imageNamed:@"personal_movie_image"],[UIImage imageNamed:@"personal_gift_image"],@"邀请好友",@"我的电影票",@"礼品兑换"];
        for (int i = 0; i < 3; i++) {
            UIView * lineView           = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/3.0f*i, 180, 0.5, 45)];
            lineView.backgroundColor    = DEFAULT_LINE_COLOR;
            [section_view addSubview:lineView];
            
            UIButton * button           = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame                = CGRectMake(lineView.right, 175, DEVICE_WIDTH/3.0f, 55);
            [button addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag                  = 10000+i;
            [section_view addSubview:button];
            
            UIImageView * imageView     = [[UIImageView alloc] initWithImage:dataArray[i]];
            imageView.center = CGPointMake(button.width/2.0f, imageView.height/2.0f+5);
            [button addSubview:imageView];
            
            UILabel * label             = [ZTools createLabelWithFrame:CGRectMake(0, imageView.bottom+5, button.width, 20)
                                                                  text:dataArray[i+3]
                                                             textColor:DEFAULT_BLACK_TEXT_COLOR
                                                         textAlignment:NSTextAlignmentCenter
                                                                  font:12];
            [button addSubview:label];
        }
        /*
        ///邀请好友
        UIButton * invitation_button = [ZTools createButtonWithFrame:CGRectMake(15, 180, 130, 40) tag:0 title:@"邀请好友" image:nil];
        invitation_button.titleLabel.font = [ZTools returnaFontWith:15];
        invitation_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        invitation_button.layer.cornerRadius = 5;
        [invitation_button addTarget:self action:@selector(invitationButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [section_view addSubview:invitation_button];
        
        ///礼品兑换
        UIButton * gift_apply_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-130-15, 180, 130, 40) tag:0 title:@"礼品兑换" image:nil];
        gift_apply_button.titleLabel.font = [ZTools returnaFontWith:15];
        gift_apply_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        gift_apply_button.layer.cornerRadius = 5;
        [gift_apply_button addTarget:self action:@selector(giftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [section_view addSubview:gift_apply_button];
        */
        UIView * section_h_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, 240, DEVICE_WIDTH, 0.5)];
        section_h_line_view.backgroundColor = DEFAULT_LINE_COLOR;
        [section_view addSubview:section_h_line_view];
        
        UISegmentedControl * mysegment = [[UISegmentedControl alloc] initWithItems:@[@"抢单中任务",@"已完成的任务"]];
        mysegment.selectedSegmentIndex = 0;
        mysegment.frame = CGRectMake(15, section_h_line_view.bottom+15, DEVICE_WIDTH-30, 40);
        mysegment.tintColor = DEFAULT_BACKGROUND_COLOR;
        [mysegment addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [section_view addSubview:mysegment];
    }
}


-(void)setInfomation{
    
    NSString * name_phone_string = [NSString stringWithFormat:@"%@(%@)",[ZTools getUserName],[ZTools returnEncryptionMobileNumWith:[ZTools getPhoneNum]]];
    CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:20] WithString:name_phone_string WithWidth:MAXFLOAT];
    float user_phone_width = size.width;
    if (size.width) {
        if (size.width > DEVICE_WIDTH-120-20) {
            user_phone_width = DEVICE_WIDTH - 140;
        }
    }
    
    user_name_phone_label.width = user_phone_width;
    user_name_phone_label.text = name_phone_string;
    
    if (_info.grade.intValue == 2) {
        [user_level_button setTitle:@"高级用户" forState:UIControlStateNormal];
    }else if(_info.grade.intValue == 1){
        [user_level_button setTitle:@"普通用户" forState:UIControlStateNormal];
        
        int flag = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"generalUserTips"] intValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"updateInfoLater"] intValue]);
        if (!flag) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您现在是普通用户，升级为高级用户获取更高的单次点击价格" delegate:self cancelButtonTitle:@"不再提示" otherButtonTitles:@"立即升级",@"稍后提示", nil];
            alertView.tag = 417;
            [alertView show];
        }
    }
    
    NSString * rest_money_string = [NSString stringWithFormat:@"%@",[ZTools getRestMoney]];
    CGSize rest_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:40] WithString:rest_money_string WithWidth:MAXFLOAT];
    rest_money_label.frame = CGRectMake((DEVICE_WIDTH-rest_size.width)/2.0f, 10, rest_size.width, 50);
    rest_label.frame = CGRectMake((DEVICE_WIDTH-rest_size.width)/2.0f-70, 10,65, 50);
    rest_money_label.text = rest_money_string;
    
    for (int i = 0; i < 3; i++) {
        UIButton * button = (UIButton*)[money_background_view viewWithTag:1000+i];
        if (i == 0) {
            [button setTitle:[NSString stringWithFormat:@"%@",[ZTools getAllMoney]] forState:UIControlStateNormal];
        }else if (i == 1){
            [button setTitle:[NSString stringWithFormat:@"%@",[ZTools getMoney]] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark -----   个人信息修改通知
-(void)reloadPersonalInfomation:(NSNotification*)notification{
    [self loadPersonalInfo];
}

#pragma mark *************    获取个人信息           *********************
-(void)loadPersonalInfo{
    
    __weak typeof(self)wself = self;
    NSLog(@"nihoadasod  ----  %@",[NSString stringWithFormat:@"%@&user_id=%@",GET_USERINFOMATION_URL,[ZTools getUid]]);
    NSURLSessionDataTask * task = [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",GET_USERINFOMATION_URL,[ZTools getUid]] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            wself.info = [[UserInfoModel alloc] initWithDictionary:[data objectForKey:@"user_info"]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[data objectForKey:@"user_info"]] forKey:@"UserInfomationData"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessReloadPersonalInfomation" object:nil];
            
            [wself setInfomation];
        }
    } failure:^(NSError *error) {
        
    }];
    
    [[ZAPI manager] cancel];
}
/**
 *  获取抢单任务列表数据
 *
 *  @param aType 任务类型（0:历史抢单任务；1：抢单中任务）
 */
-(void)loadTaskDataWithType:(int)aType{
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"加载中..." WihtType:MBProgressHUDModeIndeterminate addToView:_myTableView isAutoHidden:NO];
    NSLog(@"--------%@",[NSString stringWithFormat:@"%@&user_id=%@&task_status=%d",GET_USER_TASKS_URL,[ZTools getUid],aType]);
    __weak typeof(self)bself = self;
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@&task_status=%d",GET_USER_TASKS_URL,[ZTools getUid],aType] success:^(id data) {
        
        [hud hide:YES];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] == 1)
            {
                [[bself.data_array objectAtIndex:aType] removeAllObjects];
                
                NSArray * array = [data objectForKey:@"task"];
                
                for (NSDictionary * dic in array)
                {
                    UserTaskModel * model = [[UserTaskModel alloc] initWithDictionary:dic];
                    [[bself.data_array objectAtIndex:aType] addObject:model];
                }
            }else{
                [ZTools showErrorWithStatus:[data objectForKey:@"status"] InView:self.view isShow:YES];
            }
        }
        [bself.myTableView finishReloadigData];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [bself.myTableView finishReloadigData];
    }];
}



#pragma mark ***********  UITableView Delegate  *******************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data_array[!current_index] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalCenterCell * cell = (PersonalCenterCell*)[tableView dequeueReusableCellWithIdentifier:@"personalCenterIdentifier"];
    UserTaskModel * model = _data_array[!current_index][indexPath.row];
    [cell setInfomationWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark  ***********  SNRefreshTableViewDelegate
- (void)loadNewData{
    [self loadPersonalInfo];
    [self loadTaskDataWithType:current_index];
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark ----  邀请好友、电影票订单、礼品兑换
-(void)functionButtonClicked:(UIButton *)button{
    switch (button.tag-10000) {
        case 0://邀请好友
        {
            [self performSegueWithIdentifier:@"showInvitationSegue" sender:nil];
        }
            break;
        case 1://电影票订单
        {
            MOrderListController * vc = [[MOrderListController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2://礼品兑换
        {
            [self performSegueWithIdentifier:@"showGiftListSegue" sender:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 邀请好友
- (void)invitationButtonTap:(UIButton*)sender {
    [self performSegueWithIdentifier:@"showInvitationSegue" sender:nil];
}

#pragma mark - 礼品兑换
- (void)giftButtonTap:(UIButton*)sender {
    [self performSegueWithIdentifier:@"showGiftListSegue" sender:nil];
}
#pragma mark - 申请提现
- (IBAction)applyButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"showApplyMoneySegue" sender:nil];
}

#pragma mark -----   到个人信息界面
-(void)showPersonalInfomationView:(UITapGestureRecognizer*)sender{
    [self performSegueWithIdentifier:@"showPersonalInfoSegue" sender:nil];
}


#pragma mark ------   UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 417) {
        switch (buttonIndex) {
            case 0://不再提示
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"generalUserTips"];
            }
                break;
            case 1://立即升级
            {
                [self performSegueWithIdentifier:@"showPersonalInfoSegue" sender:nil];
            }
                break;
            case 2://稍后提示
            {
                //下次重新打开app提示
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"updateInfoLater"];
            }
                break;
                
            default:
                break;
        }
    }
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
