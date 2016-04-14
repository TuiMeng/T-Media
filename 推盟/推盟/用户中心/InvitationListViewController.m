//
//  InvitationListViewController.m
//  推盟
//
//  Created by joinus on 15/9/21.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "InvitationListViewController.h"
#import "InvitationTableViewCell.h"

@interface InvitationListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel * header_label;
}

@property(nonatomic,strong)UITableView * myTableView;

@end

@implementation InvitationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"邀请列表";
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_myTableView];
    
    if (!_model) {
        [self startLoading];
        [self loadInvitationList];
    }
}

-(void)setInfomation{
    NSString * string = [NSString stringWithFormat:@"您已成功邀请%@人",_model.total_per];
    header_label.attributedText = [ZTools labelTextColorWith:string Color:RGBCOLOR(255, 201, 70) range:[string rangeOfString:_model.total_per]];
}

#pragma mark --------  网络请求
-(void)loadInvitationList{
    __weak typeof(self)wself = self;
//    @"e161ab516092bcadd857d4a116cd8a06"
    NSLog(@"---------%@",[NSString stringWithFormat:@"%@&user_id=%@",INVITATION_LIST_URL,[ZTools getUid]]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",INVITATION_LIST_URL,[ZTools getUid]] success:^(id data) {
        [self endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] ==1) {
                wself.model = [[InvitationModel alloc] initWithDictionary:data];
                [wself setInfomation];
                [wself.myTableView reloadData];
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:@"errorinfo"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  **********   UITableViewDelegate  ***************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.friend_list_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"identifier";
    
    InvitationTableViewCell * cell = (InvitationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[InvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setInfomationWith:_model.friend_list_array[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    header_view.backgroundColor = [UIColor whiteColor];
    
    header_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    header_label.text = @"您已成功邀请0人";
    header_label.font = [ZTools returnaFontWith:18];
    header_label.textAlignment = NSTextAlignmentCenter;
    header_label.textColor = DEFAULT_BACKGROUND_COLOR;
    [header_view addSubview:header_label];
    
    if (_model) {
        [self setInfomation];
    }
    
    return header_view;
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
