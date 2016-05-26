//
//  MenuViewController.m
//  推盟
//
//  Created by joinus on 15/12/21.
//  Copyright © 2015年 joinus. All rights reserved.
//

#import "MenuViewController.h"
#import "GiftListViewController.h"
#import "RootViewController.h"
#import "InvitationViewController.h"
#import "ApplyMoneyViewController.h"
#import "TaskListViewController.h"
#import "SettingViewController.h"
#import "RankingViewController.h"
#import "PersonalInfoViewController.h"
#import "FriendListViewController.h"


#define SILDE_ROOT_TITLE @"首页"
#define SILDE_RANKING_TITLE @"排行榜"
#define SILDE_GIFT_TITLE @"礼品兑换"
#define SILDE_INVITATION_TITLE @"邀请好友"
#define SILDE_FRIEND_LIST_TITLE @"好友列表"
#define SILDE_APPLY_MONEY_TITLE @"申请提现"
#define SILDE_TASK_LIST_TITLE @"任务列表"

#define SILDE_DEFAULT_BACKGROUND_COLOR RGBCOLOR(73, 73, 73)
#define SILDE_TABLEVIEW_CELL_SELECTED_COLOR RGBCOLOR(57, 57, 57)

@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * title_array;
    NSArray * image_array;
    
    UIView * headerView;
    //是否需要更新数据
    BOOL isUpdate;
}

@property(nonatomic,strong)UITableView * myTableView;

@end

@implementation MenuViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"];
    if (!userInfo && ![userInfo isKindOfClass:[NSDictionary class]] && [ZTools isLogIn]) {
        [self loadPersonalInfo];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SILDE_DEFAULT_BACKGROUND_COLOR;
    
    title_array = @[SILDE_RANKING_TITLE,SILDE_GIFT_TITLE,SILDE_INVITATION_TITLE,SILDE_APPLY_MONEY_TITLE,SILDE_TASK_LIST_TITLE];
    image_array = @[[UIImage imageNamed:@"slide_ranking_image"],[UIImage imageNamed:@"silde_gift_image"],[UIImage imageNamed:@"slide_invitation_image"],[UIImage imageNamed:@"slide_friend_list_image"],[UIImage imageNamed:@"slide_apply_image"],[UIImage imageNamed:@"slide_task_image"]];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH-[ZTools autoWidthWith:65], DEVICE_HEIGHT-60) style:UITableViewStylePlain];
    _myTableView.backgroundColor = SILDE_DEFAULT_BACKGROUND_COLOR;
    _myTableView.separatorColor = RGBCOLOR(133, 133, 133);
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    // 调cell对齐
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //设置按钮
    UIButton * setting_button = [ZTools createButtonWithFrame:CGRectMake(10, DEVICE_HEIGHT-50, 60, 30) tag:104 title:@"设置" image:[UIImage imageNamed:@"slide_setting_image"]];
    setting_button.titleLabel.font = [ZTools returnaFontWith:14];
    setting_button.backgroundColor = [UIColor clearColor];
    [setting_button addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting_button];
    //版本提示
    UILabel * verson_label = [ZTools createLabelWithFrame:CGRectMake(_myTableView.width-70, setting_button.top, 50, 30) tag:105 text:[NSString stringWithFormat:@"V%@",CURRENT_VERSION] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight font:15];
    [self.view addSubview:verson_label];
    
    [self createSectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"userLogOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"successLogin" object:nil];
}

