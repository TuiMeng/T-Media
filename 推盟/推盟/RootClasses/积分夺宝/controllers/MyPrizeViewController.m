//
//  MyPrizeViewController.m
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyPrizeViewController.h"
#import "MyPrizeCell.h"
#import "MyPrizeModel.h"
#import "PrizeModel.h"
#import "PrizeDetailViewController.h"
#import "TaskDetailViewController.h"

@interface MyPrizeViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UISegmentedControl * segmentC;
}

@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)MyPrizeModel         * model;
//所选类型
@property(nonatomic,assign)int                  currentPage;

@end


@implementation MyPrizeViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title_label.text = @"夺宝历史";
    
    _currentPage = 1;
    
    [self createMainView];
    
    [self getData];
}

-(MyPrizeModel *)model{
    if (!_model) {
        _model = [[MyPrizeModel alloc] init];
    }
    return _model;
}

#pragma mark ----  创建主视图
-(void)createMainView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    segmentC = [[UISegmentedControl alloc] initWithItems:@[@"已中奖",@"未中奖"]];
    segmentC.frame = CGRectMake(15, 10, DEVICE_WIDTH-30, 40);
    segmentC.tintColor = DEFAULT_BACKGROUND_COLOR;
    segmentC.selectedSegmentIndex = 0;
    [segmentC addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:segmentC];
    
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, DEVICE_WIDTH, DEVICE_HEIGHT-64-headerView.height) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}

#pragma mark ------  网络请求
-(void)getData{
    __WeakSelf__ wself = self;
    [self.model loadListDataWithType:_currentPage page:_myTableView.pageNum withSuccess:^(NSMutableArray *array) {
        [wself.myTableView finishReloadigData];
    } withFailure:^(NSString *error) {
        
    }];
}
//兑换礼品
-(void)getPrizeWithTaskID:(NSString *)taskId{
    __WeakSelf__ wself = self;
    [[PrizeModel sharedInstance] getPrizeWithTaskID:taskId success:^{
        [ZTools showMBProgressWithText:@"兑换成功，请注意查收" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    } failed:^(NSString *errorInfo) {
        [ZTools showMBProgressWithText:errorInfo WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark -----  数据切换
-(void)segmentedControlValueChanged:(UISegmentedControl *)sender{
    _currentPage = (int)sender.selectedSegmentIndex+1;
    [self getData];
}

#pragma mark -----  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.model.dataArray[segmentC.selectedSegmentIndex] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MyPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MyPrizeModel * model = self.model.dataArray[segmentC.selectedSegmentIndex][indexPath.row];
    __WeakSelf__ wself = self;
    [cell setInfomationWithMyPrizeModel:model getPrizeBlock:^{
        [wself getPrizeWithTaskID:model.task_id];
    } lookTaskContentBlock:^{
        
        RootTaskListModel * taskModel = [[RootTaskListModel alloc] init];
        taskModel.content = model.task_content;
        
        TaskDetailViewController * viewController = [[TaskDetailViewController alloc] init];
        viewController.task_model = taskModel;
        [wself.navigationController pushViewController:viewController animated:YES];
    }];
    
    return cell;
}


-(void)loadNewData{
    
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 90 + (_currentPage==1?30:0);
}

@end
