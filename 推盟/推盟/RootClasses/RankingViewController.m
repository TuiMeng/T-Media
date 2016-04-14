//
//  RankingViewController.m
//  推盟
//
//  Created by joinus on 15/8/25.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingModel.h"
#import "RankingTableViewCell.h"

@interface RankingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * title_array;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"收入排行榜";
    
    _data_array = [NSMutableArray array];
    title_array = @[@"排行榜",@"昵称",@"手机号",@"总收入"];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableHeaderView.height = 100;
    _myTableView.bounces = NO;
    
    // 调cell对齐
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self startLoading];
    [self loadListData];
    
}

-(void)loadListData{
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",RANGKING_LIST_URL,[ZTools getUid]] success:^(id data) {
        [self endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = data[@"status"];
            if (status.intValue == 1) {
                NSArray * array = [data objectForKey:@"ranking"];
                for (NSDictionary * dic in array) {
                    RankingModel * model = [[RankingModel alloc] initWithDictionary:dic];
                    [wself.data_array addObject:model];
                }
                [wself.myTableView reloadData];
            }else{
                [ZTools showMBProgressWithText:data[@"errorinfo"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

#pragma mark --------  UITableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    RankingTableViewCell * cell = (RankingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RankingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setInfomationWith:_data_array[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    header_view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/4.0f*i, 10, DEVICE_WIDTH/4.0f, 40)];
        label.text = title_array[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(42, 42, 42);
        label.font = [ZTools returnaFontWith:15];
        [header_view addSubview:label];
    }
    
    return header_view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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

#pragma mark ------   登录
-(void)logInTap:(UITapGestureRecognizer*)sender{
    [self performSegueWithIdentifier:@"showLogInSegue" sender:@"rangking"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showLogInSegue"]){
        UINavigationController * navc = (UINavigationController*)segue.destinationViewController;
        LogInViewController * login;
        for (UIViewController * vc in navc.viewControllers) {
            if ([vc isKindOfClass:[LogInViewController class]]) {
                login = (LogInViewController*)vc;
                [login successLogin:^(NSString *source) {
                    [self loadListData];
                }];
            }
        }
    }
}


@end
