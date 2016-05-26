//
//  MCardPayViewController.m
//  推盟
//
//  Created by joinus on 16/3/23.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MCardPayViewController.h"
#import "MCardPayCell.h"
#import "MCardModel.h"
#import "UIAlertView+Blocks.h"
#import "MovieSelectSeatViewController.h"
#import "MOrderListController.h"


@interface MCardPayViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UISegmentedControl      * segmentControl;
    float                   keyboardHeight;
    NSTimer                 * timer;
    UILabel                 * timePromptLabel;
    UILabel                 * timeLabel;
    //卡支付金额
    float                    cardMoney;
    //是否接受多扣除兑换卡次数
    BOOL                    isAcceptOverflow;
    //判断是否显示添加新卡按钮
    int                     hiddenAddCoupon;
}

@property(nonatomic,strong)UITableView      * myTableView;

@property(nonatomic,strong)NSMutableArray   * dataArray;

@end

@implementation MCardPayViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCount:) name:NOTIFICATION_TIME_STRING object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_STRING object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewEndEditing:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text   = @"卡券支付";
    if (_cardInfoArray) {
        _dataArray  = _cardInfoArray;
    }else{
        _dataArray              = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"",nil],[NSMutableArray arrayWithObjects:@"",nil],[NSMutableArray arrayWithObjects:@"",nil], nil];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing:)];
    [self.view addGestureRecognizer:tap];
    
    [self createMainView];
    
    [self createSectionView];
    [self createFooterView];
    

}
#pragma mark ------- 创建主视图
-(void)createMainView{
    
    _myTableView                = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.delegate       = self;
    _myTableView.dataSource     = self;
    [self.view addSubview:_myTableView];
}

-(void)createSectionView{
    SView * headerView      = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    headerView.backgroundColor = GRAY_BACKGROUND_COLOR;
    
    SView * timeView            = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 50)];
    timeView.lineColor          = LINE_COLOR;
    timeView.isShowBottomLine   = YES;
    [headerView addSubview:timeView];
    
    timePromptLabel   = [ZTools createLabelWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 15)
                                                text:@"支付剩余时间"
                                           textColor:DEFAULT_GRAY_TEXT_COLOR
                                       textAlignment:NSTextAlignmentCenter
                                                font:12];
    [timeView addSubview:timePromptLabel];
    
    timeLabel         = [ZTools createLabelWithFrame:CGRectMake(15, timePromptLabel.bottom+2, DEVICE_WIDTH-30, 18)
                                                text:@""
                                           textColor:[UIColor blackColor]
                                       textAlignment:NSTextAlignmentCenter
                                                font:16];
    [timeView addSubview:timeLabel];
    
    SView * orderView           = [[SView alloc] initWithFrame:CGRectMake(0, timeView.bottom, DEVICE_WIDTH, 100)];
    orderView.backgroundColor   = [UIColor whiteColor];
    orderView.lineColor         = LINE_COLOR;
    orderView.isShowBottomLine  = YES;
    [headerView addSubview:orderView];
    
    UIImageView * imageView         = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 40, 40)];
    imageView.layer.masksToBounds   = YES;
    imageView.layer.cornerRadius    = imageView.width/2.0f;
    imageView.image                 = [UIImage imageNamed:@"Icon"];
    [orderView  addSubview:imageView];
    
    
    NSString * priceString = [NSString stringWithFormat:@"还需支付：￥%.1f",_needPayPrice];
    UILabel * priceLabel            = [ZTools createLabelWithFrame:CGRectMake(imageView.right+20, 27, DEVICE_WIDTH-imageView.right-20, 30)
                                                              text:@""
                                                         textColor:DEFAULT_RED_TEXT_COLOR
                                                     textAlignment:NSTextAlignmentLeft
                                                              font:20];
    priceLabel.attributedText = [ZTools labelTextFontWith:priceString Color:DEFAULT_BLACK_TEXT_COLOR Font:13 range:[priceString rangeOfString:@"还需支付："]];
    [orderView addSubview:priceLabel];
    
    UILabel * orderIdLabel = [ZTools createLabelWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom+3, priceLabel.width, 15)
                                                     text:[NSString stringWithFormat:@"订单编号：%@",_orderId]
                                                textColor:DEFAULT_BLACK_TEXT_COLOR
                                            textAlignment:NSTextAlignmentLeft
                                                     font:12];
    orderIdLabel.numberOfLines = 0;
    [orderIdLabel sizeToFit];
    [orderView addSubview:orderIdLabel];
    
    segmentControl                          = [[UISegmentedControl alloc] initWithItems:@[@"新影联储值卡",@"新影联计次卡",@"新影联兑换券"]];
    segmentControl.frame                    = CGRectMake(15, orderView.bottom+10, DEVICE_WIDTH-30, 35);
    segmentControl.tintColor                = DEFAULT_BACKGROUND_COLOR;
    segmentControl.selectedSegmentIndex     = 0;
    [segmentControl addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:segmentControl];
    
    _myTableView.tableHeaderView = headerView;
}

