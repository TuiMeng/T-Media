//
//  BindBankCardViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "BindBankCardViewController.h"
#import "WXUtil.h"

@interface BindBankCardViewController (){
    NSString * bankName_string;
    NSMutableArray * bank_name_array;
    BOOL isBank;
    
    float keyboard_height;
}

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

/**
 *  银行卡/支付宝 开户人姓名
 */
@property (weak, nonatomic) IBOutlet STextField *userName_tf;
/**
 *  银行名称
 */
@property (weak, nonatomic) IBOutlet UIButton *bankName_button;
/**
 *  银行卡号/支付宝账号
 */
@property (weak, nonatomic) IBOutlet STextField *bankCard_tf;
/**
 *  再次输入银行卡号/支付宝账号
 */
@property (weak, nonatomic) IBOutlet STextField *once_bankCard_tf;
/**
 *  身份证号
 */
@property (strong, nonatomic) IBOutlet STextField *IdCardNum_tf;

@property (weak, nonatomic) IBOutlet UIButton *done_button;


@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;


/**
 *选取银行按钮
 */
- (IBAction)bankCardClicked:(id)sender;


//约束条件
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardTop_constraint;

@end

@implementation BindBankCardViewController

-(void)awakeFromNib{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"提交汇款信息";
    
    isBank = _card_type.intValue;
    
    if (!isBank) {
        _bankName_button.hidden = YES;
        _bankCardTop_constraint.constant = -40;
        _userName_tf.placeholder = @"姓名";
        _bankCard_tf.placeholder = @"请输入支付宝账号";
        _once_bankCard_tf.placeholder = @"再次输入支付宝账号";
    }
    
    [self setup];
}

-(void)setup{
    
    _userName_tf.delegate = self;
    _IdCardNum_tf.delegate = self;
    _bankCard_tf.delegate = self;
    _once_bankCard_tf.delegate = self;
    
    _done_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _done_button.layer.cornerRadius = 5;
    
    _bankName_button.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    _bankName_button.layer.borderWidth = 0.5;
    _bankName_button.layer.cornerRadius = 5;
    
    //改变字体
    _done_button.titleLabel.font = [ZTools returnaFontWith:15];
    _bankName_button.titleLabel.font = [ZTools returnaFontWith:15];
    _bankCard_tf.font = [ZTools returnaFontWith:15];
    _once_bankCard_tf.font = [ZTools returnaFontWith:15];
    _userName_tf.font = [ZTools returnaFontWith:15];
    
    
    NSDictionary * user_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfomationData"];
    if (!isBank)//支付宝信息
    {
        _userName_tf.text = [user_info objectForKey:ALIPAY_NAME];
        _bankCard_tf.text = [user_info objectForKey:ALIPAY_NUM];
        _once_bankCard_tf.text = [user_info objectForKey:ALIPAY_NUM];
    }else//银行卡信息
    {
        NSString * bank_name = [user_info objectForKey:BANK];
        if (bank_name.length !=0 && ![bank_name isKindOfClass:[NSNull class]]) {
            _userName_tf.text = [user_info objectForKey:BANK_NAME];
            [_bankName_button setTitle:[user_info objectForKey:BANK] forState:UIControlStateNormal];
            _bankCard_tf.text = [user_info objectForKey:BANK_CARD];
            _once_bankCard_tf.text = [user_info objectForKey:BANK_CARD];
        }
    }
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"BankList" ofType:@"plist"];
    bank_name_array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (bank_name_array.count > 0) {
        bankName_string = bank_name_array[0];
    }
    
    //判断是否绑定身份证，如果绑定不可修改
    if ([ZTools getIDNumber].length) {
        _userName_tf.text = [ZTools getRealUserName];
        _userName_tf.enabled = NO;
        _userName_tf.layer.borderColor = DEFAULT_GRAY_TEXT_COLOR.CGColor;
        _IdCardNum_tf.text = [ZTools getIDNumber];
        _IdCardNum_tf.enabled = NO;
        _IdCardNum_tf.layer.borderColor = DEFAULT_GRAY_TEXT_COLOR.CGColor;
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.myScrollView addGestureRecognizer:tap];
}
-(void)doTap:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
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
    
    if (_myScrollView.contentOffset.y + _myScrollView.height > _myScrollView.contentSize.height) {
        [_myScrollView setContentOffset:CGPointMake(0, _myScrollView.contentSize.height-_myScrollView.height) animated:YES];
    }
}


