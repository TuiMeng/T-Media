//
//  MConfirmOrderViewController.m
//  推盟
//
//  Created by joinus on 16/3/16.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MConfirmOrderViewController.h"
#import "MPayViewController.h"
#import "MovieSelectSeatViewController.h"
#import "UIAlertView+Blocks.h"

#define MTOTALPRICE     @"总价"
#define MUSEPOINT       @"使用积分"
#define MPONIT          @"积分"
#define MNEEDTOPAY      @"还需支付"
//积分支付比例
#define PAYMENT_RATIO   0.5

@interface MConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UILabel             * countDownLabel;
    int                 timeCount;
    NSArray             * titleArray;
    UISwitch            * switchView;
    STextField          * phoneNumTextField;
}


@property(nonatomic,strong)UITableView      * myTableView;
//积分抵消费用
@property(nonatomic,assign)int              scorePrice;
//全部服务费用
@property(nonatomic,assign)float            serverPrice;
//总共需要支付的费用
@property(nonatomic,assign)float            totalPrice;

@end


@implementation MConfirmOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCount:) name:NOTIFICATION_TIME_STRING object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_STRING object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"确认订单";
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypeBack WihtLeftString:@"backImage"];
    
    
    timeCount = 900;
    titleArray = @[MTOTALPRICE,MUSEPOINT,MPONIT,MNEEDTOPAY];
    
    [self updatePriceWithUseScore:YES];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"座位预订成功，请仔细核对场次信息，并在15分钟内完成支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self setMainView];
}

-(void)doTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

-(void)updatePriceWithUseScore:(BOOL)isUse{
    
    float score = 0;
    if (isUse) {
        float movieMoney = _sequenceModel.price.floatValue - _sequenceModel.fee.intValue;
        int restMoney = [[ZTools getRestMoney] intValue];
        //积分最高可用数
        int scoreMaxMoney = movieMoney*_seatArray.count*PAYMENT_RATIO;
        
        if (restMoney/10 >= scoreMaxMoney) {
            score = scoreMaxMoney;
        }else{
            score = restMoney/10;
        }
    }
    
    _scorePrice     = score;
    _serverPrice    = ceilf([_sequenceModel.fee intValue]*(int)_seatArray.count);
    _totalPrice     = ceilf(_seatArray.count*([_sequenceModel.price floatValue]));
}

-(void)setMainView{
    
    countDownLabel = [ZTools createLabelWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 42) text:@"支付剩余时间：15:00" textColor:RGBCOLOR(255,186,0) textAlignment:NSTextAlignmentCenter font:14];
    countDownLabel.backgroundColor = RGBCOLOR(254, 244, 217);
    [self.view addSubview:countDownLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, countDownLabel.height-1, countDownLabel.width, 1)];
    lineView.backgroundColor = RGBCOLOR(241, 226, 206);
    [countDownLabel addSubview:lineView];
    
        
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, countDownLabel.bottom, DEVICE_WIDTH, DEVICE_HEIGHT-64-countDownLabel.height) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.view addSubview:_myTableView];
    
    [self createHeaderView];
    [self createFooterView];
    
    [[MovieNetWork sharedManager] orderTimerStartTimeInterval:1.0f repeats:YES TotalCount:timeCount timer:nil];
}

#pragma mark ------  网络请求
//解锁所选中的座位
-(void)leftButtonTap:(UIButton *)sender{
    [[MovieNetWork sharedManager] releaseMovieSeatsWithOrderId:self.orderId];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)timeCount:(NSNotification *)notification{
        
    int count = [notification.object intValue];
    
    [self setTimeWithCount:count];
}