-(void)createFooterView{
    UIView * footerView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
    footerView.backgroundColor  = GRAY_BACKGROUND_COLOR;
    
    UIButton * payButton        = [ZTools createButtonWithFrame:CGRectMake(16, 40, DEVICE_WIDTH-32, 37) title:@"确认支付" image:nil];
    payButton.titleLabel.font   = [ZTools returnaFontWith:16];
    payButton.backgroundColor   = DEFAULT_ORANGE_TEXT_COLOR;
    [payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:payButton];
    
    _myTableView.tableFooterView = footerView;
}
-(void)timeCount:(NSNotification *)notification{
    
    _countDown = [notification.object intValue];
    
    [self timeDown];
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
#pragma mark_________________  提交订单
-(void)uploadOrderWithCardInfoString:(NSString *)cardInfo{
    
    [MobClick event:@"MovieBuyTickets_card"];
    
    [_payInfoDic setObject:@"3" forKey:@"pay_mode"];                            //支付方式（1：微信 2：支付宝)
    [_payInfoDic setObject:@"2" forKey:@"pay_type"];                            //支付类型（1：线上，通过第三方  2：线下，不经过第三方
    [_payInfoDic setObject:@"0" forKey:@"money"];                               //用户需要支付的金额
    [_payInfoDic setObject:@(cardMoney?cardMoney:0) forKey:@"pay_money2"];      //电影卡支付金额
    [_payInfoDic setObject:cardInfo?cardInfo:@"" forKey:@"nfa_ticket"];         //电影卡字符串信息
    [_payInfoDic setObject:[ZTools timechangeToDateline] forKey:@"order_data"]; //支付日期
    [_payInfoDic setObject:_sign forKey:@"sign"];                               //加密信息
    
    __weak typeof(self)wself = self;
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"订单提交中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:YES];
    [[ZAPI manager] sendMoviePost:MOVIE_PAY_ORDER_URL myParams:_payInfoDic success:^(id data) {
        [hud hide:YES];
        [[MovieNetWork sharedManager] endTimer];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = data[ERROR_CODE];
            if (status.intValue == 1) {
                UIAlertView * alertView = [UIAlertView showWithTitle:@"您已支付成功，正在获取取票码，如果15分钟之后未收到通知短信，请您拨打400-666-9696与客服联系" message:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
                }];
                [alertView show];
                
                MOrderListController * orderList = [[MOrderListController alloc] init];
                [wself.navigationController pushViewController:orderList animated:YES];
            }else{
                [[MovieNetWork sharedManager] releaseMovieSeatsWithOrderId:self.orderId];
                UIAlertView * alertView = [UIAlertView showWithTitle:data[ERROR_INFO] message:@"支付失败，您可以拨打400-666-9696与客服联系" cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    MOrderListController * orderList = [[MOrderListController alloc] init];
                    [wself.navigationController pushViewController:orderList animated:YES];
                }];
                [alertView show];
            }
        }
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"订单提交失败，请检查当前网络状况" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark    _____________  查询卡信息
-(void)loadCardInfoWithNum:(NSString *)num passward:(NSString *)pw isAdd:(BOOL)isAdd{
    
    if (isAdd) {
        [_dataArray[segmentControl.selectedSegmentIndex] addObject:@""];
        [_myTableView reloadData];
        return;
    }
    
    if (num.length == 0) {
        [ZTools showMBProgressWithText:@"请输入卡号" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    if (pw.length == 0) {
        [ZTools showMBProgressWithText:@"请输入密码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    

    for (id obj in _dataArray[segmentControl.selectedSegmentIndex]) {
        if (obj && [obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            if ([model.sequenceNo isEqualToString:num]) {
                 UIAlertView * alertView = [UIAlertView showWithTitle:@"该卡已存在，不能重复使用" message:@"" cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                }];
                [alertView show];
                
                return;
            }
        }
    }
    
    [self startLoading];
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendMoviePost:M_GET_CARD_INFO_URL myParams:@{@"cardNumber":num,@"cardNumberPass":pw} success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            
            NSString * status = data[MOVIE_ERROR_CODE];
            if (![status isEqualToString:@"SSYL0000"]) {
                [ZTools showMBProgressWithText:data[MOVIE_ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                return ;
            }
            
            MCardModel * model = [[MCardModel alloc] initWithDictionary:data];
            
            if (model.curval.intValue == 0) {
                [ZTools showMBProgressWithText:@"该卡可使用余额为0" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                return;
            }
            
            if ([model.parentType isEqualToString:@"储值卡"]) {
                segmentControl.selectedSegmentIndex = 0;
                [wself.dataArray[0] replaceObjectAtIndex:[wself.dataArray[0] count]-1 withObject:model];
            }else if ([model.parentType isEqualToString:@"电影券"]){
                [wself totalMoneyInCard];
                segmentControl.selectedSegmentIndex = 2;
                [wself.dataArray[2] replaceObjectAtIndex:[wself.dataArray[2] count]-1 withObject:model];
            }else if ([model.parentType isEqualToString:@"计次卡"]){
                segmentControl.selectedSegmentIndex = 1;
                [wself.dataArray[1] replaceObjectAtIndex:[wself.dataArray[1] count]-1 withObject:model];
            }
        }
        
        [wself.myTableView reloadData];
    } failure:^(NSError *error) {
        [wself endLoading];
    }];
}

-(void)removeWithIndex:(int)index{
    if ([_dataArray[segmentControl.selectedSegmentIndex] count] == 1) {
        [_dataArray[segmentControl.selectedSegmentIndex] replaceObjectAtIndex:index withObject:@""];
    }else if([_dataArray[segmentControl.selectedSegmentIndex] count] > 1){
        [_dataArray[segmentControl.selectedSegmentIndex] removeObjectAtIndex:index];
    }
    [self totalMoneyInCard];
    [_myTableView reloadData];
}

-(void)keyBoardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo      = [notification userInfo];
    NSValue *aValue             = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect         = [aValue CGRectValue];
    keyboardHeight              = keyboardRect.size.height;
}
-(void)keyBoardWillHidden:(NSNotification *)notification{
    
}
-(void)chooseCardWith:(MCarPaySelectedCardsBlock)block{
    cardBlock = block;
}


#pragma mark    --------  UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray[segmentControl.selectedSegmentIndex] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier    = @"identifier";
    MCardPayCell * cell             = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MCardPayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id model = _dataArray[segmentControl.selectedSegmentIndex][indexPath.section];
    
    [cell setInfomationWithCardModel:model WithType:(int)segmentControl.selectedSegmentIndex withPrice:_needPayPrice];
    cell.cardNumTextField.delegate  = self;
    cell.cardPWTextField.delegate   = self;
    
    __weak typeof(self)wself        = self;
    [cell setPayDoneBlock:^(NSString *num, NSString *pw,BOOL isAdd) {
        [wself loadCardInfoWithNum:num passward:pw isAdd:isAdd];
    } remove:^{
        [wself removeWithIndex:(int)indexPath.section];
    }];

    if ((indexPath.section < ([_dataArray[segmentControl.selectedSegmentIndex] count]-1) && segmentControl.selectedSegmentIndex == 2) || hiddenAddCoupon) {
        cell.doneButton.hidden = YES;
    }
    
    
    return cell;
}

#pragma mark    -----------  UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = _dataArray[segmentControl.selectedSegmentIndex][indexPath.section];
    float height = 140;
    if (model && [model isKindOfClass:[MCardModel class]]) {
        height += 30;
    }
    
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SView * sectionView             = [[SView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 35)];
    sectionView.backgroundColor     = RGBCOLOR(250, 47, 57);
    sectionView.lineColor           = RGBCOLOR(224, 224, 224);
    sectionView.isShowBottomLine    = YES;
    sectionView.isShowTopLine       = YES;
    int segmentIndex                = (int)segmentControl.selectedSegmentIndex;
    UILabel * label                 = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-100, sectionView.height) text:[NSString stringWithFormat:@"%@",segmentIndex==0?@"添加票卡":segmentIndex==1?@"添加计次卡":@"添加兑换券"] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:14];
    [sectionView addSubview:label];
    
    return sectionView;
}

