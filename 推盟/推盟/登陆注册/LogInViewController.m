//
//  LogInViewController.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "LogInViewController.h"
#import <MessageUI/MessageUI.h>
#import "WXUtil.h"

@interface LogInViewController ()<MFMessageComposeViewControllerDelegate>{
    int time_count;
    NSTimer * timer;
}

///手机号
@property (weak, nonatomic) IBOutlet STextField *phone_num_textField;
///密码
@property (weak, nonatomic) IBOutlet STextField *password_textField;
///登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *login_button;
/**
 *  验证码
 */
@property (strong, nonatomic) IBOutlet UIButton *verification_code_button;
/**
 *  图片验证码输入框
 */
@property (strong, nonatomic) IBOutlet STextField *verificationImageCodeTF;
/**
 *  图片验证码
 */
@property (strong, nonatomic) IBOutlet UIImageView *verificationImageView;
/**
 *  更换图片验证码按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *verificationChangeButton;
/**
 *  邀请码
 */
@property (strong, nonatomic) IBOutlet STextField *invitation_tf;
/**
 *  收不到验证码，手动发送短信
 */
@property(strong,nonatomic) UIButton * send_code_button;


///确认
- (IBAction)doneButton:(id)sender;
/**
 *  更换图形验证码
 */
- (IBAction)verificationExchange:(id)sender;



@end

@implementation LogInViewController

+ (LogInViewController *)sharedManager
{
    static LogInViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[[NSBundle mainBundle] loadNibNamed:@"LogInViewController" owner:nil options:nil] objectAtIndex:0];
    });
    return sharedAccountManagerInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"登 录";
//    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypePhoto WihtRightString:@"login_register_image"];
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"system_close_image"];
    [self setup];
}