#pragma mark *************    获取个人信息           *********************
-(void)loadPersonalInfo{
    __weak typeof(self)wself = self;
    
    NSLog(@"url ----   %@",[NSString stringWithFormat:@"%@&user_id=%@",GET_USERINFOMATION_URL,[ZTools getUid]]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",GET_USERINFOMATION_URL,[ZTools getUid]] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[data objectForKey:@"user_info"]] forKey:@"UserInfomationData"];
            
            [wself createSectionView];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)createSectionView{
    if (headerView) {
        for (UIView * subview in headerView.subviews) {
            [subview removeFromSuperview];
        }
        [headerView removeFromSuperview];
        headerView = nil;
    }
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _myTableView.width, 190)];
    headerView.backgroundColor = SILDE_DEFAULT_BACKGROUND_COLOR;
    _myTableView.tableHeaderView = headerView;
    //个人信息
    UIView * info_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _myTableView.width, 100)];
    [headerView addSubview:info_view];
    
    UITapGestureRecognizer * infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTap:)];
    [info_view addGestureRecognizer:infoTap];
    
    //中间分割线
    UIView * h_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, 100.5, headerView.width, 0.5)];
    h_line_view.backgroundColor = DEFAULT_LINE_COLOR;
    [headerView addSubview:h_line_view];
    //底部分割线
    UIView * bottom_line_view = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height-0.5, headerView.width, 0.5)];
    bottom_line_view.backgroundColor = DEFAULT_LINE_COLOR;
    [headerView addSubview:bottom_line_view];
    
    //用户名手机号
    UILabel * user_name_phone_label = [ZTools createLabelWithFrame:CGRectMake(10, 40, _myTableView.width-20, 25) tag:100 text:@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:20];
    [info_view addSubview:user_name_phone_label];
    NSArray * section_money_array;
    //判断用户是否登录
    if ([ZTools isLogIn]) {
        user_name_phone_label.text = [NSString stringWithFormat:@"%@(%@)",[ZTools getUserName],[ZTools returnEncryptionMobileNumWith:[ZTools getPhoneNum]]];
        section_money_array = @[[ZTools getAllMoney],[ZTools getRestMoney],[ZTools getMoney]];
        
        UIButton * level_button = [UIButton buttonWithType:UIButtonTypeCustom];
        level_button.frame = CGRectMake(10, user_name_phone_label.bottom+5, 110, 20);
        level_button.titleLabel.font = [ZTools returnaFontWith:13];
        level_button.adjustsImageWhenHighlighted = NO;
        [info_view addSubview:level_button];
        
        if ([ZTools getGrade] == 2) {
            [level_button setTitle:@"您已是高级用户" forState:UIControlStateNormal];
            [level_button setImage:[UIImage imageNamed:@"personal_all_level_image"] forState:UIControlStateNormal];
        }else{
            [level_button setTitle:@"升级为高级用户" forState:UIControlStateNormal];
            [level_button setImage:[UIImage imageNamed:@"personal_low_level_image"] forState:UIControlStateNormal];
        }
        
        UIImageView * arrow_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_myTableView.width-30, 60, 15, 18)];
        arrow_imageView.image = [UIImage imageNamed:@"personal_info_arrow_image"];
        [headerView addSubview:arrow_imageView];
        
        isUpdate = NO;

    }else{
        section_money_array = @[@"0.0",@"0.0",@"0.0"];
        
        user_name_phone_label.text = @"立即登录";
        user_name_phone_label.textAlignment = NSTextAlignmentCenter;
        
        isUpdate = YES;
    }
    
    UILabel * total_money_label = [ZTools createLabelWithFrame:CGRectMake(10, 105, _myTableView.width-20, 40) tag:1003 text:@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:12];
    NSString * total_money_string = [NSString stringWithFormat:@"总收入￥%@",section_money_array[0]];
    NSMutableAttributedString * total_att_string = [[NSMutableAttributedString alloc] initWithString:total_money_string];
    [total_att_string addAttribute:NSForegroundColorAttributeName value:DEFAULT_BACKGROUND_COLOR range:NSMakeRange(3, total_money_string.length-3)];
    [total_att_string addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:28] range:NSMakeRange(3, total_money_string.length-3)];
    total_money_label.attributedText = total_att_string;
    [headerView addSubview:total_money_label];
    
    UIView * v_line_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, total_money_label.bottom, _myTableView.width, 0.5)];
    v_line_view2.backgroundColor = DEFAULT_LINE_COLOR;
    [headerView addSubview:v_line_view2];
    
    NSArray * section_title_array = @[@"当前余额",@"累计提现"];
    for (int i = 0; i < 2; i++) {
        UIButton * button = [ZTools createButtonWithFrame:CGRectMake(5+((_myTableView.width-20)/2.0 + 5)*i, v_line_view2.bottom, (_myTableView.width-20)/2.0, 40) tag:1000+i title:section_money_array[i+1] image:nil];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, 0)];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [ZTools returnaFontWith:16];
        [button setTitleColor:RGBCOLOR(254, 239, 3) forState:UIControlStateNormal];
        [headerView addSubview:button];
        
        UILabel * label = [ZTools createLabelWithFrame:CGRectMake(0, button.height-20, button.width, 20) tag:10000 text:@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:15];
        label.font = [ZTools returnaFontWith:14];
        label.text = section_title_array[i];
        [button addSubview:label];
        
        UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(-0.5+_myTableView.width/2.0f*i, button.center.y-10, 0.5, 20)];
        line_view.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:line_view];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return title_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = SILDE_DEFAULT_BACKGROUND_COLOR;
        cell.contentView.backgroundColor = SILDE_DEFAULT_BACKGROUND_COLOR;
        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=SILDE_TABLEVIEW_CELL_SELECTED_COLOR;
    }
    
    cell.textLabel.textColor    = [UIColor whiteColor];
    cell.textLabel.font         = [ZTools returnaFontWith:17];
    cell.textLabel.text         = title_array[indexPath.row];
    cell.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image        = image_array[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSString * title = title_array[indexPath.row];
    
    if ([title isEqualToString:SILDE_RANKING_TITLE]){
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        RankingViewController * ranking = (RankingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RankingViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:ranking animated:NO];
        return;
    }
    
    if (![ZTools isLogIn]) {
        
        [self showLoginViewController];
        return;
    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    if ([title isEqualToString:SILDE_GIFT_TITLE]){
        GiftListViewController * gift = (GiftListViewController*)[storyboard instantiateViewControllerWithIdentifier:@"GiftListViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:gift animated:NO];
    }else if ([title isEqualToString:SILDE_INVITATION_TITLE]){
        InvitationViewController * invitation = (InvitationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"InvitationViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:invitation animated:NO];
    }else if ([title isEqualToString:SILDE_FRIEND_LIST_TITLE]){
        FriendListViewController * friendlist = (FriendListViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FriendListViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:friendlist animated:NO];
    }else if ([title isEqualToString:SILDE_APPLY_MONEY_TITLE]){
        ApplyMoneyViewController * apply = (ApplyMoneyViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ApplyMoneyViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:apply animated:NO];
    }else if ([title isEqualToString:SILDE_TASK_LIST_TITLE]){
        TaskListViewController * task = (TaskListViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TaskListViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:task animated:NO];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark ----  个人信息
-(void)infoTap:(UITapGestureRecognizer*)sender{
    
    if ([ZTools isLogIn]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        PersonalInfoViewController * person_info = (PersonalInfoViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PersonalInfoViewController"];
        [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:person_info animated:NO];
    }else{
        [self showLoginViewController];
    }
}
#pragma mark -----   跳转到登录界面
-(void)showLoginViewController{
    
    [[LogInView sharedInstance] loginShowWithSuccess:^{
        
    }];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController * login = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    [self presentViewController:login animated:YES completion:nil];
     */
}

#pragma mark -----   设置
-(void)settingButtonClicked:(UIButton*)button{
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController * setting = (SettingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [(UINavigationController*)self.mm_drawerController.centerViewController pushViewController:setting animated:NO];
}

#pragma mark -----   退出登录
-(void)logout:(NSNotification*)notification{
    [self createSectionView];
}
#pragma mark ------    登录成功
-(void)login:(NSNotification*)notification{
    [self loadPersonalInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