#pragma mark - ToolBar Methods -
//取消
- (IBAction)toolbarCancelTap:(id)sender {
    [self pickerViewShow:NO];
}
//确认
- (IBAction)toolbarDoneTap:(id)sender {
    [self pickerViewShow:NO];
    [_bankName_button setTitle:bankName_string forState:UIControlStateNormal];
}

#pragma mark ************* UIPickerView Method  *************
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return bank_name_array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [bank_name_array objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    bankName_string = [bank_name_array objectAtIndex:row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --- 🏦🏦🏦🏦🏦🏦 选取银行按钮   🏦🏦🏦🏦🏦🏦
- (IBAction)bankCardClicked:(id)sender {
    [self.view endEditing:YES];
    [self pickerViewShow:YES];
}


-(void)pickerViewShow:(BOOL)isShow{
    
    [UIView animateWithDuration:0.3f animations:^{
        _myToolBar.top = isShow?(DEVICE_HEIGHT-_myPickerView.height-_myToolBar.height-64):DEVICE_HEIGHT;
        _myPickerView.top = isShow?(DEVICE_HEIGHT-_myPickerView.height-64):DEVICE_HEIGHT;

    } completion:^(BOOL finished) {

    }];
}

#pragma mark -----  提交绑定信息
- (IBAction)doneButtonClicked:(id)sender {
    if (self.userName_tf.text.length == 0 || self.bankCard_tf.text.length == 0 || self.once_bankCard_tf.text.length == 0) {
        
        [ZTools showMBProgressWithText:@"请输入完整信息" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (isBank && self.bankName_button.titleLabel.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入完整信息" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (![self.bankCard_tf.text isEqualToString:self.once_bankCard_tf.text]) {
        [ZTools showMBProgressWithText:isBank?@"您输入的银行卡号不一致，请认真核对":@"您输入的支付宝账户不一致，请认真核对" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (isBank && [_bankName_button.titleLabel.text isEqualToString:@"开户行名称"]) {
        [ZTools showMBProgressWithText:@"请选择开户银行" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (_IdCardNum_tf.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入与姓名一致的身份证号码，绑定后不可更改" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"正在提交..." WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":[NSString stringWithFormat:@"%d",!isBank],@"user_id":[ZTools getUid],(isBank?BANK_CARD:ALIPAY_NUM):_bankCard_tf.text,(isBank?BANK_NAME:ALIPAY_NAME):_userName_tf.text}];
    if (isBank) {
        [dic setObject:bankName_string forKey:@"bank"];
    }
    
    //加密字符
    NSString * dataline = [ZTools timechangeToDateline];
    NSString * sign = [ZTools signWithDateLine:dataline];
    [dic setObject:sign forKey:@"sign"];
    [dic setObject:dataline forKey:@"signtime"];
    
    //告诉后台是绑定信息还是修改信息(绑定过身份证就是修改没绑定过就是绑定)
    if ([[ZTools getIDNumber] length] == 0) {
        [dic setObject:_IdCardNum_tf.text forKey:@"idnumber"];
        [dic setObject:_userName_tf.text forKey:@"user_namea"];
        
        [dic setObject:@"0" forKey:@"modify"];
    }else{
        [dic setObject:@"1" forKey:@"modify"];
    }
    
    __weak typeof(self)bself = self;
    [[ZAPI manager] sendPost:BIND_BANK_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue] == 1)
            {
                [hud hide:YES afterDelay:1.5];
                hud.labelText = @"绑定成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserInfomation" object:nil];
                [bself disappearWithPOP:YES afterDelay:1.5f];
            }else if([[data objectForKey:ERROR_CODE] intValue] == 2){
                [hud hide:YES];
                [[[UIAlertView alloc] initWithTitle:data[ERROR_INFO] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }else
            {
                [hud hide:YES];
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:bself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        hud.labelText = @"提交失败，请重试";
        [hud hide:YES afterDelay:1.5];
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGPoint point = [_contentView convertPoint:textField.center toView:self.view];
    
    if(point.y+textField.height + keyboard_height > DEVICE_HEIGHT-64)
    {
        _myScrollView.top = _myScrollView.top - (point.y+textField.height+keyboard_height-(DEVICE_HEIGHT-64));
    }

    return YES;
}


@end







