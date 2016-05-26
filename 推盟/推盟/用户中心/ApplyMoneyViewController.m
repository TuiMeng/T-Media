//
//  ApplyMoneyViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//


#import "ApplyMoneyViewController.h"
#import "BindBankCardViewController.h"
#import "ApplyRecordModel.h"
#import "ApplyMoneyCell.h"

@interface ApplyMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,SAlertViewDelegate>
{
    //提现说明
    NSString * apply_introduction_string;
    
    SAlertView * alertView;
    
    float keyboard_height;
    
    UITextField * rest_money_tf;
    /**
     *  收款的银行卡类型（1：银行卡2：支付宝）
     */
    NSString * bank_type;
    //计时器
    NSTimer * timer;
    int time_count;
    //获取验证码按钮
    UIButton * _getVericationButton;
    //短信验证码输入框
    UITextField * _vericationTF;
    //图形验证码输入框
    UITextField * _vericationImageCodeTF;
    //图形验证码
    UIImageView * _vericationCodeImageView;
    //重新获取图形验证码按钮
    UIButton * _reGetVericationCodeButton;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UILabel *total_money_label;

@property(nonatomic,strong)NSMutableArray * data_array;
@property(nonatomic,strong)NSArray * title_array;

/**
 *  绑定银行卡信息
 */
@property (weak, nonatomic) IBOutlet UIView *bank_view;
/**
 *  绑定支付宝信息
 */
@property (weak, nonatomic) IBOutlet UIView *alipay_view;
/**
 *  是否绑定银行卡
 */
@property (weak, nonatomic) IBOutlet UILabel *bind_bank_card_label;
/**
 *  是否绑定支付宝
 */
@property (weak, nonatomic) IBOutlet UILabel *bind_alipay_label;
/**
 *  提现说明按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *apply_introducation_button;
/**
 *  立即提现按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *apply_button;

@property (strong, nonatomic) IBOutlet UILabel *bind_bank_text_label;

@property (strong, nonatomic) IBOutlet UILabel *bind_alipay_text_label;

@property (strong, nonatomic) IBOutlet UILabel *total_money_text_label;

@end

@implementation ApplyMoneyViewController
-(void)awakeFromNib{
    
    
}

-(void)setTextFont{
    _bind_bank_card_label.font = [ZTools returnaFontWith:15];
    _bind_alipay_label.font = [ZTools returnaFontWith:15];
    _apply_introducation_button.titleLabel.font = [ZTools returnaFontWith:15];
    _apply_button.titleLabel.font = [ZTools returnaFontWith:15];
    _total_money_label.font = [ZTools returnaFontWith:22];
    _bind_bank_text_label.font = [ZTools returnaFontWith:18];
    _bind_alipay_text_label.font = [ZTools returnaFontWith:18];
    _total_money_text_label.font = [ZTools returnaFontWith:15];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTextFont];
    
    _apply_introducation_button.layer.cornerRadius = 5;
    _apply_button.layer.cornerRadius = 5;
    
    self.title_label.text = @"申请提现";
    
    _data_array = [NSMutableArray array];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableHeaderView.height = 360;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 调cell对齐
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _title_array = @[@"申请日期",@"处理日期",@"金额",@"状态"];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [_bank_view addGestureRecognizer:tap];
    [_alipay_view addGestureRecognizer:tap1];
    
    
    _total_money_label.text = [ZTools getRestMoney];
    
    
    [self loadApplyListData];
}

-(void)setCardInfomation{
    if ([[ZTools getBankCard] length] > 0) {
        _bind_bank_card_label.text = @"已绑定";
        _bind_bank_card_label.textColor = DEFAULT_BACKGROUND_COLOR;
    }else{
        _bind_bank_card_label.text = @"未绑定";
        _bind_bank_card_label.textColor = DEFAULT_LINE_COLOR;
    }
    
    if ([[ZTools getAlipayNum] length] > 0) {
        _bind_alipay_label.text = @"已绑定";
        _bind_alipay_label.textColor = DEFAULT_BACKGROUND_COLOR;
    }else{
        _bind_alipay_label.text = @"未绑定";
        _bind_alipay_label.textColor = DEFAULT_LINE_COLOR;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self setCardInfomation];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark ------   监控键盘高度
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboard_height = keyboardRect.size.height;
}
-(void)keyboardWillHidden:(NSNotification *)notification{
    if (alertView) {
        alertView.background_imageView.centerY = DEVICE_HEIGHT/2.0f;
    }
}

#pragma mark -----  网络请求
-(void)loadApplyListData{
    __weak typeof(self)wself = self;
    NSLog(@"url ----  %@",[NSString stringWithFormat:@"%@&user_id=%@",APPLY_LIST_URL,[ZTools getUid]]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",APPLY_LIST_URL,[ZTools getUid]] success:^(id data) {
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[@"status"] intValue] == 1) {
                NSArray * array = [data objectForKey:@"apply_list"];
                for (NSDictionary * dic in array) {
                    ApplyRecordModel * model = [[ApplyRecordModel alloc] initWithDictionary:dic];
                    [wself.data_array addObject:model];
                }
                
                [wself.myTableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -重新获取图形验证码
-(void)reGetVericationCodeClicked:(UIButton *)button{
    [_vericationCodeImageView sd_setImageWithURL:[NSURL URLWithString:T_VERICATION_CODE_IMAGE_URL([ZTools timechangeToDateline])] placeholderImage:[UIImage imageNamed:DEFAULT_VERIFY_LOADING_IMAGE]];
}
#pragma mark -----   申请提现
-(void)applyRestMoney{
    /*
    int apply_num = [rest_money_tf.text intValue];
    if (apply_num!= 50) {
        [ZTools showMBProgressWithText:@"每次提现限额50元" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
        return;
    }
     */
    