-(void)setTimeWithCount:(int)count{
    timeCount           = count;
    countDownLabel.text = [NSString stringWithFormat:@"支付剩余时间：%02d:%02d",timeCount/60,timeCount%60];
    
    if (timeCount == 0) {
        UIAlertView * alertView     = [[UIAlertView alloc] initWithTitle:@"" message:@"支付超时，该订单已失效，请重新选座购买" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        countDownLabel.text         = @"订单支付超时，请重新选择座位";
        [[MovieNetWork sharedManager] endTimer];
    }
}

#pragma mark ------ 创建头部视图
-(void)createHeaderView{
    UIView * headerView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 230)];
    headerView.backgroundColor  = RGBCOLOR(254, 244, 218);
    headerView.backgroundColor  = GRAY_BACKGROUND_COLOR;
    
    SView * moviewTicketInfoView            = [[SView alloc] initWithFrame:CGRectMake(0, 15, DEVICE_WIDTH, 130)];
    moviewTicketInfoView.backgroundColor    = [UIColor whiteColor];
    moviewTicketInfoView.lineColor          = LINE_COLOR;
    moviewTicketInfoView.isShowTopLine      = YES;
    moviewTicketInfoView.isShowBottomLine   = YES;
    [headerView addSubview:moviewTicketInfoView];
    //电影名称
    UILabel * movieNameLabel    = [ZTools createLabelWithFrame:CGRectMake(15, 15, DEVICE_WIDTH-30, 18) text:_movie_model.movieName textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    [moviewTicketInfoView addSubview:movieNameLabel];
    //影院名称
    UILabel * cinemaNameLabel   = [ZTools createLabelWithFrame:CGRectMake(15, movieNameLabel.bottom+10, DEVICE_WIDTH-30, 18) text:_cinema_model.cinemaName textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    [moviewTicketInfoView addSubview:cinemaNameLabel];
    //座位
    UILabel * seatInfoLabel     = [ZTools createLabelWithFrame:CGRectMake(15, cinemaNameLabel.bottom+10, DEVICE_WIDTH-30, 18) text:[NSString stringWithFormat:@"%@ %@",_sequenceModel.hallName,[self returnSeatNum]] textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    seatInfoLabel.numberOfLines = 0;
    [seatInfoLabel sizeToFit];
    [moviewTicketInfoView addSubview:seatInfoLabel];
    //日期
    UILabel * dateLabel         = [ZTools createLabelWithFrame:CGRectMake(15, seatInfoLabel.bottom+10, DEVICE_WIDTH-30, 18) text:[NSString stringWithFormat:@"%@ %@",_sequenceModel.seqDate,_sequenceModel.seqTime] textColor:DEFAULT_RED_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
    [moviewTicketInfoView addSubview:dateLabel];
    
    moviewTicketInfoView.height = dateLabel.bottom+10;
    headerView.height = moviewTicketInfoView.bottom+20;
    _myTableView.tableHeaderView        = headerView;
}

-(void)createFooterView{
    UIView * footerView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
    footerView.backgroundColor      = GRAY_BACKGROUND_COLOR;
    
    UIImageView * mealRefundImageView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movieMealRefundImage"]];
    mealRefundImageView.center          = CGPointMake(DEVICE_WIDTH/2.0f, 30);
    [footerView addSubview:mealRefundImageView];
    
    UIButton * payButton            = [ZTools createButtonWithFrame:CGRectMake(16, mealRefundImageView.bottom+20, DEVICE_WIDTH-32, 37) title:@"确认支付" image:nil];
    payButton.titleLabel.font       = [ZTools returnaFontWith:16];
    payButton.backgroundColor       = DEFAULT_ORANGE_TEXT_COLOR;
    [payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:payButton];
    
    _myTableView.tableFooterView = footerView;
}

#pragma mark ------- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    for (UIView * obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString * title = titleArray[indexPath.row];
    if ([title isEqualToString:MTOTALPRICE]) {
        UILabel * totalLabel = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-165, 5, 150, 34) text:@"" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentRight font:12];
        totalLabel.numberOfLines = 0;
        NSString * string = [NSString stringWithFormat:@"%.1f元\n含服务费%@元/张",_totalPrice,_sequenceModel.fee];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:16] range:[string rangeOfString:[NSString stringWithFormat:@"%.1f",_totalPrice]]];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(227, 0, 0) range:[string rangeOfString:[NSString stringWithFormat:@"%.1f元",_totalPrice]]];
        totalLabel.attributedText = str;
        [cell.contentView addSubview:totalLabel];
        
    }else if ([title isEqualToString:MUSEPOINT]){
        if (!switchView) {
            switchView = [[UISwitch alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-55, 9.5, 40, 25)];
            switchView.on = [titleArray containsObject:MPONIT];
            [switchView addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
        }
        
        [cell.contentView addSubview:switchView];
    }else if ([title isEqualToString:MPONIT]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d个积分可用，已抵消%d元",_scorePrice*10,_scorePrice];
        cell.detailTextLabel.font = [ZTools returnaFontWith:15];
        cell.detailTextLabel.textColor = DEFAULT_ORANGE_TEXT_COLOR;
    }else if ([title isEqualToString:MNEEDTOPAY]){
        cell.detailTextLabel.font = [ZTools returnaFontWith:12];
        cell.detailTextLabel.textColor = DEFAULT_RED_TEXT_COLOR;
        NSString * string = [NSString stringWithFormat:@"%.1f元",_totalPrice-_scorePrice];
        NSMutableAttributedString * str = [ZTools labelTextFontWith:string Color:DEFAULT_RED_TEXT_COLOR Font:16 range:[string rangeOfString:[NSString stringWithFormat:@"%.1f",_totalPrice-_scorePrice]]];
        cell.detailTextLabel.attributedText = str;
    }
    
    cell.textLabel.text = title;
    cell.textLabel.font = [ZTools returnaFontWith:15];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)switchOn:(UISwitch *)sender{
    [self updatePriceWithUseScore:sender.on];
    if (sender.on) {
        titleArray = @[MTOTALPRICE,MUSEPOINT,MPONIT,MNEEDTOPAY];
    }else{
        titleArray = @[MTOTALPRICE,MUSEPOINT,MNEEDTOPAY];
    }
    [_myTableView reloadData];
}

-(NSString *)returnSeatNum{
    
    NSString * string = @"";
    for (SeatModel * model in _seatArray) {
       string = [string stringByAppendingString:[NSString stringWithFormat:@" %@",model.seatCode]];
    }
    return string;
}

#pragma mark --------  UIAlertViewDelegate
-(void)alertViewCancel:(UIAlertView *)alertView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    for (UIViewController * vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MovieSelectSeatViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark -----  跳转到支付界面
-(void)payButtonClicked:(UIButton *)button{
    
    
//    if (phoneNumTextField.text.length != 11) {
//        [ZTools showMBProgressWithText:@"请填写正确的手机号码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
//        return;
//    }
    
    MPayViewController * viewController         = [[MPayViewController alloc] init];
    viewController.countDown                    = timeCount;
    viewController.movie_model                  = _movie_model;
    viewController.cinema_model                 = _cinema_model;
    viewController.sequenceModel                = _sequenceModel;
    viewController.scorePrice                   = _scorePrice;
    viewController.totalPrice                   = _totalPrice;
    viewController.serverPrice                  = _serverPrice;
    viewController.orderId                      = _orderId;
    viewController.seatCount                    = (int)_seatArray.count;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)dealloc{
    [[MovieNetWork sharedManager] endTimer];
}


@end













