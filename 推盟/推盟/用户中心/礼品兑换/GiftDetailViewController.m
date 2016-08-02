//
//  GiftDetailViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "GiftDetailViewController.h"
#import "AddressManangerViewController.h"

@interface GiftDetailViewController ()<UITextFieldDelegate,SAlertViewDelegate,UITextViewDelegate>{
    GiftListModel * info;
    
    STextField * phone_tf;
    STextField * again_phone_tf;
    
    float keyboard_height;
    
    SAlertView * alertView;
    
    //收货地址信息
    UILabel * userNameLabel;
    UILabel * addressLabel;
    
    //获取验证码按钮
    UIButton * _getVericationButton;
    //验证码
    UITextField * _vericationTF;
    //计时器
    NSTimer * timer;
    int time_count;
    //图形验证码输入框
    UITextField * _vericationImageCodeTF;
    //图形验证码
    UIImageView * _vericationCodeImageView;
    //重新获取图形验证码按钮
    UIButton * _reGetVericationCodeButton;
}

@property(nonatomic,strong) GiftListModel * detail_info;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

/**
 *  大图
 */
@property (weak, nonatomic) IBOutlet UIImageView *big_imageView;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *gift_name_label;
/**
 *  商品剩余数量
 */
@property (weak, nonatomic) IBOutlet UILabel *gift_num_label;
/**
 *  商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *gift_price_label;
/**
 *  商品有效日期
 */
@property (weak, nonatomic) IBOutlet UILabel *gift_date_label;
/**
 *  立即兑换
 */
@property (weak, nonatomic) IBOutlet UIButton *get_button;
/**
 *  详细说明标题
 */
@property (weak, nonatomic) IBOutlet UILabel *detail_title_label;
/**
 *  商品详情
 */
@property (weak, nonatomic) IBOutlet UILabel *detail_label;
/**
 *  兑换流程标题
 */
@property (weak, nonatomic) IBOutlet UILabel *progess_title_label;
/**
 *  兑换流程
 */
@property (weak, nonatomic) IBOutlet UILabel *progress_label;
/**
 *  注意事项标题
 */
@property (weak, nonatomic) IBOutlet UILabel *attention_title_label;
/**
 *  注意事项
 */
@property (weak, nonatomic) IBOutlet UILabel *attent_label;
@property (weak, nonatomic) IBOutlet UIImageView *important_imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progress_contraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attent_constraint;
//兑换流程约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progress_height_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detial_height_constraint;
//注意事项约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attention_height_constraint;

//头图高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *header_imageView_height_constraint;
//顶部视图框高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *header_view_height_constraint;

@end

@implementation GiftDetailViewController
-(void)awakeFromNib{
    
}