    if (_vericationTF.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入短信验证码" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
        return;
    }
    
    if (_vericationImageCodeTF.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入图中的验证码" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
        return;
    }
    
    
    MBProgressHUD * load_hud = [ZTools showMBProgressWithText:@"申请中..." WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:NO];
    
    NSDictionary * dic = @{@"user_id":[ZTools getUid],
                           @"money":@"500",
                           @"type":bank_type,
                           @"verify":_vericationImageCodeTF.text,
                           @"code_num":_vericationTF.text};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:APPLY_MONEY_URL myParams:dic success:^(id data){
        [load_hud hide:YES];
        if (data  && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if ([status intValue] == 1) {
                [alertView removeFromSuperview];
                alertView = nil;
                [ZTools showMBProgressWithText:@"申请成功，等待后台审核" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }else{
                [wself reGetVericationCodeClicked:nil];
               [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
            }
        }
    }failure:^(NSError *error){
        [wself reGetVericationCodeClicked:nil];
        [load_hud hide:YES];
        [ZTools showMBProgressWithText:@"提现失败，请检查您当前网络状况" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
    }];
}

#pragma mark -----   获取验证码
-(void)getVericationCode:(UIButton*)button{
    
    if (_vericationImageCodeTF.text.length == 0) {
        [ZTools showMBProgressWithText:@"请先输入图片中的验证码" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
        return;
    }
    
    button.enabled = NO;
    button.backgroundColor = [UIColor lightGrayColor];
    time_count      = 60;
    timer           = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(timerDown)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    MBProgressHUD * loadHUD = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:NO];
    
    NSDictionary * dic = @{@"user_id":[ZTools getUid],
                           @"verify":_vericationImageCodeTF.text};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:GET_APPLY_VERIFICATION_CODE_URL myParams:dic success:^(id data) {
        [loadHUD hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                MBProgressHUD * hud = [ZTools showMBProgressWithText:[NSString stringWithFormat:@"已发送到%@",[ZTools getPhoneNum]] WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:NO];
                [hud hide:YES afterDelay:2.5f];
            }else{
                [wself reGetVericationCodeClicked:nil];
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
                [self stopTimer];
            }
        }else{
            [self stopTimer];
        }
        
    } failure:^(NSError *error) {
        [loadHUD hide:YES];
        [self stopTimer];
    }];
}