-(void)setup{
    self.login_button.layer.cornerRadius = 5;
    self.phone_num_textField.indent = 50;
    
    self.phone_num_textField.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    self.password_textField.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    self.phone_num_textField.layer.borderWidth = 0.5;
    self.phone_num_textField.layer.cornerRadius = 5;
    self.password_textField.layer.borderWidth = 0.5;
    self.password_textField.layer.cornerRadius = 5;
    self.verificationImageCodeTF.layer.borderWidth = 0.5;
    self.verificationImageCodeTF.layer.cornerRadius = 5;
    self.verification_code_button.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    
    self.phone_num_textField.left_image = [UIImage imageNamed:@"logIn_phone_image"];
    
    self.invitation_tf.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    self.invitation_tf.layer.borderWidth = 0.5;
    self.invitation_tf.layer.cornerRadius = 5;
    self.verification_code_button.layer.cornerRadius = 5;
    self.verification_code_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;

    _phone_num_textField.font       = [ZTools returnaFontWith:15];
    _password_textField.font        = [ZTools returnaFontWith:15];
    _login_button.titleLabel.font   = [ZTools returnaFontWith:15];
    _verification_code_button.titleLabel.font = [ZTools returnaFontWith:13];
    _invitation_tf.font             = [ZTools returnaFontWith:15];
    _verificationChangeButton.titleLabel.font = [ZTools returnaFontWith:12];
    
    
    //收不到验证码？手动发送按钮
    _send_code_button = [ZTools createButtonWithFrame:CGRectMake(DEVICE_WIDTH-50-70, 7.5, 60, 25) title:@"没收到？" image:nil];
    _send_code_button.backgroundColor = RGBCOLOR(196, 196, 196);
    [_send_code_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _send_code_button.titleLabel.font = [ZTools returnaFontWith:12];
    [_send_code_button addTarget:self action:@selector(sendCodeButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [_password_textField addSubview:_send_code_button];
    
    
    [self verificationExchange:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark ----  登录
- (IBAction)doneButton:(id)sender {
    [self.view endEditing:YES];
    
    if (self.phone_num_textField.text.length != 11) {
        [ZTools showMBProgressWithText:@"请输入正确的手机号" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (self.password_textField.text.length == 0)
    {
        [ZTools showMBProgressWithText:@"请输入验证码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"登录中..." WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:NO];
    
    NSDictionary * aDic = @{@"user_mobile":self.phone_num_textField.text,
                            @"Code_num":self.password_textField.text,
                            @"invite_code":_invitation_tf.text.length?_invitation_tf.text:@"",
                            @"deviceToken":[ZTools getDeviceToken]};
    
    __weak typeof(self)wslef = self;
    [[ZAPI manager] sendPost:LOGIN_URL myParams:aDic success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue]==1)
            {
                [ZTools showMBProgressWithText:@"登录成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];

                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                [user setObject:[data objectForKey:@"user_id"] forKey:UID];
                [user setObject:self.phone_num_textField.text forKey:PHONE_NUMBER];
                [user setBool:YES forKey:LOGIN];
                [user setObject:[ZTools CutAreaString:[data objectForKey:@"mobile_area"]] forKey:PHONE_ADDRESS];
                [user setObject:[ZTools CutAreaString:[data objectForKey:@"ip_area"]] forKey:IP_ADRESS];
                //登录时间
                [user setObject:[ZTools timechangeToDateline] forKey:LOGIN_TIME];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"successLogin" object:nil userInfo:nil];
                [wslef dismissViewControllerAnimated:YES completion:^{
                    if (login_block) {
                        login_block(wslef.source_type);
                    }
                }];
            }else
            {
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wslef.view isAutoHidden:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"登录失败，请检查您当前网络" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }];
}
#pragma mark ------  更换图形验证码
- (IBAction)verificationExchange:(id)sender {
    
    [_verificationImageView sd_setImageWithURL:[NSURL URLWithString:T_VERICATION_CODE_IMAGE_URL([ZTools timechangeToDateline])] placeholderImage:[UIImage imageNamed:DEFAULT_VERIFY_LOADING_IMAGE]];
}

-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)rightButtonTap:(UIButton *)sender{
    [self performSegueWithIdentifier:@"showRegisterSegue" sender:nil];
}

- (IBAction)findPassWordClicked:(id)sender {
    [self performSegueWithIdentifier:@"findpwSegue" sender:nil];
}
#pragma mark ------  获取验证码
- (IBAction)VerificationButtonClicked:(id)sender {
    
    if (_phone_num_textField.text.length != 11)
    {
        [ZTools showMBProgressWithText:@"请输入正确的手机号" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    NSString * time = [ZTools timechangeToDateline];
    NSDictionary * dic = @{@"user_mobile":_phone_num_textField.text,
                           @"sendtime":time,
                           @"sign":[self buildSignWithDateLine:time]};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:LOGIN_VERIFICATION_CODE_URL myParams:dic success:^(id data) {
        [hud hide:YES];
        
        wself.verification_code_button.userInteractionEnabled = NO;
        wself.verification_code_button.backgroundColor = [UIColor lightGrayColor];
        [wself addTimer];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:ERROR_CODE];
            if ([status intValue] == 1)
            {
                [ZTools showMBProgressWithText:@"验证码已发送到您的手机上" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }else
            {
                [wself removeTimer];
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself removeTimer];
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"发送失败，请检查当前网络" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];

}

#pragma mark -----  增加计时器
-(void)addTimer{
    time_count = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)removeTimer{
    [timer invalidate];
    timer = nil;
    _verification_code_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [_verification_code_button setTitle:@"重新获取" forState:UIControlStateNormal];
    _verification_code_button.userInteractionEnabled = YES;
}

-(void)timeCount{
    if (time_count < 1) {
        [self removeTimer];
        return;
    }
    
    if (time_count <= 30) {
        
    }
    
    _verification_code_button.titleLabel.text = [NSString stringWithFormat:@"重新发送%ds",time_count];
    [_verification_code_button setTitle:[NSString stringWithFormat:@"重新发送%ds",time_count] forState:UIControlStateNormal];
    time_count--;
}
#pragma mark ----  手动发送验证码
-(void)sendCodeButtonTap:(UIButton*)sender{
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller     = [[MFMessageComposeViewController alloc] init];
        controller.recipients                           = @[@"18600755163"];
        controller.navigationBar.tintColor              = [UIColor redColor];
        controller.navigationItem.title                 = @"新信息";
        controller.body                                 = @"帅呆了";
        controller.messageComposeDelegate               = self;
        [self presentViewController:controller animated:YES completion:nil];
//        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"新信息"];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(NSString *)buildSignWithDateLine:(NSString *)dateline{
    if (dateline && dateline.length > 6) {
        dateline = [[dateline substringToIndex:dateline.length] substringFromIndex:dateline.length-6];
    }
    NSString * sign = [NSString stringWithFormat:@"%@%@%@",_phone_num_textField.text,dateline,@"tuimeng2016edf"];
    
    return [WXUtil md5:sign];
}

#pragma mark -----  短信代理回调
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultSent) {
        [ZTools showMBProgressWithText:@"短信发送成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }else if (result == MessageComposeResultCancelled){
        [ZTools showMBProgressWithText:@"短信发送取消" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }else if (result == MessageComposeResultFailed){
        [ZTools showMBProgressWithText:@"短信发送失败" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }
}

-(void)successLogin:(LoginSuccessBlock)block{
    login_block = block;
}

-(void)dealloc{
    
}


@end
