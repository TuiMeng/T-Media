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
#import "MyOutPrizeCell.h"
#import "LotteryView.h"
#import "AddressManangerViewController.h"

@interface MyPrizeViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UISegmentedControl * segmentC;
    //兑换界面
    LotteryView * lotteryView;
}

@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)MyPrizeModel         * model;
//所选类型
@property(nonatomic,assign)int                  currentPage;

@end


@implementation MyPrizeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (lotteryView) {
        lotteryView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (lotteryView) {
        lotteryView.hidden = YES;
    }
}



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
        [wself endLoading];
        if (array.count == 0) {
            wself.myTableView.isHaveMoreData = NO;
        }
        [wself.myTableView finishReloadigData];
    } withFailure:^(NSString *error) {
        [wself endLoading];
    }];
}
//兑换礼品
-(void)getPrizeWithTaskID:(NSString *)taskId prizeID:(NSString *)prizeId virtual:(BOOL)isVirtual {
    
    if (lotteryView) {
        [lotteryView removeFromSuperview];
        lotteryView = nil;
    }
    lotteryView = [LotteryView sharedInstance];
    __WeakSelf__ wself = self;
    [lotteryView showConertViewWithVirtual:isVirtual convertBlock:^{
        [[PrizeModel sharedInstance] getPrizeWithTaskID:taskId prizeID:prizeId success:^{
            [ZTools showMBProgressWithText:@"兑换成功，请注意查收" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            [wself getData];
        } failed:^(NSString *errorInfo) {
            [ZTools showMBProgressWithText:errorInfo WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }];
    } modifyBlock:^{
        [wself showAddressMananger];
    }];
}

#pragma mark -----  数据切换
-(void)segmentedControlValueChanged:(UISegmentedControl *)sender{
    _currentPage = (int)sender.selectedSegmentIndex+1;
    
    if ([self.model.dataArray[sender.selectedSegmentIndex] count] == 0) {
        [self startLoading];
        [self getData];
    }else {
        
        [_myTableView finishReloadigData];
    }
    
}

#pragma mark -----  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.model.dataArray[segmentC.selectedSegmentIndex] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_currentPage == 1) {
        static NSString * identifier = @"identifier1";
        MyPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        MyPrizeModel * model = self.model.dataArray[segmentC.selectedSegmentIndex][indexPath.row];
        __WeakSelf__ wself = self;
        [cell setInfomationWithMyPrizeModel:model getPrizeBlock:^(PrizeStatusModel * prizeModel){
            [wself getPrizeWithTaskID:model.task_id prizeID:prizeModel.did virtual:(prizeModel.isVirtual.intValue == 1)];
        } lookTaskContentBlock:^{
            
            RootTaskListModel * taskModel = [[RootTaskListModel alloc] init];
            taskModel.content = model.task_content;
            
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TaskDetailViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
            viewController.task_model = taskModel;
            [wself.navigationController pushViewController:viewController animated:YES];
        }];
        
        return cell;
    }else if (_currentPage == 2) {
        static NSString * identifier = @"identifier2";
        MyOutPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyOutPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        MyPrizeModel * model = self.model.dataArray[segmentC.selectedSegmentIndex][indexPath.row];
        [cell setInfomationWithMyPrizeModel:model];
        
        return cell;
    }
    
    
    return nil;
}


-(void)loadNewData{
    [self getData];
}
- (void)loadMoreData{
    
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    if (_currentPage == 1) {
        MyPrizeModel * model = self.model.dataArray[segmentC.selectedSegmentIndex][indexPath.row];
        return 40 + model.prizes.count*55;
    } else if (_currentPage ==2) {
        return 64;
    }
    return 0;
}



#pragma mark -----  跳转到收货地址界面
-(void)showAddressMananger{
    AddressManangerViewController * viewController = [[AddressManangerViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController save:^(UserAddressModel *model) {
        if (lotteryView) {
            [lotteryView setupAddressWithAddressModel:model];
        }
    }];
}


@end