#pragma mark - 绑定银行卡/支付宝
-(void)doTap:(UITapGestureRecognizer*)sender{
    NSString * cardType = [NSString stringWithFormat:@"%d",(int)sender.view.tag-1000];
    [self performSegueWithIdentifier:@"showbindbankcardSegue" sender:cardType];
}

#pragma mark *************   UITableView Delegate   **************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    ApplyMoneyCell * cell = (ApplyMoneyCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ApplyMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setInfomationWith:_data_array[indexPath.row]];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40)];
    header.backgroundColor = [UIColor whiteColor];

    float width = 0;
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(width, 0,i<2?DEVICE_WIDTH*4*0.5/7.0f:DEVICE_WIDTH*3*0.5/7.0f, 40)];
        label.text = _title_array[i];
//        label.backgroundColor = RGBCOLOR(arc4random()%255, arc4random()%255, arc4random()%255);
        label.textAlignment = NSTextAlignmentCenter;
        [header addSubview:label];
        label.font = [ZTools returnaFontWith:15];
        width+=label.width;
    }
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark -----   创建提现说明视图
-(void)createApplyIntroductionView{
    SAlertView * apply_alertView = [[SAlertView alloc] initWithTitle:@"提现说明" WithContentView:nil WithCancelTitle:@"确认" WithDoneTitle:@""];
    [apply_alertView alertShow];
    
    UIView * content_view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, apply_alertView.contentView.width,240)];
    //提示信息
    CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:apply_introduction_string WithWidth:content_view.width-20];
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, content_view.width-20, size.height)];
    title_label.textAlignment = NSTextAlignmentLeft;
    title_label.font = [ZTools returnaFontWith:15];
    title_label.textColor = RGBCOLOR(57, 57, 57);
    title_label.numberOfLines = 0;
    title_label.text = apply_introduction_string;
    
    content_view.height = title_label.bottom + 20;
    [content_view addSubview:title_label];
    
    apply_alertView.contentView = content_view;
}

#pragma mark - 获取提现提现说明
- (IBAction)explainButtonTap:(id)sender {
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",APPLY_INTRODUCTION_URL,[ZTools getUid]] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if (status.intValue == 1) {
                apply_introduction_string = [[[data objectForKey:@"content"] objectAtIndex:0] objectForKey:@"apply_content"];
                [[NSUserDefaults standardUserDefaults] setObject:apply_introduction_string forKey:APPLY_INTRODUCTION_STRING];
            }else{
                apply_introduction_string = [[NSUserDefaults standardUserDefaults] objectForKey:APPLY_INTRODUCTION_STRING];
            }
            
            [self createApplyIntroductionView];
        }
    } failure:^(NSError *error) {
        apply_introduction_string = [[NSUserDefaults standardUserDefaults] objectForKey:APPLY_INTRODUCTION_STRING];
    }];
}