-(void)setTextFont{
    _gift_name_label.font = [ZTools returnaFontWith:15];
    _gift_num_label.font = [ZTools returnaFontWith:12];
    _gift_date_label.font = [ZTools returnaFontWith:11];
    _get_button.titleLabel.font = [ZTools returnaFontWith:18];
    _detail_label.font = [ZTools returnaFontWith:13];
    _progress_label.font = [ZTools returnaFontWith:13];
    _attent_label.font = [ZTools returnaFontWith:13];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (alertView && alertView.hidden) {
        alertView.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"礼品详情";
    
    [self loadGiftDetailData];
    [self setupConstraint];
    [self setTextFont];
}

-(void)setupConstraint{
    _headerView.layer.borderWidth = 0.5;
    _headerView.layer.borderColor = RGBCOLOR(167, 167, 167).CGColor;
    _get_button.layer.cornerRadius = 5;
    _detail_label.numberOfLines = 0;
    
    float big_image_view_width = DEVICE_WIDTH-30;
    
    _header_view_height_constraint.constant = _header_view_height_constraint.constant + big_image_view_width*2/3 - _header_imageView_height_constraint.constant;
    _header_imageView_height_constraint.constant = big_image_view_width*2/3;
    
    [_progress_label sizeToFit];
    _progress_height_constraint.constant = _progress_label.height;
    
    [_attent_label sizeToFit];
    _attention_height_constraint.constant = _attent_label.height;
}

-(void)setInfomation:(GiftListModel*)detail{
    
    [self setupConstraint];
    
    info = detail;
    
    [_big_imageView sd_setImageWithURL:[NSURL URLWithString:detail.gift_image_big] placeholderImage:[UIImage imageNamed:@"default_loading_small_image"]];
    _gift_name_label.text = detail.gift_name;
    _gift_num_label.text = [NSString stringWithFormat:@"(剩余数量：%@)",[ZTools replaceNullString:detail.shengyu_num WithReplaceString:@"0"]];
    _gift_date_label.text = [NSString stringWithFormat:@"有效期：%@至%@",detail.start_time,detail.end_time];
    
    CGSize detail_size = [ZTools stringHeightWithFont:_detail_label.font WithString:detail.gift_info WithWidth:_detail_label.width];
    _detial_height_constraint.constant = detail_size.height+10;
    _detail_label.text = detail.gift_info;
    
    NSString * price = [NSString stringWithFormat:@"兑换金额：%@积分",detail.price];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,price.length-5)];
    _gift_price_label.attributedText = str;
    
    
    CGSize detail_label_size = [ZTools stringHeightWithFont:_detail_label.font WithString:_detail_label.text WithWidth:_detail_label.width];
    
    float distance = detail_label_size.height - _detial_height_constraint.constant;
    if (distance > 0) {
        _progress_contraint.constant = detail_label_size.height - _detial_height_constraint.constant;
        _detial_height_constraint.constant = detail_label_size.height;
    }
    
    if (detail.type.intValue == 1)//充值卡
    {
        _gift_date_label.hidden = YES;
        _gift_num_label.hidden = YES;
    }else if (detail.type.intValue == 2)//电影票
    {
        
    }
    
    self.myScrollView.contentSize = CGSizeMake(0, _important_imageView.bottom + detail_size.height);
}
#pragma mark ----  网络请求
-(void)loadGiftDetailData{
    
    __weak typeof(self)wself = self;
    
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&gift_id=%@",GIFT_DETAIL_URL,_gift_id] success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            
            NSString * status = [data objectForKey:@"status"];
            if (status.intValue == 1) {
                wself.detail_info = [[GiftListModel alloc] initWithDictionary:[data objectForKey:@"detail"]];
                [wself setInfomation:wself.detail_info];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -----  获取验证码
-(void)getVericationCode:(UIButton*)button{
    /*图形验证码
    if (_vericationImageCodeTF.text.length == 0) {
        [ZTools showMBProgressWithText:@"请先输入图片中的验证码" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
        return;
    }
    */
    button.enabled = NO;
    button.backgroundColor = [UIColor lightGrayColor];
    time_count      = 120;
    timer           = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(timerDown)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    __WeakSelf__ wself = self;
    MBProgressHUD * loadHUD = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:NO];
    NSString * dateline = [ZTools timechangeToDateline];
    NSDictionary * dic = @{@"user_id":[ZTools getUid],
                           @"sign":[ZTools signWithDateLine:dateline],
                           @"signtime":dateline};
    [[ZAPI manager] sendPost:GET_APPLY_VERIFICATION_GIFT_URL myParams:dic success:^(id data) {
        [loadHUD hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                MBProgressHUD * hud = [ZTools showMBProgressWithText:[NSString stringWithFormat:@"已发送到%@",[ZTools getPhoneNum]] WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:NO];
                [hud hide:YES afterDelay:2.5f];
            }else{
                [wself reGetVericationCodeClicked:nil];
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
                [wself stopTimer];
            }
        }else{
            [wself stopTimer];
        }
        
    } failure:^(NSError *error) {
        [loadHUD hide:YES];
        [wself stopTimer];
    }];
}



