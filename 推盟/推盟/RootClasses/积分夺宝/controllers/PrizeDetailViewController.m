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
#import "UIAlertView+Blocks.h"
#import "PersonalInfoViewController.h"
#import "UserInfoModel.h"


@interface PrizeDetailViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    UIView * footerView;
    //剩余数量
    UILabel * restNumLabel;
    //活动规则标题
    UILabel * ruleIntroLabel;
    //活动规则
    UILabel * ruleIntro;
    //奖品介绍
    UILabel * prizeIntro;
    //中奖名单
    UILabel * winnerListLabel;
    UIView * headerView;
    //抽奖请求
    NSURLSessionDataTask * lotteryTask;
    //抽奖界面
    LotteryView * lotteryView;
    //该用户该任务被点击次数
    UILabel     * allClickedNum;
    //该任务当前分享  点击 曝光量
    UILabel     * taskConsumeNum;
}

@property(nonatomic,strong)SNRefreshTableView   * myTableView;

@property(nonatomic,strong)NSMutableArray       * dataArray;

@property(nonatomic,strong)SDCycleScrollView    * cycle_scrollView;

@property(nonatomic,strong)WinnerModel          * winnerModel;

@end

@implementation PrizeDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (lotteryView) {
        lotteryView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (lotteryTask) {
        [lotteryTask cancel];
    }
    
    if (lotteryView) {
        lotteryView.hidden = YES;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"宝贝详情";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"share_button_image"];
    [self createMainView];
    
    [self createSectionView];
    
    if (_model.task_status.integerValue == 1) {
        [self createFooterView];
    }
    
    [self loadDetailData];
    [self loadWinnerListData];
    [self getLotteryTimes];
}

-(void)rightButtonTap:(UIButton *)sender{
    
    NSString * shareUrl = PRIZE_WEBSITEH5(_model.id,[ZTools getUid]);
    
    SShareView * shareView = [[SShareView alloc] initWithTitles:@[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE,SHARE_TENTCENT_QQ,SHARE_QZONE,SHARE_SINA_WEIBO]
                                                          title:@"分享给你一份神秘礼物"
                                                        content:_model.task_describe
                                                            Url:shareUrl
                                                          image:IS_YML?[UIImage imageNamed:@"yml_Icon"]:[UIImage imageNamed:@"Icon"]
                                                       location:nil
                                                    urlResource:nil
                                            presentedController:self];
    [shareView showInView:self.navigationController.view];
    
    
    [shareView shareButtonClicked:^(NSString *snsName, NSString *shareType) {
        [shareView shareWithSNS:snsName WithShareType:shareType title:[NSString stringWithFormat:@"@张少南 @什么鬼 分享给你一份神秘礼物%@",shareUrl]];
    }];
    
    __weak typeof(shareView)wShareView = shareView;
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        
    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }];

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
            [wself setInfo];
        } withFailure:^(NSString *error) {
            
        }];
    }
}
//获取中奖人名单数据
-(void)loadWinnerListData{
    __WeakSelf__ wself = self;
    
    [self.winnerModel loadListDataWithTaskId:_model.id withSuccess:^(NSMutableArray *array) {
        wself.myTableView.isHaveMoreData = NO;
        [wself.myTableView finishReloadigData];
        wself.myTableView.normalLabel.text = @"";
    } withFailure:^(NSString *errorinfo) {
        
        [wself.myTableView finishReloadigData];
        if ([errorinfo isEqualToString:@"没有更多数据"]) {
            wself.myTableView.isHaveMoreData = NO;
            wself.myTableView.normalLabel.text = @"暂无中奖信息";
        }
    }];
}

