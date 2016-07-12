//
//  SettingViewController.m
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "SettingViewController.h"
#import "NSData+SDDataCache.h"

#define TITLE_CACHE @"清除缓存"
#define TITLE_HELP @"建议反馈"
#define TITLE_VERSION @"当前版本"
#define TITLE_ABOUT [NSString stringWithFormat:@"关于%@",APP_NAME]
#define TITLE_SUPPORT @"软件评分"
#define TITLE_LOGOUT @"退出登录"
#define TITLE_LOGIN @"立即登录"


@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * data_array;
    NSArray * image_array;
}


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"设置";
    
    data_array = [NSMutableArray arrayWithObjects:TITLE_CACHE,TITLE_HELP,TITLE_ABOUT,TITLE_SUPPORT,[ZTools isLogIn]?TITLE_LOGOUT:TITLE_LOGIN,nil];
    image_array = @[@"setting_cache_image.png",@"setting_feedback_image.png",@"setting_about_image.png",@"setting_commit_image.png",@"setting_logout_image.png"];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    // 调cell对齐
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark -----------  UITableView Delegate  -------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSString * title = data_array[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = [ZTools returnaFontWith:15];
    cell.detailTextLabel.font = [ZTools returnaFontWith:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([title isEqualToString:TITLE_CACHE]) {
        float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        cell.detailTextLabel.text = clearCacheName;
    }else if ([title isEqualToString:TITLE_VERSION]){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",CURRENT_VERSION];
    }
    
    cell.imageView.image = [UIImage imageNamed:image_array[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * title = data_array[indexPath.row];
    
    if ([title isEqualToString:TITLE_CACHE]) {
        MBProgressHUD * loading = [ZTools showMBProgressWithText:@"正在清除..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
        
        [NSData clearCache];
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [loading hide:YES];
            [ZTools showMBProgressWithText:@"清除成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
            [tableView reloadData];
        }];
    }else if ([title isEqualToString:TITLE_HELP]){
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    }else if ([title isEqualToString:TITLE_VERSION]){
        
    }else if ([title isEqualToString:TITLE_ABOUT]){
        [self performSegueWithIdentifier:@"showAboutSegue" sender:nil];
    }else if ([title isEqualToString:TITLE_SUPPORT]){
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",MYAPPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if ([title isEqualToString:TITLE_LOGOUT]){
        [self logoutTap];
    }else if ([title isEqualToString:TITLE_LOGIN]){
        [self logInTap];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark ------   退出登录
-(void)logoutTap{
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"正在退出..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    __weak typeof(self)wself = self;
    NSLog(@"user_id ----   %@",[ZTools getUid]);
    [[ZAPI manager] sendPost:LOG_OUT_URL myParams:@{@"user_id":[[ZTools getUid] length]?[ZTools getUid]:@""} success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [ZTools showMBProgressWithText:@"退出登录成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            [ZTools logOut];
            [wself.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"请求失败，请检查您当前网络" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark -----   登录
-(void)logInTap{
    
    [[LogInView sharedInstance] loginShowWithSuccess:^{
        [data_array replaceObjectAtIndex:data_array.count-1 withObject:TITLE_LOGOUT];
        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
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