#pragma mark -重新获取图形验证码
-(void)reGetVericationCodeClicked:(UIButton *)button{
    [_vericationCodeImageView sd_setImageWithURL:[NSURL URLWithString:T_VERICATION_CODE_IMAGE_URL([ZTools timechangeToDateline])] placeholderImage:[UIImage imageNamed:DEFAULT_VERIFY_LOADING_IMAGE]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
-(void)keyboardWillHidden:(NSNotification*)notification{
    if (alertView) {
        alertView.background_imageView.centerY = DEVICE_HEIGHT/2.0f;
    }
}

#pragma mark --------   管理收货地址
-(void)modifyAddressButtonTap:(UIButton *)button{
    alertView.hidden = YES;
    AddressManangerViewController * viewController = [[AddressManangerViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController save:^(UserAddressModel * model){
        alertView.hidden = NO;
        userNameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.put_man];
        addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@",model.user_city,model.user_area];
    }];
}

#pragma mark --------  立即兑换
- (IBAction)getButtonClicked:(id)sender {
    //判断积分够不够
    if (_detail_info) {
        if ([[ZTools getRestMoney] floatValue] < _detail_info.price.floatValue) {
            [ZTools showMBProgressWithText:@"积分不足,无法兑换" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
            return;
        }
    }
    
    UserAddressModel * addressModel = [ZTools getAddressModel];

    if (info.type.intValue == 4 && !addressModel) {
        [self modifyAddressButtonTap:nil];
        return;
    }
    
    alertView = [[SAlertView alloc] initWithTitle:@"确认兑换" WithContentView:nil WithCancelTitle:@"取消" WithDoneTitle:@"确认"];
    alertView.delegate = self;
    [alertView alertShow];
    
    UIView * content_view;
    
    if (info.type.intValue == 1 || info.type.intValue == 2 || info.type.intValue == 3)//话费充值，电影票兑换券，视频网站会员
    {
        alertView.title = @"兑换信息";
        
        content_view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, alertView.contentView.width,240)];
        
        //商品名称
        UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, content_view.width-20, 30)];
        title_label.text = info.gift_name;
        title_label.textAlignment = NSTextAlignmentLeft;
        title_label.font = [UIFont boldSystemFontOfSize:15];
        title_label.textColor = RGBCOLOR(57, 57, 57);
        
        //商品价格
        UILabel * price_label = [[UILabel alloc] initWithFrame:CGRectMake(10, title_label.bottom+10, content_view.width-20, 20)];
        price_label.text = [NSString stringWithFormat:@"兑换金额：%@积分",info.price];
        price_label.textAlignment = NSTextAlignmentLeft;
        price_label.textColor = RGBCOLOR(57, 57, 57);
        price_label.font = [ZTools returnaFontWith:14];
        
        //有效期
        NSString * date_string = [NSString stringWithFormat:@"兑换券有效期：%@至%@",info.start_time,info.end_time];
        CGSize date_size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:14] WithString:date_string WithWidth:content_view.width-20];
        UILabel * date_label = [[UILabel alloc] initWithFrame:CGRectMake(10, price_label.bottom+10, content_view.width-20, date_size.height)];
        date_label.text = [NSString stringWithFormat:@"兑换券有效期：%@至%@",info.start_time,info.end_time];
        date_label.textAlignment = NSTextAlignmentLeft;
        date_label.numberOfLines = 0;
        date_label.textColor = RGBCOLOR(57, 57, 57);
        date_label.font = [ZTools returnaFontWith:14];
        
        
        //提示信息
        NSString * introduction_string = @"注意：礼品将在一周内发放。";
        CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:12] WithString:introduction_string WithWidth:content_view.width-20];
        UILabel * introduction_label = [[UILabel alloc] initWithFrame:CGRectMake(10, date_label.bottom+20, content_view.width-20, size.height)];
        introduction_label.text = introduction_string;
        introduction_label.numberOfLines = 0;
        introduction_label.font = [ZTools returnaFontWith:12];
        introduction_label.textColor = DEFAULT_LINE_COLOR;
        
        
        content_view.height = introduction_label.bottom+10;
        
        [content_view addSubview:introduction_label];
        [content_view addSubview:price_label];
        [content_view addSubview:date_label];
        [content_view addSubview:title_label];
    }else if (info.type.intValue == 4)//实物兑换
    {
        alertView.title = @"确认兑换";
        
        content_view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, alertView.contentView.width,240)];
        
        //商品名称
        UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, content_view.width-20, 30)];
        title_label.text = info.gift_name;
        title_label.textAlignment = NSTextAlignmentLeft;
        title_label.font = [UIFont boldSystemFontOfSize:15];
        title_label.textColor = RGBCOLOR(57, 57, 57);
        
        //商品价格
        UILabel * price_label = [[UILabel alloc] initWithFrame:CGRectMake(10, title_label.bottom+10, content_view.width-20, 20)];
        price_label.text = [NSString stringWithFormat:@"兑换积分：%@积分",info.price];
        price_label.textAlignment = NSTextAlignmentLeft;
        price_label.textColor = DEFAULT_ORANGE_TEXT_COLOR;
        price_label.font = [ZTools returnaFontWith:14];
        
        
        UILabel * phoneNumLabel = [ZTools createLabelWithFrame:CGRectMake(content_view.width-110, price_label.bottom+10, 100, 20)
                                                          text:[ZTools getPhoneNum]
                                                     textColor:DEFAULT_BLACK_TEXT_COLOR
                                                 textAlignment:NSTextAlignmentRight
                                                          font:14];
        [content_view addSubview:phoneNumLabel];
        
        userNameLabel = [ZTools createLabelWithFrame:CGRectMake(10, price_label.bottom+10, phoneNumLabel.left-20, 20)
                                                          text:[NSString stringWithFormat:@"收货人：%@",addressModel.put_man]
                                                     textColor:DEFAULT_BLACK_TEXT_COLOR
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:14];
        [content_view addSubview:userNameLabel];
        
        addressLabel = [ZTools createLabelWithFrame:CGRectMake(10, userNameLabel.bottom+10, content_view.width-20, 20)
                                                         text:[NSString stringWithFormat:@"收货地址：%@%@",addressModel.user_city,addressModel.user_area]
                                                    textColor:DEFAULT_BLACK_TEXT_COLOR
                                                textAlignment:NSTextAlignmentLeft
                                                         font:13];
        addressLabel.numberOfLines = 0;
        [addressLabel sizeToFit];
        [content_view addSubview:addressLabel];
        
        
        UIButton * modifyAddressButton = [ZTools createButtonWithFrame:CGRectMake((content_view.width-100)/2.0f, addressLabel.bottom+10, 100, 30) title:@"修改收货地址" image:nil];
        modifyAddressButton.titleLabel.font = [ZTools returnaFontWith:13];
        [modifyAddressButton addTarget:self action:@selector(modifyAddressButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [content_view addSubview:modifyAddressButton];
        
        
        //提示信息
        NSString * introduction_string = @"注意：礼品将在一周内发放。";
        CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:12] WithString:introduction_string WithWidth:content_view.width-20];
        UILabel * introduction_label = [[UILabel alloc] initWithFrame:CGRectMake(10, modifyAddressButton.bottom+20, content_view.width-20, size.height)];
        introduction_label.text = introduction_string;
        introduction_label.numberOfLines = 0;
        introduction_label.font = [ZTools returnaFontWith:12];
        introduction_label.textColor = DEFAULT_LINE_COLOR;
        
        
        content_view.height = introduction_label.bottom+10;
        
        [content_view addSubview:introduction_label];
        [content_view addSubview:price_label];
        [content_view addSubview:title_label];
    }
    
    
    /*
    //图形验证码 输入框
    _vericationImageCodeTF = [ZTools createTextFieldWithFrame:CGRectMake(20, content_view.bottom-50, content_view.width-40, 30)
                                                                      font:12
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
    _reGetVericationCodeButton.frame = CGRectMake(_vericationCodeImageView.right+10, _vericationCodeImageView.bottom-30, 90, 30);
    [_reGetVericationCodeButton setTitle:@"看不清？换一张" forState:UIControlStateNormal];
    _reGetVericationCodeButton.titleLabel.font = [ZTools returnaFontWith:12];
    [_reGetVericationCodeButton setTitleColor:DEFAULT_BACKGROUND_COLOR forState:UIControlStateNormal];
    [_reGetVericationCodeButton addTarget:self action:@selector(reGetVericationCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:_reGetVericationCodeButton];
    */
    
    
    //短信验证码
    _getVericationButton = [ZTools createButtonWithFrame:CGRectMake(content_view.width-90,content_view.bottom-50, 70, 30)
                                                   title:@"获取验证码"
                                                   image:nil];
    _getVericationButton.titleLabel.font = [ZTools returnaFontWith:12];
    [_getVericationButton addTarget:self action:@selector(getVericationCode:) forControlEvents:UIControlEventTouchUpInside];
    [content_view addSubview:_getVericationButton];
    
    
    _vericationTF = [ZTools createTextFieldWithFrame:CGRectMake(20, _getVericationButton.top, _getVericationButton.left-30, 30)
                                                font:12
                                         placeHolder:@"请输入验证码"
                                     secureTextEntry:NO];
    _vericationTF.delegate      = self;
    _vericationTF.keyboardType  = UIKeyboardTypeNumberPad;
    [content_view addSubview:_vericationTF];
    content_view.height = _vericationTF.bottom+10;
    
    
    
    alertView.contentView = content_view;
}