#pragma mark - 立即提现按钮
- (IBAction)getMoneyButtonTap:(id)sender {
    
    NSString * bank_card = [ZTools getBankCard];
    NSString * bank_name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"bank"];
    NSString * alipay_num = [ZTools getAlipayNum];
    
    if (bank_card.length != 0 && alipay_num.length != 0) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择收款账户" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@(%@)",bank_name,[bank_card substringFromIndex:bank_card.length-4]]];
        [actionSheet addButtonWithTitle:@"支付宝"];
        [actionSheet showInView:self.view];
    }else if (bank_card.length == 0 && alipay_num.length == 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有绑定任何收款账号,请先绑定收款账号" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        bank_type = bank_card.length==0?@"2":@"1";
        [self createApplyViewWithBankType:bank_card.length==0?@"支付宝":@"银行卡" BankNameAndNum:bank_card.length==0?alipay_num:[NSString stringWithFormat:@"%@(%@)",bank_name,[bank_card substringFromIndex:bank_card.length-4]]];
    }
}
#pragma mark --------  创建提现视图
-(void)createApplyViewWithBankType:(NSString*)type BankNameAndNum:(NSString*)num{
    
    alertView = [[SAlertView alloc] initWithTitle:@"申请提现" WithContentView:nil WithCancelTitle:@"取消" WithDoneTitle:@"确认"];
    alertView.delegate = self;
    [alertView alertShow];
    
    UIView * content_view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, alertView.contentView.width,270)];
    
    
    UILabel * _applyMoneyLabel = [ZTools createLabelWithFrame:CGRectMake(20, 10, content_view.width-40, 30)
                                                         text:@"当前申请提现50元，扣除对应500积分"
                                                    textColor:DEFAULT_RED_TEXT_COLOR
                                                textAlignment:NSTextAlignmentCenter
                                                         font:14];
    _applyMoneyLabel.numberOfLines = 0;
    [_applyMoneyLabel sizeToFit];
    _applyMoneyLabel.center = CGPointMake(content_view.width/2.0f, _applyMoneyLabel.center.y);
    [content_view addSubview:_applyMoneyLabel];
    
    
    /*
    UILabel * card_type_label = [self createLabelWithFrame:CGRectMake(20, _applyMoneyLabel.bottom+10, content_view.width-40, 35)
                                                      text:type
                                                 textColor:RGBCOLOR(49, 49, 49)
                                             textAlignment:NSTextAlignmentLeft
                                                      font:14
                                                haveBorder:NO];
    [content_view addSubview:card_type_label];
     */
    
    UILabel * card_label = [self createLabelWithFrame:CGRectMake(20,_applyMoneyLabel.bottom+10, content_view.width-40, 35)
                                                 text:[NSString stringWithFormat:@"%@:%@",type,num]
                                            textColor:RGBCOLOR(68, 120, 205)
                                        textAlignment:NSTextAlignmentCenter
                                                 font:14
                                           haveBorder:NO];
    [content_view addSubview:card_label];
    
    
    
    
    
    //图形验证码 输入框
    _vericationImageCodeTF = [ZTools createTextFieldWithFrame:CGRectMake(20, card_label.bottom+10, content_view.width-40, 30)
                                                         font:13
                                                  placeHolder:@"请输入下图中的字符，不区分大小写"
                                              secureTextEntry:NO];
    _vericationImageCodeTF.delegate = self;
    [content_view addSubview:_vericationImageCodeTF];
    //图形验证码图片
    _vericationCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_vericationImageCodeTF.left+25, _vericationImageCodeTF.bottom+15, [ZTools autoWidthWith:90], 30)];
    _vericationCodeImageView.layer.masksToBounds = YES;
    _vericationCodeImageView.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    _vericationCodeImageView.layer.borderWidth = 0.5;
    [self reGetVericationCodeClicked:nil];
    [content_view addSubview:_vericationCodeImageView];
    
    //重新获取图形验证码按钮
    _reGetVericationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reGetVericationCodeButton.frame = CGRectMake(_vericationCodeImageView.right+10, _vericationCodeImageView.bottom-30, 100, 30);
    [_reGetVericationCodeButton setTitle:@"看不清？换一张" forState:UIControlStateNormal];
    _reGetVericationCodeButton.titleLabel.font = [ZTools returnaFontWith:12];
    [_reGetVericationCodeButton setTitleColor:DEFAULT_BACKGROUND_COLOR forState:UIControlStateNormal];
    [_reGetVericationCodeButton addTarget:self action:@selector(reGetVericationCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:_reGetVericationCodeButton];
    
    
    
    
    //验证码
    _getVericationButton = [ZTools createButtonWithFrame:CGRectMake(content_view.width-90,_vericationCodeImageView.bottom+10, 70, 30)
                                                   title:@"获取验证码"
                                                   image:nil];
    _getVericationButton.titleLabel.font = [ZTools returnaFontWith:12];
    
    [_getVericationButton addTarget:self action:@selector(getVericationCode:) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:_getVericationButton];
    
    
    _vericationTF = [ZTools createTextFieldWithFrame:CGRectMake(20, _vericationCodeImageView.bottom+10, _getVericationButton.left-30, 30)
                                                font:13
                                         placeHolder:@"请输入验证码"
                                     secureTextEntry:NO];
    _vericationTF.delegate = self;
    _vericationTF.keyboardType = UIKeyboardTypeNumberPad;
    [content_view addSubview:_vericationTF];
    
    
    /*
    UILabel * money_back_label = [self createLabelWithFrame:CGRectMake(20, card_type_label.bottom + 20, content_view.width-40, 35) text:@"  金额(元)" textColor:RGBCOLOR(49, 49, 49) textAlignment:NSTextAlignmentLeft font:14 haveBorder:YES];
    money_back_label.userInteractionEnabled = YES;
    [content_view addSubview:money_back_label];
    
    rest_money_tf = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, money_back_label.width-80, 35)];
    rest_money_tf.textAlignment = NSTextAlignmentCenter;
    rest_money_tf.delegate = self;
    rest_money_tf.keyboardType = UIKeyboardTypeNumberPad;
    rest_money_tf.placeholder = [NSString stringWithFormat:@"当前账户积分%@",[ZTools getRestMoney]];
    rest_money_tf.font = [ZTools returnaFontWith:14];
    [money_back_label addSubview:rest_money_tf];
     */
    
    content_view.height = _vericationTF.bottom + 20;
    alertView.contentView = content_view;
    
}
#pragma mark -----   UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        [self startLoading];
        [self performSelector:@selector(showApplyView:) withObject:[NSString stringWithFormat:@"%ld",(long)buttonIndex] afterDelay:0.6];
    }
}