#pragma mark -----  UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    CGRect frame = [textField.superview convertRect:textField.frame toView:self.view];
    if (textField.height + frame.origin.y + keyboardHeight > DEVICE_HEIGHT-64) {
        CGPoint offset = _myTableView.contentOffset;
        offset.y = offset.y + (frame.origin.y + frame.size.height + keyboardHeight + 64 + 40 - DEVICE_HEIGHT);
        [self.myTableView setContentOffset:offset animated:YES];
    }
    
    return YES;
}
#pragma mark -------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex ------  %ld",(long)buttonIndex);
    isAcceptOverflow = buttonIndex==1?YES:buttonIndex==2?NO:NO;
}

-(void)segmentControlChanged:(UISegmentedControl *)sender{
    [_myTableView reloadData];
}
#pragma mark -----  确认支付按钮
-(void)payButtonClicked:(UIButton *)button{
    NSMutableArray * cardArray = _dataArray[segmentControl.selectedSegmentIndex];
    id obj = cardArray[0];
    if (!obj || ![obj isKindOfClass:[MCardModel class]]) {
        [ZTools showMBProgressWithText:@"还未添加票卡" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }else{
        NSString * cardInfo = @"";
        if (segmentControl.selectedSegmentIndex == 0)//储值卡
        {
            cardInfo    = [self handleTicketCardWithArray:cardArray];
            [self judgePopWithCardInfo:cardInfo];
        }else if (segmentControl.selectedSegmentIndex == 2)//兑换券
        {
            [self judgeOverflowWithArray:cardArray];
        }else if (segmentControl.selectedSegmentIndex == 1)//计次卡
        {
            [self judgeMeterOverflowWithModel:cardArray[0]];
        }
    }
}

#pragma mark ----  判断提交订单信息还是返回在线支付
-(void)judgePopWithCardInfo:(NSString *)cardInfo{
    if (cardMoney >= _needPayPrice && cardMoney) {
        [self uploadOrderWithCardInfoString:cardInfo];
    }else if(cardMoney < _needPayPrice && cardMoney){
        
        __weak typeof(self)wself = self;
        UIAlertView * alertView = [UIAlertView showWithTitle:[NSString stringWithFormat:@"您还需支付%.1f元，剩余票款是否使用在线支付",_needPayPrice-cardMoney] message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"在线支付"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                if (cardBlock) {
                    cardBlock(cardMoney,cardInfo,wself.dataArray);
                }
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alertView show];
    }
}
#pragma mark ---------  处理储值卡
-(NSString *)handleTicketCardWithArray:(NSMutableArray *)array{
    
    id obj = array[0];
    if (obj && [obj isKindOfClass:[MCardModel class]]) {
        MCardModel * model = (MCardModel *)obj;
        
        if (_needPayPrice < model.curval.floatValue) {
            cardMoney = _needPayPrice;
        }else{
            cardMoney = model.curval.floatValue;
        }
        
        NSString * string = [NSString stringWithFormat:@"%@!%@!%.2f!%@",model.sequenceNo,model.secretNo,cardMoney,model.tickettypeid];
        
         return string;
    }else{
        return @"";
    }
}
#pragma mark ---------  处理计次卡信息
-(void)handleMeterCard:(MCardModel *)model{
    
    NSString * string = [NSString stringWithFormat:@"%@!%@!%d!%@",model.sequenceNo,model.secretNo,model.useCount,model.tickettypeid];
    cardMoney   = model.useCount*model.localval.floatValue;
    [self judgePopWithCardInfo:string];
}
//计算计次卡扣除次数
-(void)judgeMeterOverflowWithModel:(id)obj{
    
    if (obj && [obj isKindOfClass:[MCardModel class]]) {
        __weak typeof(self)wself = self;
        MCardModel * model = (MCardModel *)obj;
        
        //判断需要扣除的次数
        int count = _needPayPrice/model.localval.intValue;
        if (model.localval.intValue*model.curval.floatValue > _needPayPrice && model.localval.intValue*count != _needPayPrice) {
            count += 1;
            
            NSArray * titles = count>1?@[@"确认使用",[NSString stringWithFormat:@"使用%d次",count-1]]:@[@"确认使用"];
            
            UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示"
                                                         message:[NSString stringWithFormat:@"卡号为%@将扣除%d次共%.1f元，多扣除的%.1f元不退还",model.sequenceNo,count,count*model.localval.floatValue,count*model.localval.floatValue-_needPayPrice]
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:titles
                                                        tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                                            
                                                            if (buttonIndex == 1) {
                                                                model.useCount = count;
                                                            }else if (buttonIndex ==2){
                                                                model.useCount = count-1;
                                                            }else{
                                                                return ;
                                                            }
                                                            
                                                            [wself handleMeterCard:model];
                                                        }];
            
            [alertView show];
            return;
        }else{
            
           
            count = MIN(count, model.curval.intValue);
            
            UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示"
                                                         message:[NSString stringWithFormat:@"卡号为%@将扣除%d次共%.1f元",model.sequenceNo,count,count*model.localval.floatValue]
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@[@"确认"]
                                                        tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
                                                            if (buttonIndex == 1) {
                                                                model.useCount = count;
                                                                [wself handleMeterCard:model];
                                                            }
                
            }];
            
            [alertView show];
            
        }
    }
}
#pragma mark ---------  处理兑换券
-(void)handleCouponCardWithArray:(NSMutableArray *)array{
    cardMoney = 0;
    NSMutableArray * cardInfoArray = [NSMutableArray array];
    for (id obj in array) {
        if (obj && [obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            
            NSString * string = [NSString stringWithFormat:@"%@!%@!%@!%@",model.sequenceNo,model.secretNo,model.curval,model.tickettypeid];
            [cardInfoArray addObject:string];
            
            cardMoney += model.localval.floatValue;
            
        }
    }
    NSString * cardInfoString = [cardInfoArray componentsJoinedByString:@"xxx"];
    
    [self judgePopWithCardInfo:cardInfoString];
}

-(void)judgeOverflowWithArray:(NSMutableArray *)array{
    
    float temp_need_pay = _needPayPrice;
    //兑换券只能兑换一次
    for (id obj in array) {
        if (obj && [obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            
            if (model.localval.floatValue > temp_need_pay) {
                __weak typeof(self)wself = self;
                UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示"
                                                             message:[NSString stringWithFormat:@"卡号为%@将扣除%@元，多扣除的%.1f元不退还",model.sequenceNo,model.localval,model.localval.floatValue-temp_need_pay]
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@[@"确认使用",@"移除改卡"]
                                                            tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                                                
                                                                if (buttonIndex == 1) {
                                                                    [wself handleCouponCardWithArray:array];
                                                                }else if (buttonIndex ==2){
                                                                    [wself.dataArray[segmentControl.selectedSegmentIndex] removeObject:model];
                                                                    [wself.myTableView reloadData];
                                                                }else{
                                                                    return ;
                                                                }
                                                            }];
                [alertView show];
                return;
            }
            temp_need_pay -= model.localval.floatValue;
        }
    }
    
    
    [self handleCouponCardWithArray:array];
    
}


#pragma mark -------   计算所填卡总额,并判断是否需要再继续增加电影卡
-(void)totalMoneyInCard{
    
    NSArray * array = _dataArray[segmentControl.selectedSegmentIndex];
    float totalMoney = 0;
    for (id obj in array) {
        if ([obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            if (segmentControl.selectedSegmentIndex == 0)//储值卡
            {
                totalMoney += model.curval.floatValue;
            }else//兑换卡
            {
                totalMoney += model.curval.floatValue*model.localval.floatValue;
            }
        }
    }

    hiddenAddCoupon = _needPayPrice <= totalMoney?YES:NO;
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


@end
























