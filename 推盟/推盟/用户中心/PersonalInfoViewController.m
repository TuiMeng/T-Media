//
//  PersonalInfoViewController.m
//  推盟
//
//  Created by joinus on 15/8/6.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UserInfoModel.h"
#import "SYearPickerView.h"
#import "ModifyUserNameViewController.h"
#import "HobbyViewController.h"

#define PHONE_NUM_STRING @"手机"
#define USER_NAME_STRING @"昵称"
#define USER_LEVEL_STRING @"用户等级"
#define PASS_WORLD_STRING @"修改密码"
#define USER_SEX_STRING @"性别"
#define USER_AGE_STRING @"年龄"
#define USER_AREA_STRING @"地区"
#define USER_JOB_STRING @"职业"
#define USER_HOBBY_STRING @"兴趣爱好"


@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    NSMutableArray * area_array;
    int _flagRow;
    int _flagRow1;
    /**
     *  行业列表数据
     */
    NSMutableArray * industry_array;
    
    UITapGestureRecognizer * disappear_tap;
    //用户性别
    NSString * user_sex_string;
    //用户年龄
    NSString * user_age_string;
    //用户昵称
    NSString * user_name_string;
    //用户地区
    NSString * user_area_string;
    //用户职业
    NSString * user_job_string;
    
    //显示类型（选择地区/年龄）
    NSString * show_type;
    //兴趣标签容器
    NSMutableArray * hobby_titles_array;
    //标签视图
    UIView * hobby_titles_view;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@property(nonatomic,strong)NSMutableArray * title_array;

//选取年龄
@property(nonatomic,strong)SYearPickerView * date_picker;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"个人信息";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"确认"];
    [self.right_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    [self setup];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    // 调cell对齐
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successReloadUserInfomation:) name:@"SuccessReloadPersonalInfomation" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setup];
    [_myTableView reloadData];
}
///请求完个人信息数据提示
-(void)successReloadUserInfomation:(NSNotification*)notification{
    [self setup];
    [_myTableView reloadData];
}

-(void)setup{
    hobby_titles_array = [NSMutableArray array];
    NSString * user_hobby = [ZTools getUserHobby];
    if (user_hobby.length > 0) {
        NSArray * array = [user_hobby componentsSeparatedByString:@"|"];
        [hobby_titles_array addObjectsFromArray:array];
    }
    
    if ([ZTools getGrade] == 2) {
        _title_array = [NSMutableArray arrayWithObjects:PHONE_NUM_STRING,USER_NAME_STRING,USER_LEVEL_STRING,USER_SEX_STRING,USER_AGE_STRING,USER_AREA_STRING,USER_JOB_STRING,USER_HOBBY_STRING,nil];
    }else{
        _title_array = [NSMutableArray arrayWithObjects:@[PHONE_NUM_STRING,USER_NAME_STRING,USER_LEVEL_STRING],@[USER_SEX_STRING,USER_AGE_STRING,USER_AREA_STRING,USER_JOB_STRING,USER_HOBBY_STRING], nil];
    }
}

-(void)leftButtonTap:(UIButton *)sender{
    
    if (self.navigationItem.rightBarButtonItem.enabled) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您有未提交的修改信息，是否提交修改信息" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"提交",nil];
        alertView.tag = 10000;
        [alertView show];
    }
}