#pragma mark ---------   SAlertViewDelegate
-(void)doneButtonClicked:(UIButton *)sender{
    
    if (_vericationTF.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入短信验证码" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
        return;
    }
    
    /*图形验证码
     if (_vericationImageCodeTF.text.length == 0) {
     [ZTools showMBProgressWithText:@"请输入图中的验证码" WihtType:MBProgressHUDModeText addToView:alertView.background_imageView isAutoHidden:YES];
     return;
     }
     */
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":info.type,@"user_id":[ZTools getUid],@"gift_id":info.id,@"code_num":_vericationTF.text}];
    
    if (info.type.intValue == 4)//实物兑换
    {
        
    }
    
    MBProgressHUD * loading = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeIndeterminate addToView:alertView.background_imageView isAutoHidden:NO];
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:GIFT_APPLY_URL myParams:dic success:^(id data) {
        [loading hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            
            NSString * status = [data objectForKey:ERROR_CODE];
            if (status.intValue == 1) {
                [alertView removeFromSuperview];
                [wself successForApply];
            }else{
                [wself reGetVericationCodeClicked:nil];
                [ZTools showMBProgressWithText:[data objectForKey:ERROR_INFO] WihtType:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself reGetVericationCodeClicked:nil];
        [loading hide:YES];
    }];
}

