//
//  BindBankCardViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "BindBankCardViewController.h"

@interface BindBankCardViewController (){
    NSString * bankName_string;
    NSMutableArray * bank_name_array;
    BOOL isBank;
}

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

/**
 *  银行卡/支付宝 开户人姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *userName_tf;
/**
 *  银行名称
 */
@property (weak, nonatomic) IBOutlet UIButton *bankName_button;
/**
 *  银行卡号/支付宝账号
 */
@property (weak, nonatomic) IBOutlet UITextField *bankCard_tf;
/**
 *  再次输入银行卡号/支付宝账号
 */
@property (weak, nonatomic) IBOutlet UITextField *once_bankCard_tf;

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
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.myScrollView addGestureRecognizer:tap];
}
-(void)doTap:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
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
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"正在提交..." WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":[NSString stringWithFormat:@"%d",!isBank],@"user_id":[ZTools getUid],(isBank?BANK_CARD:ALIPAY_NUM):_bankCard_tf.text,(isBank?BANK_NAME:ALIPAY_NAME):_userName_tf.text}];
    if (isBank) {
        [dic setObject:bankName_string forKey:@"bank"];
    }
    
    __weak typeof(self)bself = self;
    [[ZAPI manager] sendPost:BIND_BANK_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue] == 1)
            {
                hud.labelText = @"绑定成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserInfomation" object:nil];
                [bself disappearWithPOP:@"1" afterDelay:1.5f];
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


@end