#pragma mark -----------   修改用户信息
-(void)rightButtonTap:(UIButton*)sender{
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"提交中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id":[ZTools getUid]}];
    if (user_sex_string.length > 0) {
        [dic setObject:user_sex_string forKey:@"user_sex"];
    }
    if (user_age_string.length > 0) {
        [dic setObject:user_age_string forKey:@"user_age"];
    }
    if (user_job_string.length > 0) {
        [dic setObject:user_job_string forKey:@"user_profession"];
    }
    if (user_area_string.length > 0) {
        [dic setObject:user_area_string forKey:@"user_area"];
    }
    
    NSLog(@"dic ------   %@",dic);
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:MODIFY_USER_INFOMATION_URL myParams:dic success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] == 1) {
                [ZTools showMBProgressWithText:@"修改成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserInfomation" object:nil];
                [wself.right_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                wself.navigationItem.rightBarButtonItem.enabled = NO;
                
                user_sex_string = @"";
                user_age_string = @"";
                user_job_string = @"";
                user_area_string = @"";
                
            }else{
                 [ZTools showMBProgressWithText:[data objectForKey:@"errorinfo"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }else{
            [ZTools showMBProgressWithText:@"提交失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
    } failure:^(NSError *error) {
        [ZTools showMBProgressWithText:@"提交失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

-(void)addTapGestureRecognizer{
    disappear_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [_myTableView addGestureRecognizer:disappear_tap];
}
-(void)removeTapGestureRecognizer{
    [_myTableView removeGestureRecognizer:disappear_tap];
}

-(void)doTap:(UITapGestureRecognizer*)sender{
    [self removeTapGestureRecognizer];
    [self.view endEditing:YES];
    [self datePickerViewShow:NO];
    [self pickerViewShow:NO];
}


#pragma mark  **************  UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([ZTools getGrade] == 2) {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([ZTools getGrade] == 2) {
         return _title_array.count;
    }else{
       return [_title_array[section] count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSString * title = @"";
    
    if ([ZTools getGrade] == 2) {
        title = _title_array[indexPath.row];
    }else{
        title = _title_array[indexPath.section][indexPath.row];
    }
    
    cell.textLabel.text = title;
    cell.textLabel.font = [ZTools returnaFontWith:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * info_dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"];
    
    NSString * content = @"";
    
    UserInfoModel * user_info = [[UserInfoModel alloc] initWithDictionary:info_dic];
    
    if ([title isEqualToString:PHONE_NUM_STRING])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        content = user_info.user_mobile;
        
    }else if ([title isEqualToString:USER_NAME_STRING])
    {
        content = user_info.user_name;
        
    }else if ([title isEqualToString:USER_LEVEL_STRING])
    {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
                
        if([ZTools getGrade] == 2){
            content = @"高级用户";
        }else{
            content = @"普通用户";
        }
        
    }else if ([title isEqualToString:PASS_WORLD_STRING])
    {
        
    }else if ([title isEqualToString:USER_SEX_STRING])
    {
        if (user_sex_string.length != 0) {
            content = user_sex_string;
            [self.right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            content = user_info.user_sex?user_info.user_sex:@"请选择";
        }
    }else if ([title isEqualToString:USER_AGE_STRING])
    {
        if (user_age_string.length != 0) {
            content = user_age_string;
            [self.right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            NSString * city = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"user_age"];
             content = city.length==0?@"请选择":city;
        }
       
    }else if ([title isEqualToString:USER_AREA_STRING])
    {
        if (user_area_string.length != 0) {
            content = user_area_string;
            [self.right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            NSString * age = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"user_city"];
            content = age.length==0?@"请选择":age;
        }
        
    }else if ([title isEqualToString:USER_JOB_STRING])
    {
        if (user_job_string.length != 0) {
            content = user_job_string;
            [self.right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            NSString * job = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"trade"];
            content = job.length==0?@"请选择":job;
        }
    }else if ([title isEqualToString:USER_HOBBY_STRING])
    {
        if (hobby_titles_array && hobby_titles_array.count != 0) {
            content = @"";
            cell.textLabel.text = @"";
            
            UILabel * title_label = [ZTools createLabelWithFrame:CGRectMake(12,15, 100, 18) tag:-10 text:@"兴趣爱好" textColor:RGBCOLOR(49, 49, 49) textAlignment:NSTextAlignmentLeft font:16];
            title_label.font = [ZTools returnaFontWith:16];
            [cell.contentView addSubview:title_label];
            
            [cell.contentView addSubview:hobby_titles_view];
            
        }else{
             content = @"请选择";
        }
    }
    
    cell.detailTextLabel.font = [ZTools returnaFontWith:15];
    cell.detailTextLabel.text = content;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * title = @"";
    
    if ([ZTools getGrade] == 2) {
        title = _title_array[indexPath.row];
    }else{
        title = _title_array[indexPath.section][indexPath.row];
    }
    
    if ([title isEqualToString:PHONE_NUM_STRING]) {
        
    }else if ([title isEqualToString:USER_NAME_STRING]){
        ModifyUserNameViewController * modify_vc = [[ModifyUserNameViewController alloc] init];
        [self.navigationController pushViewController:modify_vc animated:YES];
    }else if ([title isEqualToString:USER_LEVEL_STRING]){
        [self userLevelIntroduction];
    }else if ([title isEqualToString:PASS_WORLD_STRING]){
        [self performSegueWithIdentifier:@"showModifyPWSegue" sender:nil];
    }else if ([title isEqualToString:USER_SEX_STRING]){
        [self modifiySex];
    }else if ([title isEqualToString:USER_AGE_STRING]){
        [self chooseAge];
    }else if ([title isEqualToString:USER_AREA_STRING]){
        [self modifiyArea];
    }else if ([title isEqualToString:USER_JOB_STRING]){
        [self modifiyIndustry];
    }else if ([title isEqualToString:USER_HOBBY_STRING]){
        HobbyViewController * hobby_vc = [[HobbyViewController alloc] init];
        hobby_vc.titles_array = hobby_titles_array;
        [self.navigationController pushViewController:hobby_vc animated:YES];
        
        __weak typeof(self)wself = self;
        [hobby_vc selectedBlock:^(NSMutableArray *array) {
//            hobby_titles_array = array;
            [wself.right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            wself.navigationItem.rightBarButtonItem.enabled = YES;

            [wself.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView * header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 55)];
        header_view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        
        
        UIImage * image = [UIImage imageNamed:@"person_high_level_image"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(25+image.size.width/2.0f, header_view.height/2.0f);
        [header_view addSubview:imageView];
        
        UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 10, 10, DEVICE_WIDTH-imageView.right - 35, 35)];
        title_label.text = @"完善以下信息立即升级高级用户";
        title_label.font = [ZTools returnaFontWith:18];
        title_label.textAlignment = NSTextAlignmentLeft;
        title_label.textColor = [UIColor whiteColor];
        title_label.adjustsFontSizeToFitWidth = YES;
        [header_view addSubview:title_label];
        
        return header_view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 55;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * title = @"";
    
    if ([ZTools getGrade] == 2) {
        title = _title_array[indexPath.row];
    }else{
        title = _title_array[indexPath.section][indexPath.row];
    }
    
    if ([title isEqualToString:USER_HOBBY_STRING]){
        if (hobby_titles_array && hobby_titles_array.count != 0) {
            [self createTitlesView];
            return hobby_titles_view.height + 50;
        }else{
            return 44;
        }
    }else{
        return 44;
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

#pragma mark -----   创建标签视图
-(void)createTitlesView{
    if (!hobby_titles_view) {
        hobby_titles_view = [[UIView alloc] initWithFrame:CGRectMake(12, 45, DEVICE_WIDTH-60, 0)];
    }
    
    for (UIView * view in hobby_titles_view.subviews) {
        [view removeFromSuperview];
    }
    
    float width = 0;
    float height = 0;
   
    for (int i = 0; i < hobby_titles_array.count; i++) {
        NSString * title = [hobby_titles_array objectAtIndex:i];
        if (title.length == 0) {
            continue;
        }
        
        CGSize title_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:title WithWidth:MAXFLOAT];
        
        if (width + title_size.width+20+10 > hobby_titles_view.width) {
            width = 0;
            height += 45;
        }
        
        UIButton * button = [ZTools createButtonWithFrame:CGRectMake(width, height, title_size.width+20, 25) tag:1000+i title:title image:nil];
        button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [ZTools returnaFontWith:15];
        button.layer.cornerRadius = 5;
        button.userInteractionEnabled = NO;
        [hobby_titles_view addSubview:button];
        
        width += (title_size.width + 20 + 15);
    }
    hobby_titles_view.height = height + 25 + 20;
}

#pragma mark -----   用户等级说明
-(void)userLevelIntroduction{
    SAlertView * alertView = [[SAlertView alloc] initWithTitle:@"用户等级说明" WithContentView:nil WithCancelTitle:@"确认" WithDoneTitle:@""];
    [alertView alertShow];
    
    UIView * content_view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, alertView.contentView.width,240)];
    NSString * level_introduction_string = @"1.接单价格高于普通用户\n2.可承接高价格指定任务";
    //提示信息
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:level_introduction_string];
    [str addAttribute:NSForegroundColorAttributeName value:DEFAULT_BACKGROUND_COLOR range:[level_introduction_string rangeOfString:@"普通用户"]];
    [str addAttribute:NSForegroundColorAttributeName value:DEFAULT_BACKGROUND_COLOR range:[level_introduction_string rangeOfString:@"高级用户"]];

    CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:level_introduction_string WithWidth:content_view.width-20];
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, content_view.width-20, size.height)];
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.font = [ZTools returnaFontWith:15];
    title_label.textColor = RGBCOLOR(57, 57, 57);
    title_label.numberOfLines = 0;
    title_label.attributedText = str;
    
    content_view.height = title_label.bottom + 20;
    [content_view addSubview:title_label];
    
    alertView.contentView = content_view;
}
#pragma mark -----   性别
-(void)modifiySex{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}
#pragma mark ------  地区
-(void)modifiyArea{
    [self addTapGestureRecognizer];
    show_type = @"area";
    if (area_array) {
        [self pickerViewShow:YES];
        return;
    }
    
    __weak typeof(self)bself = self;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        area_array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        NSLog(@"area_array ---   %@",area_array);
        dispatch_async(dispatch_get_main_queue(), ^{
            [bself.myPickerView reloadAllComponents];
            [bself pickerViewShow:YES];
        });
    });
}
#pragma mark --------  选取年龄
-(void)chooseAge{
    [self addTapGestureRecognizer];
    show_type = @"age";
    if (!_date_picker) {
        _date_picker = [[SYearPickerView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 215)];
        _date_picker.maximumYear = [NSNumber numberWithInteger:[[ZTools timechangeWithDate:[NSDate date] WithFormat:@"YYYY"] intValue]];
        _date_picker.minimumYear = @1900;
        _date_picker.backgroundColor = [UIColor whiteColor];
        [_date_picker selectRow:(_date_picker.maximumYear.intValue-_date_picker.minimumYear.intValue-1) inComponent:0 animated:YES];
        [self.view addSubview:_date_picker];
        
        __weak typeof(self)wself = self;
        [_date_picker didSelectedRow:^(NSString *title, int index) {
            user_age_string = [NSString stringWithFormat:@"%d",wself.date_picker.maximumYear.intValue - title.intValue];
            [wself.myTableView reloadData];
        }];
    }
    

    [self datePickerViewShow:YES];
}

#pragma mark -------  行业
-(void)modifiyIndustry{
    //读取行业信息
    
    if (!industry_array) {
        NSString * industry_path = [[NSBundle mainBundle] pathForResource:@"IndustryList" ofType:@"plist"];
        industry_array = [[NSMutableArray alloc] initWithContentsOfFile:industry_path];
    }

    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"行业" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = 101;
    
    
    for (NSString * string in industry_array) {
        [actionSheet addButtonWithTitle:string];
    }
    [actionSheet showInView:self.view];
}


#pragma mark --------  UIActionSheet Delegate------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag){
        case 100:
        {
            if (buttonIndex == 0) {
                user_sex_string = @"男";
            }else if(buttonIndex == 1){
                user_sex_string = @"女";
            }
        }
            break;
        case 101:
        {
            if (buttonIndex != 0) {
                user_job_string = industry_array[buttonIndex-1];
            }
        }
            break;
            
        default:
            break;
    }
    [_myTableView reloadData];
}
#pragma mark -------  UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10000) {
        if (buttonIndex == 0) {
            
        }else if(buttonIndex == 1){
            
        }
        NSLog(@"buttonIndex ----  %ld",(long)buttonIndex);
    }
}

