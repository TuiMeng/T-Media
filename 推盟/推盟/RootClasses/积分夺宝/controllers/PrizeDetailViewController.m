//
//  PrizeDetailViewController.m
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeDetailViewController.h"
#import "WinnerListCell.h"
#import "WinnerModel.h"
#import "PrizeShareViewController.h"
#import "LotteryView.h"
#import "TaskDetailViewController.h"
#import "AddressManangerViewController.h"


@interface PrizeDetailViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UIView * footerView;
    //活动规则
    UILabel * ruleIntro;
    //奖品介绍
    UILabel * prizeIntro;
    //抽奖请求
    NSURLSessionDataTask * lotteryTask;
    //抽奖界面
    LotteryView * lotteryView;
}

@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)NSMutableArray       * dataArray;

@property(nonatomic,strong)SDCycleScrollView    * cycle_scrollView;

@property(nonatomic,strong)WinnerModel          * winnerModel;

@end

@implementation PrizeDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (lotteryTask) {
        [lotteryTask cancel];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"宝贝详情";
    NSLog(@"model -----   %@",_model.task_describe);
    [self createMainView];
    
    [self createSectionView];
    [self createFooterView];
    
    [self loadDetailData];
    [self loadWinnerListData];
}

#pragma mark ---- 懒加载
-(WinnerModel *)winnerModel{
    if (!_winnerModel) {
        _winnerModel = [[WinnerModel alloc] init];
    }
    
    return _winnerModel;
}

#pragma mark ----  网络请求
-(void)loadDetailData{
    __WeakSelf__ wself = self;
    if (_model) {
        [_model loadDetailDataWithTaskID:_model.id withSuccess:^(NSMutableArray *array) {
            [wself setSectionInfo];
        } withFailure:^(NSString *error) {
            
        }];
    }
}
//获取中奖人名单数据
-(void)loadWinnerListData{
    __WeakSelf__ wself = self;
    
    [self.winnerModel loadListDataWithTaskId:_model.id page:_myTableView.pageNum withSuccess:^(NSMutableArray *array) {
        wself.myTableView.isHaveMoreData = YES;
        [wself.myTableView finishReloadigData];
    } withFailure:^(NSString *errorinfo) {
        if ([errorinfo isEqualToString:@"没有更多数据"]) {
            wself.myTableView.isHaveMoreData = YES;
        }
        [wself.myTableView finishReloadigData];
    }];
}
#pragma mark ----  抽奖
-(void)lotteryPrize{
    if (lotteryView) {
        [lotteryView removeFromSuperview];
        lotteryView = nil;
    }
    lotteryView = [LotteryView sharedInstance];
    [lotteryView loadingAnimation];
    
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"task_id":_model.id,@"user_id":[ZTools getUid]};
    lotteryTask = [[ZAPI manager] sendPost:LOTTERY_PRIZE_URL myParams:dic success:^(id data) {
        [wself createWinningView];
    } failure:^(NSError *error) {
       
    }];
}