#pragma mark -----  获取抽奖次数接口
-(void)getLotteryTimes{
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"user_id":[ZTools getUid],@"task_id":_model.id};
    [[ZAPI manager] sendPost:PRIZE_TIMES_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                wself.model.can_draw_num = data[@"data"][@"draw_num"];
                [wself setDrawNumInfo];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ----  抽奖动画
-(void)lotteryPrizeAnimation{
    
    if (_model.can_draw_num.intValue == 0) {
        [ZTools showMBProgressWithText:@"您还没有抽奖机会"
                              WihtType:MBProgressHUDModeText
                             addToView:self.view
                          isAutoHidden:YES];
        return;
    }
    
    if (lotteryView) {
        [lotteryView removeFromSuperview];
        lotteryView = nil;
    }
    lotteryView = [LotteryView sharedInstance];
    [lotteryView loadingAnimation];
    //1.5秒后抽奖
    [self performSelector:@selector(lotteryPrize) withObject:self afterDelay:1.5f];
}
/**
 *  抽奖
 */
-(void)lotteryPrize {
    __WeakSelf__ wself = self;
    NSDictionary * dic = @{@"task_id":_model.id,@"user_id":[ZTools getUid]};
    lotteryTask = [[ZAPI manager] sendPost:LOTTERY_PRIZE_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                if ([data[@"isprize"] intValue] == 1)//中奖
                {
                    BOOL isVirtual = ([data[@"isVirtual"] intValue] == 1);
                    [wself createWinningViewWithName:data[@"prize_name"] isVirtual:isVirtual WithPrizeId:data[@"did"]];
                }else if ([data[@"isprize"] intValue] == 2)//未中奖
                {
                    [wself createFailedView];
                }
                int draw_num = [wself.model.can_draw_num intValue];
                wself.model.can_draw_num = [NSString stringWithFormat:@"%d",draw_num-1];
                [wself getLotteryTimes];
            }else{
                [lotteryView removeFromSuperview];
                [ZTools showMBProgressWithText:data[ERROR_INFO]
                                      WihtType:MBProgressHUDModeText
                                     addToView:wself.view
                                  isAutoHidden:YES];
            }
        }else{
            [lotteryView removeFromSuperview];
            [ZTools showMBProgressWithText:@"请求失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
        }
    } failure:^(NSError *error) {
        [lotteryView removeFromSuperview];
        [ZTools showMBProgressWithText:@"请求失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];

}

#pragma mark ----  奖品兑换
-(void)convertPrizeWithId:(NSString *)prizeId{
    __WeakSelf__ wself = self;
    [_model getPrizeWithTaskID:_model.id prizeID:prizeId  success:^{
        [ZTools showMBProgressWithText:@"兑换成功，请注意查收" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    } failed:^(NSString *errorInfo) {
        [ZTools showMBProgressWithText:errorInfo WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark ---  创建主视图
-(void)createMainView{
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.isHaveMoreData = YES;
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}
-(void)createSectionView{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    
    UIView * prizeInfoBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, 0)];
//    prizeInfoBackView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
//    prizeInfoBackView.layer.borderWidth = 0.5;
    [headerView addSubview:prizeInfoBackView];
    
    //轮播图
    _cycle_scrollView                   = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(5, 5, prizeInfoBackView.width-10, [ZTools autoHeightWith:185]) imageURLStringsGroup:_model.imgarr];
    _cycle_scrollView.pageControlStyle  = SDCycleScrollViewPageContolStyleClassic;
    _cycle_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycle_scrollView.autoScrollTimeInterval = 5.f;
    _cycle_scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [prizeInfoBackView addSubview:_cycle_scrollView];
    //剩余数量
    restNumLabel = [ZTools createLabelWithFrame:CGRectMake(prizeInfoBackView.width-110, _cycle_scrollView.bottom+5, 100, 20)
                                                     text:[NSString stringWithFormat:@"奖品剩余：%@/%@",_model.task_prize_surplus,_model.task_prize_num]
                                                textColor:DEFAULT_RED_TEXT_COLOR
                                            textAlignment:NSTextAlignmentRight
                                                     font:12];
    [prizeInfoBackView addSubview:restNumLabel];
    
    //开始结束时间
    NSArray * textArray = @[[NSString stringWithFormat:@"开始日期：%@",[ZTools timechangeWithTimestamp:_model.task_create_time WithFormat:@"MM-dd HH:mm"]],[NSString stringWithFormat:@"结束日期：%@",[ZTools timechangeWithTimestamp:_model.task_end_time WithFormat:@"MM-dd HH:mm"]]];
    for (int i = 0; i < 2; i++) {
        UILabel * label = [ZTools createLabelWithFrame:CGRectMake(5, _cycle_scrollView.bottom+20 + 21*i, restNumLabel.left - 15, 16)
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
    
    allClickedNum = [ZTools createLabelWithFrame:CGRectMake(5, detailButton.bottom + 10, prizeInfoBackView.width-10, 16) text:@"点击：0次" textColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter font:13];
    [prizeInfoBackView addSubview:allClickedNum];
    
    
    taskConsumeNum = [ZTools createLabelWithFrame:CGRectMake(5, allClickedNum.bottom+10, prizeInfoBackView.width-10, 16) text:@"" textColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter font:13];
    [prizeInfoBackView addSubview:taskConsumeNum];
    
    
    prizeInfoBackView.height = taskConsumeNum.bottom;
    
    //奖品介绍
    UILabel * prizeIntroLabel = [ZTools createLabelWithFrame:CGRectMake(0, prizeInfoBackView.bottom+10, headerView.width, 25)
                                                        text:@"奖品介绍"
                                                   textColor:DEFAULT_BACKGROUND_COLOR
                                               textAlignment:NSTextAlignmentCenter
                                                        font:15];
    prizeIntroLabel.backgroundColor = RGBCOLOR(234, 234, 234);
    [headerView addSubview:prizeIntroLabel];
    prizeIntro = [ZTools createLabelWithFrame:CGRectMake(10, prizeIntroLabel.bottom+10, headerView.width-20, 15)
                                                   text:@"加载中..."
                                              textColor:DEFAULT_LIGHT_BLACK_COLOR
                                          textAlignment:NSTextAlignmentLeft
                                                   font:15];
    prizeIntro.numberOfLines = 0;
    [headerView addSubview:prizeIntro];
    
    //活动规则
    ruleIntroLabel = [ZTools createLabelWithFrame:CGRectMake(0, prizeIntro.bottom+10, headerView.width, 25)
                                                        text:@"夺宝规则"
                                                   textColor:DEFAULT_BACKGROUND_COLOR
                                               textAlignment:NSTextAlignmentCenter
                                                        font:15];
    ruleIntroLabel.backgroundColor = RGBCOLOR(234, 234, 234);
    [headerView addSubview:ruleIntroLabel];
    
    ruleIntro = [ZTools createLabelWithFrame:CGRectMake(10, ruleIntroLabel.bottom+10, headerView.width-20, 15)
                                                   text:@"加载中..."
                                              textColor:DEFAULT_LIGHT_BLACK_COLOR
                                          textAlignment:NSTextAlignmentLeft
                                                   font:12];
    ruleIntro.numberOfLines = 0;
    [headerView addSubview:ruleIntro];
    
    winnerListLabel = [ZTools createLabelWithFrame:CGRectMake(0, ruleIntro.bottom+10, headerView.width, 25)
                                                        text:@"中奖名单"
                                                   textColor:[UIColor whiteColor]
                                               textAlignment:NSTextAlignmentCenter
                                                        font:15];
    winnerListLabel.backgroundColor = RGBCOLOR(253, 141, 143);
    [headerView addSubview:winnerListLabel];
    
    
    headerView.height = winnerListLabel.bottom;
    self.myTableView.tableHeaderView = headerView;
}

-(void)setInfo{
    
    NSString * introString = [_model.task_describe stringByReplacingOccurrencesOfString:@"xxx" withString:@"\n"];
    
    prizeIntro.text     = introString;
    ruleIntro.text      = _model.task_rule;
    restNumLabel.text   = [NSString stringWithFormat:@"奖品剩余：%@/%@",_model.task_prize_surplus,_model.task_prize_num];
    
    NSString * clickNumString = [NSString stringWithFormat:@"已点击：%@次   可抽奖：%@次   已抽奖：%d次",_model.all_click,_model.can_draw_num,_model.drawed_num.intValue];
    allClickedNum.text  = clickNumString;
    
    NSString * taskConsumeString = [NSString stringWithFormat:@"转发：%@次  曝光：%@次  点击：%@次",_model.task_shared_times,_model.task_exposures,_model.task_clicks];
    taskConsumeNum.text = taskConsumeString;
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:clickNumString];
//    NSRange clickR = [clickNumString rangeOfString:@"点击："];
//    [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:10] range:clickR];
//    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(95, 95, 95) range:clickR];
//    
//    NSRange drawR = [clickNumString rangeOfString:@"可抽奖："];
//    [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:10] range:drawR];
//    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(95, 95, 95) range:drawR];
//    allClickedNum.attributedText = str;
    
    
    [prizeIntro sizeToFit];
    [ruleIntro sizeToFit];
    ruleIntroLabel.top = prizeIntro.bottom+10;
    ruleIntro.top = ruleIntroLabel.bottom+10;
    winnerListLabel.top = ruleIntro.bottom+10;
    headerView.height = winnerListLabel.bottom;
    self.myTableView.tableHeaderView = headerView;
}

-(void)createFooterView{
    if (!footerView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-35-64, DEVICE_WIDTH, 35)];
        footerView.backgroundColor = [UIColor clearColor];
        NSArray * titles = @[@"获取抽奖资格",@"我要夺宝"];
        CGFloat buttonHeight = (DEVICE_WIDTH-15)/2.0f;
        for (int i = 0; i < 2; i++) {
            UIButton * button = [ZTools createButtonWithFrame:CGRectMake(5 + (buttonHeight+5)*i, 0, buttonHeight, footerView.height)
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

-(void)setDrawNumInfo{
    UIButton * button = (UIButton *)[footerView viewWithTag:101];
    [button setTitle:[NSString stringWithFormat:@"我要夺宝（%@次）",_model.can_draw_num] forState:UIControlStateNormal];
}

#pragma mark ------- 创建中奖视图
-(void)createWinningViewWithName:(NSString * )prize isVirtual:(BOOL)isVirtual WithPrizeId:(NSString *)prizeId{
    __WeakSelf__ wself = self;
    [lotteryView showWinnerViewWithPrizeName:prize isVirtual:isVirtual convertBlock:^{
        [wself convertPrizeWithId:prizeId];
    } modifyBlock:^{
        [wself showAddressMananger];
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
    [self getLotteryTimes];
}
- (void)loadMoreData{
    
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
            shareView.task_id = _model.encrypt_id;
            shareView.shareImageUrl = _model.share_img;
            shareView.numForLotteryOnce = _model.task_draw_num;
            [self.navigationController pushViewController:shareView animated:YES];
        }
            break;
        case 1:
        {
            if ([ZTools getGrade] != 2) {
                [self normalAlertView];
                return;
            }
            
            [self lotteryPrizeAnimation];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -----  查看任务详情
-(void)showTaskContent:(UIButton *)button{
    
    RootTaskListModel * model = [[RootTaskListModel alloc] init];
    model.content = _model.task_content;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaskDetailViewController * detailVC = (TaskDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
    detailVC.task_model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
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

#pragma mark -----  判断是否为高级用户
-(void)normalAlertView{
    UIAlertView * alertView = [UIAlertView showWithTitle:@"该活动只对高级用户开放，是否立即升级为高级用户" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即升级"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPersonalInfomation:) name:@"modifyUserInfomation" object:nil];
            
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PersonalInfoViewController * vc = [storyBoard instantiateViewControllerWithIdentifier:@"PersonalInfoViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [alertView show];
}

-(void)reloadPersonalInfomation:(NSNotification *)notification {
    [self startLoading];
    __WeakSelf__ wself = self;
    [[UserInfoModel shareInstance] loadPersonInfoWithSuccess:^(UserInfoModel *model) {
        [wself endLoading];
        if (model.grade.intValue == 2) {
            [[[UIAlertView alloc] initWithTitle:@"恭喜您成为高级用户，可以参与抽奖活动" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }
    } failed:^(NSString *error) {
        [wself endLoading];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