#pragma mark ----   兑换成功
-(void)successForApply{
    
    alertView = [[SAlertView alloc] initWithTitle:@"确认兑换" WithContentView:nil WithCancelTitle:@"确认" WithDoneTitle:@""];
    alertView.delegate = self;
    [alertView alertShow];

    UIView * content_view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, alertView.contentView.width,240)];
    
    //提示信息
    NSString * introduction_string = [NSString stringWithFormat:@"您的%@兑换成功，系统将在7个工作日内，经人工审核后，礼品将发放到您的兑换记录中，请注意查收。",info.gift_name];
    CGSize size = [ZTools stringHeightWithFont:[ZTools returnaFontWith:15] WithString:introduction_string WithWidth:content_view.width-20];
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, content_view.width-20, size.height)];
    title_label.textAlignment = NSTextAlignmentLeft;
    title_label.font = [ZTools returnaFontWith:15];
    title_label.textColor = RGBCOLOR(57, 57, 57);
    title_label.numberOfLines = 0;
    title_label.attributedText = [ZTools labelTextColorWith:introduction_string Color:RGBCOLOR(255, 149, 46) range:[introduction_string rangeOfString:info.gift_name]];
    
    content_view.height = title_label.bottom + 20;
    
    [content_view addSubview:title_label];
    
    alertView.contentView = content_view;
}

#pragma mark -------   创建UITextView
-(STextField*)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder{
    STextField * textField = [[STextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.font = [ZTools returnaFontWith:14];
    textField.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    textField.layer.cornerRadius = 5;
    textField.layer.borderWidth = 0.5;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    return textField;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