#pragma mark ----------------------  UIToolBar Methods
- (IBAction)toolBarCancelTap:(id)sender {
    [self removeTapGestureRecognizer];
    if ([show_type isEqualToString:@"area"]) {
        [self pickerViewShow:NO];
    }else if ([show_type isEqualToString:@"age"]){
        [self datePickerViewShow:NO];
        
    }
}

- (IBAction)toolBarDoneTap:(id)sender {
    [self removeTapGestureRecognizer];
    if ([show_type isEqualToString:@"area"]) {
        [self pickerViewShow:NO];
    }else if ([show_type isEqualToString:@"age"]){
        [self datePickerViewShow:NO];
        
    }
}

#pragma mark --------   UIPickerViewDelegate ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return area_array.count;
        
    } else if (component == 1) {
        NSArray * cities = area_array[_flagRow][@"Cities"];
        return cities.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        return area_array[row][@"State"];
        
    } else if (component == 1)
    {
        NSString * _str2 = area_array[_flagRow][@"Cities"][row][@"city"];
        
        return _str2;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _flagRow = (int)row;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        _flagRow1 = 0;
    } else if (component == 1)
    {
        _flagRow1 = (int)row;
    }
    
    NSString * provance = area_array[_flagRow][@"State"];
    
    if ([area_array[_flagRow][@"Cities"] count] > _flagRow1) {
        NSString * city = area_array[_flagRow][@"Cities"][_flagRow1][@"city"];
        if ([city isEqualToString:@"市区县"]) {
            city = @"";
        }
        user_area_string = [NSString stringWithFormat:@"%@ %@",provance,city];
    }else{
        user_area_string = provance;
    }
    
    [_myTableView reloadData];
    [pickerView reloadAllComponents];
}


#pragma mark-----  弹出收起 UIPickerView
-(void)pickerViewShow:(BOOL)isShow{
    
    [UIView animateWithDuration:0.3f animations:^{
        _myToolBar.top = isShow?(DEVICE_HEIGHT-_myPickerView.height-_myToolBar.height-64):DEVICE_HEIGHT;
        _myPickerView.top = isShow?(DEVICE_HEIGHT-_myPickerView.height-64):DEVICE_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark-----  弹出收起 UIDatePickerView
-(void)datePickerViewShow:(BOOL)isShow{
    [UIView animateWithDuration:0.3f animations:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _myToolBar.top = isShow?(DEVICE_HEIGHT-_date_picker.height-_myToolBar.height-64):DEVICE_HEIGHT;
            _date_picker.top = isShow?(DEVICE_HEIGHT-_date_picker.height-64):DEVICE_HEIGHT;

        });
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SuccessReloadPersonalInfomation" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
