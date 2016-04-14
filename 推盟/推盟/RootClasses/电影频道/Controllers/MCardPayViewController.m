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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        _dataArray              = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"",nil],[NSMutableArray arrayWithObjects:@"",nil], nil];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing:)];
    [self.view addGestureRecognizer:tap];
    
    [self createMainView];
    
    [self createSectionView];
    [self createFooterView];
    

}

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
    
    timePromptLabel   = [ZTools createLabelWithFrame:CGRectMake(0, 10, DEVICE_WIDTH, 15) text:@"支付剩余时间" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentCenter font:12];
    [timeView addSubview:timePromptLabel];
    
    timeLabel         = [ZTools createLabelWithFrame:CGRectMake(15, timePromptLabel.bottom+2, DEVICE_WIDTH-30, 18) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:16];
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
    UILabel * priceLabel            = [ZTools createLabelWithFrame:CGRectMake(imageView.right+20, 27, DEVICE_WIDTH-imageView.right-20, 30) text:@"" textColor:DEFAULT_RED_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:20];
    priceLabel.attributedText = [ZTools labelTextFontWith:priceString Color:DEFAULT_BLACK_TEXT_COLOR Font:13 range:[priceString rangeOfString:@"还需支付："]];
    [orderView addSubview:priceLabel];
    
    UILabel * orderIdLabel = [ZTools createLabelWithFrame:CGRectMake(priceLabel.left, priceLabel.bottom+3, priceLabel.width, 15) text:[NSString stringWithFormat:@"推盟电影频道-订单编号：%@",_orderId] textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
    [orderView addSubview:orderIdLabel];
    
    segmentControl                          = [[UISegmentedControl alloc] initWithItems:@[@"新影联票卡支付",@"新影联电影兑换券"]];
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
    }
}
#pragma mark_________________  提交订单
-(void)uploadOrderWithCardInfoString:(NSString *)cardInfo{
    [_payInfoDic setObject:@"3" forKey:@"pay_mode"];                            //支付方式（1：微信 2：支付宝)
    [_payInfoDic setObject:@"2" forKey:@"pay_type"];                            //支付类型（1：线上，通过第三方  2：线下，不经过第三方
    [_payInfoDic setObject:@"0" forKey:@"money"];                               //用户需要支付的金额
    [_payInfoDic setObject:@(cardMoney?cardMoney:0) forKey:@"pay_money2"];      //电影卡支付金额
    [_payInfoDic setObject:cardInfo?cardInfo:@"" forKey:@"nfa_ticket"];         //电影卡字符串信息
    [_payInfoDic setObject:[ZTools timechangeToDateline] forKey:@"order_data"]; //支付日期
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendMoviePost:MOVIE_PAY_ORDER_URL myParams:_payInfoDic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = data[ERROR_CODE];
            if (status.intValue == 1) {
                UIAlertView * alertView = [UIAlertView showWithTitle:@"您已支付成功，正在获取取票码，如果15分钟之后未收到通知短信，请您拨打400-666-9696与客服联系" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                }];
                [alertView show];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [wself endLoading];
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
    
    [self startLoading];
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendMoviePost:M_GET_CARD_INFO_URL myParams:@{@"cardNumber":num,@"cardNumberPass":pw} success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            
            NSString * status = data[@"result"];
            if (status.intValue == 2) {
                [ZTools showMBProgressWithText:data[@"message"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                return ;
            }
            
            MCardModel * model = [[MCardModel alloc] initWithDictionary:data];
            
            if ([model.parentType isEqualToString:@"储值卡"]) {
                segmentControl.selectedSegmentIndex = 0;
                [wself.dataArray[0] replaceObjectAtIndex:[wself.dataArray[0] count]-1 withObject:model];
            }else if ([model.parentType isEqualToString:@"电影券"]){
                segmentControl.selectedSegmentIndex = 1;
                [wself.dataArray[1] replaceObjectAtIndex:[wself.dataArray[1] count]-1 withObject:model];
            }
        }
        [_myTableView reloadData];
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
    
    UILabel * label                 = [ZTools createLabelWithFrame:CGRectMake(15, 0, DEVICE_WIDTH-100, sectionView.height) text:[NSString stringWithFormat:@"%@",segmentControl.selectedSegmentIndex==0?@"添加票卡":@"添加兑换券"] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:14];
    [sectionView addSubview:label];
    
    return sectionView;
}

#pragma mark -----  UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:_myTableView];
    if (point.y > DEVICE_HEIGHT-keyboardHeight-64) {
        float navBarHeight = self.navigationController.navigationBar.frame.size.height;
        CGPoint offset = _myTableView.contentOffset;
        // Adjust the below value as you need
        offset.y = (point.y - navBarHeight-40);
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

-(void)payButtonClicked:(UIButton *)button{
    NSMutableArray * cardArray = _dataArray[segmentControl.selectedSegmentIndex];
    id obj = cardArray[0];
    if (!obj || ![obj isKindOfClass:[MCardModel class]]) {
        [ZTools showMBProgressWithText:@"还未添加票卡" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }else{
        NSString * cardInfo = @"";
        if (segmentControl.selectedSegmentIndex == 0) {
            cardInfo    = [self handleTicketCardWithArray:cardArray];
            [self judgePopWithCardInfo:cardInfo];
        }else if (segmentControl.selectedSegmentIndex == 1){
            [self judgeOverflowWithArray:cardArray];
        }
        
    }
}

#pragma mark ----  判断提交订单信息还是返回在线支付
-(void)judgePopWithCardInfo:(NSString *)cardInfo{
    if (cardMoney >= _needPayPrice && cardMoney) {
        [self uploadOrderWithCardInfoString:cardInfo];
    }else if(cardMoney < _needPayPrice && cardMoney){
        if (cardBlock) {
            cardBlock(cardMoney,cardInfo,_dataArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//处理储值卡
-(NSString *)handleTicketCardWithArray:(NSMutableArray *)array{
    float TempMoney = 0;
    NSMutableArray * cardInfoArray = [NSMutableArray array];
    for (id obj in array) {
        if (obj && [obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            TempMoney += model.curval.floatValue;
            NSString * string;
            if (_needPayPrice-TempMoney > 0) {
                string = [NSString stringWithFormat:@"%@!%@!%@!%@",model.sequenceNo,model.orderNo,[NSString stringWithFormat:@"%f",_needPayPrice-TempMoney],model.parentType];
            }else{
                string = [NSString stringWithFormat:@"%@!%@!%@!%@",model.sequenceNo,model.orderNo,model.curval,model.parentType];
            }
            
            [cardInfoArray addObject:string];
        }
    }
    
    if (TempMoney < _needPayPrice) {
        cardMoney = TempMoney;
    }else{
        cardMoney = _needPayPrice;
    }
    
    NSString * cardInfoString = [cardInfoArray componentsJoinedByString:@"xxx"];
    
    return cardInfoString;
}
//处理兑换券
-(void)handleCouponCardWithArray:(NSMutableArray *)array{
    float TempMoney = 0;
    NSMutableArray * cardInfoArray = [NSMutableArray array];
    for (id obj in array) {
        if (obj && [obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            
            float totalMoney    = model.curval.floatValue*model.localval.floatValue;
            if (totalMoney > _needPayPrice - TempMoney)//如果改卡的总额大于需要支付的金额，计算扣除次数
            {
                //判断需要扣除的次数
                int count = (_needPayPrice-TempMoney)/model.localval.intValue;
                
                if (model.localval.intValue*model.curval.floatValue > (_needPayPrice-TempMoney) && isAcceptOverflow) {
                    count += 1;
                }
                
                if (count != 0) {
                    TempMoney = _needPayPrice;
                    NSString * string = [NSString stringWithFormat:@"%@!%@!%@!%@",model.sequenceNo,model.secretNo,@(count),model.parentType];
                    [cardInfoArray addObject:string];
                }
            }else
            {
                TempMoney += totalMoney;
                NSString * string = [NSString stringWithFormat:@"%@!%@!%@!%@",model.sequenceNo,model.secretNo,model.curval,model.parentType];
                [cardInfoArray addObject:string];
            }
        }
    }
    
    cardMoney = TempMoney;
    
    NSString * cardInfoString = [cardInfoArray componentsJoinedByString:@"xxx"];
    
    [self judgePopWithCardInfo:cardInfoString];
}

-(void)judgeOverflowWithArray:(NSMutableArray *)array{
    float TempMoney = 0;
    for (id obj in array) {
        if (obj && [obj isKindOfClass:[MCardModel class]]) {
            MCardModel * model = (MCardModel *)obj;
            float totalMoney    = model.curval.floatValue*model.localval.floatValue;
            if (totalMoney > _needPayPrice - TempMoney)//如果改卡的总额大于需要支付的金额，计算扣除次数
            {
                //判断需要扣除的次数
                int count = (_needPayPrice-TempMoney)/model.localval.intValue;
                if (model.localval.intValue*model.curval.floatValue > (_needPayPrice-TempMoney)) {
                    count += 1;
                    
                    NSArray * titles = count>1?@[@"确认使用",[NSString stringWithFormat:@"使用%d次",count-1]]:@[@"确认使用"];
                    
                    UIAlertView * alertView = [UIAlertView showWithTitle:@"温馨提示"
                                                                 message:[NSString stringWithFormat:@"该卡将扣除%d次，多余的金额不退",count]
                                                       cancelButtonTitle:@"取消"
                                                       otherButtonTitles:titles
                                                                tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                                                    
                                                                    if (buttonIndex == 1) {
                                                                        isAcceptOverflow = YES;
                                                                    }else if (buttonIndex ==2){
                                                                        isAcceptOverflow = NO;
                                                                    }
                                                                    [self handleCouponCardWithArray:array];
                        }];
                    
                    [alertView show];
                }
            }else{
                [self handleCouponCardWithArray:array];
            }
        }
    }
}


@end
























