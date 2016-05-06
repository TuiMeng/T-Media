//
//  MPayViewController.m
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MPayViewController.h"
#import "MSelectPayTypeCell.h"
#import "WXManager.h"
#import "WXUtil.h"
#import "MCardPayViewController.h"
#import "UIAlertView+Blocks.h"
#import "MovieSelectSeatViewController.h"
#import "MOrderListController.h"

#define PAY_CARD    @"新影联票卡支付"
#define PAY_WECHAT @"微信支付"
#define PAY_ALIPAY  @"支付宝支付"

#define SUB_CARD_PAY    @"新影联电影卡包括：储值卡、计次卡"
#define SUB_WECHAT_PAY  @"推荐安装微信5.0及以上版本的使用"
#define SUB_ALIPAY      @"推荐有支付宝账号的用户使用"


@interface MPayViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int         currentIndex;
    NSTimer     * timer;
    UILabel     * timeLabel;
    UILabel     * timePromptLabel;
    BOOL        showCardPayOption;
    //支付类型（1：微信  2：支付宝）
    int         payType;
    
    //卡相关
    NSMutableArray          * cardDataArray;
    //卡金额
    float                   cardMoney;
    //卡信息
    NSString                * cardInfoString;
    
    //支付状态检测
    NSTimer                 * payTimer;
    
    //是否跳转到了第三方支付
    BOOL                    isGoPay;
    //支付信息
    NSMutableDictionary     * payInfoDic;
    
    MBProgressHUD * payLoadingHUD;
    

}



@property(nonatomic,strong)UITableView  * myTableView;

@property(nonatomic,strong)NSArray      * titleArray;
//加密字符
@property(nonatomic,strong)NSString     * sign;

@end

@implementation MPayViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCount:) name:NOTIFICATION_TIME_STRING object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)applicationWillEnterForeground:(NSNotification *)notification{
    if (isGoPay) {
        isGoPay = NO;
        [self loadPayState];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text       = @"支付订单";
    self.view.backgroundColor   = GRAY_BACKGROUND_COLOR;
    showCardPayOption           = YES;
    if (showCardPayOption) {
        currentIndex = 1;
        _titleArray = @[PAY_CARD,PAY_WECHAT,SUB_CARD_PAY,SUB_WECHAT_PAY,@"pay_card_image",@"pay_wechat_image"];
    }else{
        _titleArray = @[PAY_WECHAT,SUB_CARD_PAY,SUB_WECHAT_PAY,@"pay_wechat_image"];
    }
    
    NSDictionary * dic = @{@"pay_no":_orderId,                                                  //订单号
                           @"order_from":@"2",                                                  //订单来源（1：安卓 2：ios）
                           @"movie_money":@(_sequenceModel.price.floatValue-_sequenceModel.fee.intValue),                                 //单张电影票价格
                           @"page":@(_seatCount),                                               //座位数
                           @"fee":_sequenceModel.fee.length?_sequenceModel.fee:@"0",                                              //手续费
                           @"pay_money1":@"0",                                                  //银联支付金额
                           @"integral":@(_scorePrice?_scorePrice:0)};                            //兑换使用的积分
    payInfoDic          = [[NSMutableDictionary alloc] initWithDictionary:dic];


    
    [self setMainView];
    
    [self buildSign];
    
    //检测微信支付状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayState:) name:@"WChatPayState" object:nil];
}

-(void)timeCount:(NSNotification *)notification{
    
    _countDown = [notification.object intValue];
    
    [self timeDown];
}



-(void)setMainView{
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.backgroundColor = GRAY_BACKGROUND_COLOR;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    [self createHeaderView];
    [self createFooterView];
}


-(void)createHeaderView{
    
    SView * headerView = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 160)];
    headerView.backgroundColor = GRAY_BACKGROUND_COLOR;
    
    SView * timeView = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    timeView.lineColor = LINE_COLOR;
    timeView.isShowBottomLine = YES;
    [headerView addSubview:timeView];
    
    timePromptLabel = [ZTools createLabelWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 15) text:@"支付剩余时间" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentCenter font:12];
    [timeView addSubview:timePromptLabel];
    
    timeLabel = [ZTools createLabelWithFrame:CGRectMake(15, timePromptLabel.bottom+2, DEVICE_WIDTH-30, 18) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:16];
    [timeView addSubview:timeLabel];
    
    SView * orderView = [[SView alloc] initWithFrame:CGRectMake(0, timeView.bottom, DEVICE_WIDTH, 100)];
    orderView.backgroundColor = [UIColor whiteColor];
    orderView.lineColor = LINE_COLOR;
    orderView.isShowBottomLine = YES;
    [headerView addSubview:orderView];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.width/2.0f;
    imageView.image = [UIImage imageNamed:@"Icon"];
    [orderView addSubview:imageView];
    
    NSString * priceString = [NSString stringWithFormat:@"还需支付：￥%.1f",_totalPrice-_scorePrice];
    UILabel * priceLabel = [ZTools createLabelWithFrame:CGRectMake(imageView.right+20, 27, DEVICE_WIDTH-imageView.right-20, 30) text:@"" textColor:DEFAULT_RED_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:20];
    priceLabel.attributedText = [ZTools labelTextFontWith:priceString Color:DEFAULT_BLACK_TEXT_COLOR Font:13 range:[priceString rangeOfString:@"还需支付："]];
    [orderView addSubview:priceLabel];
    
    UILabel * orderIdLabel = [ZTools createLabelWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom+3, priceLabel.width, 15) text:[NSString stringWithFormat:@"订单编号：%@",_orderId] textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
    orderIdLabel.numberOfLines = 0;
    [orderIdLabel sizeToFit];
    [orderView addSubview:orderIdLabel];
    
    _myTableView.tableHeaderView = headerView;
}