-(void)showApplyView:(id)sender{
    
    [self endLoading];
    
    NSString * type;
    NSString * num;
    if ([sender isEqualToString:@"1"]) {
        NSString * bank_card = [ZTools getBankCard];
        NSString * bank_name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"] objectForKey:@"bank"];
        type = @"  银行卡";
        bank_type = @"1";
        num = [NSString stringWithFormat:@"%@(%@)",bank_name,[bank_card substringFromIndex:bank_card.length-4]];
    }else if ([sender isEqualToString:@"2"]){
        type = @"  支付宝";
        bank_type = @"2";
        num = [ZTools getAlipayNum];
    }
    [self createApplyViewWithBankType:type BankNameAndNum:num];
}

#pragma mark -----  SAlertViewDelegate
-(void)doneButtonClicked:(UIButton*)sender{
    [self applyRestMoney];
    
}
#pragma mark -----  UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    CGRect rect = [alertView.contentView convertRect:textField.frame toView:alertView];
    if (rect.origin.y + textField.height + keyboard_height > DEVICE_HEIGHT) {
        
        alertView.background_imageView.top = alertView.background_imageView.top - (rect.origin.y - (DEVICE_HEIGHT - keyboard_height) + textField.height) - 30;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

#pragma mark ------  计时器
-(void)timerDown{
    if (time_count < 1) {
        [self stopTimer];
        return;
    }
    
    NSString * title = [NSString stringWithFormat:@"%d秒",time_count];
    [_getVericationButton setTitle:title forState:UIControlStateNormal];
    _getVericationButton.titleLabel.text = title;
    time_count--;
}
-(void)stopTimer{
    [timer invalidate];
    timer = nil;
    [_getVericationButton setTitle:@"重新获取" forState:UIControlStateNormal];
    _getVericationButton.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _getVericationButton.enabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(UILabel *)createLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       textColor:(UIColor*)color
                   textAlignment:(NSTextAlignment)textAlignment
                            font:(float)font haveBorder:(BOOL)have{
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.font = [ZTools returnaFontWith:font];
    
    if (have) {
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    }
    return label;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //
    
    if ([segue.identifier isEqualToString:@"showbindbankcardSegue"]) {
        BindBankCardViewController * vc = (BindBankCardViewController*)segue.destinationViewController;
        [vc setValue:sender forKey:@"card_type"];
    }
    
}


@end