#pragma mark ----  奖品兑换
-(void)convertPrize{
    __WeakSelf__ wself = self;
    [_model getPrizeWithTaskID:_model.id success:^{
        [ZTools showMBProgressWithText:@"兑换成功，请注意查收" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    } failed:^(NSString *errorInfo) {
        [ZTools showMBProgressWithText:errorInfo WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark ---  创建主视图
-(void)createMainView{
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-35) showLoadMore:YES];
    _myTableView.isHaveMoreData = YES;
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}
-(void)createSectionView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    UIView * prizeInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 0)];
    prizeInfoBackView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    prizeInfoBackView.layer.borderWidth = 0.5;
    [headerView addSubview:prizeInfoBackView];
    
    //轮播图
    _cycle_scrollView                   = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(5, 5, prizeInfoBackView.width-10, [ZTools autoHeightWith:180]) imageURLStringsGroup:_model.imgarr];
    _cycle_scrollView.pageControlStyle  = SDCycleScrollViewPageContolStyleClassic;
    _cycle_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycle_scrollView.autoScrollTimeInterval = 5.f;
    _cycle_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [prizeInfoBackView addSubview:_cycle_scrollView];
    //剩余数量
    UILabel * restNumLabel = [ZTools createLabelWithFrame:CGRectMake(prizeInfoBackView.width-110, _cycle_scrollView.bottom+5, 100, 20)
                                                     text:@"剩余：1000/1000"//[NSString stringWithFormat:@"剩余：%@/%@",_model.task_prize_surplus,_model.task_prize_num]
                                                textColor:DEFAULT_RED_TEXT_COLOR
                                            textAlignment:NSTextAlignmentRight
                                                     font:12];
    [prizeInfoBackView addSubview:restNumLabel];
    
    //开始结束时间
    NSArray * textArray = @[[NSString stringWithFormat:@"开始日期：%@",[ZTools timechangeWithTimestamp:_model.task_create_time WithFormat:@"MM-dd HH:mm"]],[NSString stringWithFormat:@"结束日期：%@",[ZTools timechangeWithTimestamp:_model.task_end_time WithFormat:@"MM-dd HH:mm"]]];
    for (int i = 0; i < 2; i++) {
        UILabel * label = [ZTools createLabelWithFrame:CGRectMake(5, _cycle_scrollView.bottom+10 + 21*i, restNumLabel.left - 15, 16)
                                                  text:textArray[i]
                                             textColor:DEFAULT_LINE_COLOR
                                         textAlignment:NSTextAlignmentLeft
                                                  font:13];
        [prizeInfoBackView addSubview:label];
    }
    

    //查看详情
    UIButton * detailButton = [ZTools createButtonWithFrame:CGRectMake(prizeInfoBackView.width-110, restNumLabel.bottom+5, 100, 25)
                                                      title:@"查看任务详情"
                                                      image:nil];
    detailButton.titleLabel.font = [ZTools returnaFontWith:14];
    [detailButton addTarget:self action:@selector(showTaskContent:) forControlEvents:UIControlEventTouchUpInside];
    [prizeInfoBackView addSubview:detailButton];
    
    prizeInfoBackView.height = detailButton.bottom+5;
    
    //奖品介绍
    UILabel * prizeIntroLabel = [ZTools createLabelWithFrame:CGRectMake(0, prizeInfoBackView.bottom+10, headerView.width, 25)
                                                        text:@"    奖品介绍"
                                                   textColor:DEFAULT_BLACK_TEXT_COLOR
                                               textAlignment:NSTextAlignmentLeft
                                                        font:15];
    prizeIntroLabel.backgroundColor = DEFAULT_LINE_COLOR;
    [headerView addSubview:prizeIntroLabel];
    prizeIntro = [ZTools createLabelWithFrame:CGRectMake(10, prizeIntroLabel.bottom+10, headerView.width-20, 0)
                                                   text:@"加载中..."
                                              textColor:DEFAULT_LIGHT_BLACK_COLOR
                                          textAlignment:NSTextAlignmentLeft
                                                   font:13];
    prizeIntro.numberOfLines = 0;
    [prizeIntro sizeToFit];
    [headerView addSubview:prizeIntro];
    
    //活动规则
    UILabel * ruleIntroLabel = [ZTools createLabelWithFrame:CGRectMake(0, prizeIntro.bottom+10, headerView.width, 25)
                                                        text:@"    活动规则"
                                                   textColor:DEFAULT_BLACK_TEXT_COLOR
                                               textAlignment:NSTextAlignmentLeft
                                                        font:15];
    ruleIntroLabel.backgroundColor = DEFAULT_LINE_COLOR;
    [headerView addSubview:ruleIntroLabel];
    
    ruleIntro = [ZTools createLabelWithFrame:CGRectMake(10, ruleIntroLabel.bottom+10, headerView.width-20, 0)
                                                   text:@"加载中..."
                                              textColor:DEFAULT_LIGHT_BLACK_COLOR
                                          textAlignment:NSTextAlignmentLeft
                                                   font:13];
    ruleIntro.numberOfLines = 0;
    [ruleIntro sizeToFit];
    [headerView addSubview:ruleIntro];
    
    UILabel * winnerListLabel = [ZTools createLabelWithFrame:CGRectMake(0, ruleIntro.bottom+10, headerView.width, 25)
                                                        text:@"    中奖名单"
                                                   textColor:[UIColor whiteColor]
                                               textAlignment:NSTextAlignmentLeft
                                                        font:15];
    winnerListLabel.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [headerView addSubview:winnerListLabel];
    
    
    headerView.height = winnerListLabel.bottom;
    self.myTableView.tableHeaderView = headerView;
}

-(void)setSectionInfo{
    prizeIntro.text = _model.task_describe;
    ruleIntro.text = _model.task_rule;
}

-(void)createFooterView{
    if (!footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-35-64, DEVICE_WIDTH, 35)];
        footerView.backgroundColor = [UIColor clearColor];
        NSArray * titles = @[@"获取抽奖资格",@"抽奖"];
        CGFloat buttonHeight = DEVICE_WIDTH/2.0f-0.5;
        for (int i = 0; i < 2; i++) {
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake((buttonHeight+1)*i, 0, buttonHeight, footerView.height)
                                                        title:titles[i]
                                                        image:nil];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [ZTools returnaFontWith:14];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:button];
        }
        
        [self.view addSubview:footerView];
    }
}

#pragma mark ------- 创建中奖视图
-(void)createWinningView{
    __WeakSelf__ wself = self;
    [lotteryView showWinnerViewWithPrizeName:@"Iphone6s Plus" convertBlock:^{
        [wself convertPrize];
    } modifyBlock:^{
        AddressManangerViewController * viewController = [[AddressManangerViewController alloc] init];
        [wself.navigationController pushViewController:viewController animated:YES];
    }];
}
#pragma mark -------  创建未中奖视图
-(void)createFailedView{
    [lotteryView showFailedViewWithBackTap:^{

    }];
}

#pragma mark -------- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _winnerModel.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    WinnerListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WinnerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setInfomationWithWinnerModel:_winnerModel.dataArray[indexPath.row]];
    
    return cell;
}

-(void)loadNewData{
    [self loadDetailData];
    [self loadWinnerListData];
}
- (void)loadMoreData{
    [self loadWinnerListData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark ------ 获取抽奖资格/抽奖
-(void)functionButtonClicked:(UIButton *)button{
    switch (button.tag-100) {
        case 0:
        {
            PrizeShareViewController * shareView = [[PrizeShareViewController alloc] init];
            shareView.task_id = _model.id;
            shareView.shareImageUrl = _model.task_img;
            shareView.numForLotteryOnce = _model.task_draw_num;
            [self.navigationController pushViewController:shareView animated:YES];
        }
            break;
        case 1:
        {
            
            [self lotteryPrize];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -----  查看任务详情
-(void)showTaskContent:(UIButton *)button{
    RootTaskListModel * model = [[RootTaskListModel alloc] init];
    model.content = _model.content;
    TaskDetailViewController * detailVC = [[TaskDetailViewController alloc] init];
    detailVC.task_model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