-(void)createFooterView{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
    footerView.backgroundColor = GRAY_BACKGROUND_COLOR;
    
    UIButton * payButton = [ZTools createButtonWithFrame:CGRectMake(16, 40, DEVICE_WIDTH-32, 37) title:@"确认支付" image:nil];
    payButton.titleLabel.font = [ZTools returnaFontWith:16];
    payButton.backgroundColor = DEFAULT_ORANGE_TEXT_COLOR;
    [payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:payButton];
    
    _myTableView.tableFooterView = footerView;
}

-(void)timeDown{
    _countDown--;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",_countDown/60,_countDown%60];
    
    if (_countDown == 0) {
        timeLabel.text          = @"";
        timePromptLabel.text    = @"订单支付超时，请重新选择座位";
        
        [[MovieNetWork sharedManager] endTimer];
        
        
        UIAlertView * alertView     = [UIAlertView showWithTitle:@"支付超时，该订单已失效，请重新选座购买" message:@"" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            [self popToSeatsController];
        }];
        
        [alertView show];
    }
}


#pragma mark ------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count/3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    MSelectPayTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MSelectPayTypeCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * title                = _titleArray[indexPath.row];
    cell.titleLabel.text            = title;
    cell.subTitleLabel.text         = _titleArray[indexPath.row+_titleArray.count/3];
    cell.headerImageView.image      = [UIImage imageNamed:_titleArray[indexPath.row+_titleArray.count/3*2]];
    cell.selectButton.tag           = 100 + indexPath.row;
    
    if ([title isEqualToString:PAY_CARD]) {
        cell.selectButton.hidden    = YES;
        cell.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType          = UITableViewCellAccessoryNone;
        cell.selectButton.hidden    = NO;
    }
    
    if (currentIndex == indexPath.row) {
        cell.selectButton.selected = YES;
    }else{
        cell.selectButton.selected = NO;
    }
    
    __weak typeof(self)wself = self;
    [cell selectedBlock:^(UIButton *button, id cell) {
        [wself resetStateWithIndex:(int)button.tag-100];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * title                = _titleArray[indexPath.row];
    
    if ([title isEqualToString:PAY_CARD]) {
        
        MCardPayViewController      * viewController = [[MCardPayViewController alloc] init];
        viewController.countDown    = _countDown;
        viewController.orderId      = _orderId;
        viewController.needPayPrice = _totalPrice-_scorePrice;
        viewController.cardInfoArray = cardDataArray;
        viewController.payInfoDic   = payInfoDic;
        viewController.sign         = [self buildSign];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        [viewController chooseCardWith:^(float payMoney, NSString *cardInfo, NSMutableArray *cardArray) {
            NSLog(@"zhang ----  %f ----  %@",payMoney,cardInfo);
            cardMoney           = payMoney;
            cardInfoString      = cardInfo;
            cardDataArray       = cardArray;
        }];
        
        return;
    }
    
    if (currentIndex != indexPath.row) {
        MSelectPayTypeCell * current_cell = [tableView cellForRowAtIndexPath:indexPath];
        MSelectPayTypeCell * pre_cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
        
        current_cell.selectButton.selected = YES;
        pre_cell.selectButton.selected = NO;
        currentIndex = (int)indexPath.row;
    }
}

-(void)resetStateWithIndex:(int)index{
    MSelectPayTypeCell * cell = [_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    cell.selectButton.selected = NO;
    currentIndex = index;
}

-(NSString *)buildSign{
    if (!_sign) {
        NSString * first = [WXUtil md5:[NSString stringWithFormat:@"e%@p%@o%@i%@",_movie_model.movieId,_cinema_model.cinemaId,[ZTools getUid],_sequenceModel.seqId]];
                            
        _sign = [[WXUtil md5:[NSString stringWithFormat:@"%@nt188542360",[first lowercaseString]]] lowercaseString];
    }
    NSLog(@"md5 ----   %@",_sign);
    return _sign;
}


-(void)payButtonClicked:(UIButton *)button{
    
    [MobClick event:@"MovieBuyTickets"];
        
    [self startLoading];
    __weak typeof(self)wself = self;
    
    [payInfoDic setObject:currentIndex==1?@"1":@"2" forKey:@"pay_mode"];                        //支付方式（1：微信 2：支付宝
    [payInfoDic setObject:(cardMoney+_scorePrice) > _totalPrice?@"2":@"1" forKey:@"pay_type"];  //支付类型（1：线上，通过第三方  2：线下，不经过第三方
    [payInfoDic setObject:@(_totalPrice-cardMoney-_scorePrice) forKey:@"money"];                //用户需要支付的金额
    [payInfoDic setObject:@(cardMoney?cardMoney:0) forKey:@"pay_money2"];                       //电影卡支付金额
    [payInfoDic setObject:cardInfoString?cardInfoString:@"" forKey:@"nfa_ticket"];              //电影卡字符串信息
    [payInfoDic setObject:[ZTools timechangeToDateline] forKey:@"order_data"];                  //支付日期
    [payInfoDic setObject:[self buildSign] forKey:@"sign"];                                     //加密字符

    /*
    NSDictionary * dic = @{@"pay_no":_orderId,                                                  //订单号
                           @"order_from":@"2",                                                  //订单来源（1：安卓 2：ios）
                           @"pay_mode":currentIndex==1?@"1":@"2",                               //支付方式（1：微信 2：支付宝）
                           @"pay_type":(cardMoney+_scorePrice) > _totalPrice?@"2":@"1",         //支付类型（1：线上，通过第三方  2：线下，不经过第三方）
                           @"money":@(_totalPrice-cardMoney-_scorePrice),                       //用户需要支付的金额
                           @"movie_money":_sequenceModel.price,                                 //单张电影票价格
                           @"page":@(_seatCount),                                               //座位数
                           @"fee":@(_serverPrice),                                              //手续费
                           @"pay_money1":@"0",                                                  //银联支付金额
                           @"integral":@(_scorePrice?_scorePrice:0),                            //兑换使用的积分
                           @"pay_money2":@(cardMoney?cardMoney:0),                              //电影卡支付金额
                           @"nfa_ticket":cardInfoString?cardInfoString:@"",                     //电影卡字符串信息
                           @"order_data":[ZTools timechangeToDateline]};                        //支付日期
     */
    
    NSLog(@"dic ------   %@",payInfoDic);
    
    [[ZAPI manager] sendMoviePost:MOVIE_PAY_ORDER_URL myParams:payInfoDic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = data[ERROR_CODE];
            if (status.intValue == 1) {
                float fee = _totalPrice-cardMoney-_scorePrice;
                if (fee > 0) {
                    UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"还需支付%.1f元",fee] cancelButtonTitle:@"取消" otherButtonTitles:@[@"支付"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [wself wechatPay];
                        }
                    }];
                    
                    [alertView show];
                }
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

-(void)wechatPay{
    MBProgressHUD * loadingHUD = [ZTools showMBProgressWithText:@"发起支付中..." WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:NO];
    WXManager * manager = [[WXManager alloc] initWithAppID:WECHAT_APPKEY mchID:WECHAT_MCHID spKey:PARTNER_ID];
    NSString * fee = [NSString stringWithFormat:@"%.0f",(_totalPrice-cardMoney-_scorePrice)*100];
    
    NSMutableDictionary * dict = [manager getPrepayWithOrderName:_movie_model.movieName price:fee device:@"1000" orderId:_orderId];
    [loadingHUD hide:YES];
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            
            isGoPay = YES;
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            BOOL success = [WXApi sendReq:req];
            
//            [self alert:@"提示信息" msg:success?@"支付成功":@"支付失败"];
            NSLog(@"success ----  %d",success);
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }
    }else{
        [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
    }
}

#pragma mark ------  获取电影卡信息

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

#pragma mark -----   检测支付状态
-(void)checkPayState{
    __WeakSelf__ wself = self;
    [[ZAPI manager] sendMoviePost:MOVIE_CHECK_PAY_INFO_URL myParams:@{@"pay_no":_orderId} success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status   = data[ERROR_CODE];
            if (status.intValue == 1) {
                [payLoadingHUD hide:YES];
                [payTimer invalidate];
                UIAlertView * alertView = [UIAlertView showWithTitle:@"您已支付成功，正在获取取票码，如果15分钟之后未收到通知短信，请您拨打400-666-9696与客服联系" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    MOrderListController * orderList = [[MOrderListController alloc] init];
                    [wself.navigationController pushViewController:orderList animated:YES];
                    
                }];
                [alertView show];
            }else{
                
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadPayState{
    payLoadingHUD = [ZTools showMBProgressWithText:@"获取订单状态..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:YES];
    if (!payTimer) {
        payTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkPayState) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:payTimer forMode:NSDefaultRunLoopMode];
    }
    
    if (!payTimer.valid) {
        [payTimer fire];
    }
}

#pragma mark ---  检测微信支付状态
-(void)weChatPayState:(NSNotification *)notification{
    
    NSString * result = (NSString *)notification.object;
    
    if ([result rangeOfString:@"ret=0"].length == 0) {
        UIAlertView * alertView = [UIAlertView showWithTitle:@"支付失败" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
        [alertView show];
        
        isGoPay = NO;
        
        [payTimer invalidate];
        
        [[ZAPI manager] cancel];
    }
}

#pragma mark -----  跳转到选座界面
-(void)popToSeatsController{
    
    for (UIViewController * vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MovieSelectSeatViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc{
    [payTimer invalidate];
    payTimer = nil;
    [timer invalidate];
    timer   = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_STRING object:nil];
}

@end









