//
//  RegisterViewController.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "RegisterViewController.h"
#import "ProtocalViewController.h"

@interface RegisterViewController (){
    NSTimer * timer;
    int time_count;
}
///填写手机号
@property (weak, nonatomic) IBOutlet STextField *phone_num_tf;
///填写验证码
@property (weak, nonatomic) IBOutlet STextField *verification_tf;
///用户名
@property (weak, nonatomic) IBOutlet STextField *username_tf;
///输入验证码
@property (weak, nonatomic) IBOutlet STextField *invitationCode_tf;
///获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *verification_button;
//请输入密码
@property (weak, nonatomic) IBOutlet UITextField *password_tf;
///是否同意服务条款按钮
@property (weak, nonatomic) IBOutlet UIButton *protocol_button;
///服务条款说明
@property (weak, nonatomic) IBOutlet UILabel *protocol_label;
///获取验证码
- (IBAction)getVerificationClicked:(id)sender;
///是否同意服务条款
- (IBAction)agreeClicked:(id)sender;
/**
 *  免费注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *done_button;


@end

@implementation RegisterViewController

-(void)setTextFont{
    _phone_num_tf.font = [ZTools returnaFontWith:15];
    _verification_tf.font = [ZTools returnaFontWith:15];
    _username_tf.font = [ZTools returnaFontWith:15];
    _invitationCode_tf.font = [ZTools returnaFontWith:15];
    _verification_button.titleLabel.font = [ZTools returnaFontWith:15];
    _password_tf.font = [ZTools returnaFontWith:15];
    _protocol_button.titleLabel.font = [ZTools returnaFontWith:15];
    _protocol_label.font = [ZTools returnaFontWith:13];
    _done_button.titleLabel.font = [ZTools returnaFontWith:15];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"注 册";
    
    self.done_button.layer.cornerRadius = 5;
    self.verification_button.layer.cornerRadius = 5;
    self.protocol_label.adjustsFontSizeToFitWidth = YES;
    
    [self setTextFont];
    
    NSString * string = [NSString stringWithFormat:@"确认并同意“%@软件使用许可及服务协议”",APP_NAME];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:string];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, string.length)];
    _protocol_label.attributedText = content;
    
    
    [_protocol_button setImage:[UIImage imageNamed:@"login_agree_image"] forState:UIControlStateNormal];
    [_protocol_button setImage:[UIImage imageNamed:@"login_unagree_image"] forState:UIControlStateSelected];
    
    _protocol_label.userInteractionEnabled = YES;
    UITapGestureRecognizer * show_protocol_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProtocolTap:)];
    [_protocol_label addGestureRecognizer:show_protocol_tap];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.view addGestureRecognizer:tap];
}
-(void)doTap:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
}

-(void)showProtocolTap:(UITapGestureRecognizer*)sender{
    ProtocalViewController * vc = [[ProtocalViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];
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
#pragma mark ------------获取验证码-------------
- (IBAction)getVerificationClicked:(id)sender {
    if (self.phone_num_tf.text.length != 11)
    {
        [ZTools showMBProgressWithText:@"请输入正确的手机号码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    [self startLoading];
    __weak typeof(self)wself = self;
    NSDictionary * dic = @{@"user_mobile":_phone_num_tf.text};
    [[ZAPI manager] sendPost:GET_REGISTER_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if ([status intValue] == 1)
            {
                [wself addTimer];
                [ZTools showMBProgressWithText:@"验证码已发送到您的手机上" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }else
            {
                [wself removeTimer];
                NSString * errorinfo = [data objectForKey:@"errorinfo"];
                if (errorinfo.length) {
                    [ZTools showMBProgressWithText:[data objectForKey:@"errorinfo"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                }else{
                    [ZTools showErrorWithStatus:status InView:wself.view isShow:YES];
                }
            }
        }
    } failure:^(NSError *error) {
        [wself endLoading];
        [wself removeTimer];
        [ZTools showMBProgressWithText:@"发送失败，请检查当前网络" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

#pragma mark -----  增加计时器
-(void)addTimer{
    _verification_button.userInteractionEnabled = NO;
    _verification_button.backgroundColor = [UIColor lightGrayColor];
    time_count = 120;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)removeTimer{
    [timer invalidate];
    timer = nil;
    _verification_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [_verification_button setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verification_button.userInteractionEnabled = YES;
}

-(void)timeCount{
    
    if (time_count < 1) {
        [self removeTimer];
        return;
    }
    
    _verification_button.titleLabel.text = [NSString stringWithFormat:@"重新发送%ds",time_count];
    [_verification_button setTitle:[NSString stringWithFormat:@"重新发送%ds",time_count] forState:UIControlStateNormal];
    time_count--;
}

- (IBAction)agreeClicked:(id)sender {
    _protocol_button.selected = !_protocol_button.selected;
    _done_button.userInteractionEnabled = !_protocol_button.selected;
    _done_button.backgroundColor = _protocol_button.selected?[UIColor lightGrayColor]:DEFAULT_BACKGROUND_COLOR;
}
#pragma mark --------- 验证验证码是否正确并且注册
- (IBAction)doneButtonClicked:(id)sender {
    if (_phone_num_tf.text.length != 11) {
        
        [ZTools showMBProgressWithText:@"请输入正确的手机号码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    if (_username_tf.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入昵称" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (_password_tf.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入密码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (_verification_tf.text.length == 0)
    {
        [ZTools showMBProgressWithText:@"请输入验证码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    MBProgressHUD *loading = [ZTools showMBProgressWithText:@"正在验证..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    
    NSDictionary * dic;
    if (_invitationCode_tf.text.length > 0) {
        dic = @{@"user_mobile":_phone_num_tf.text,@"user_code":_verification_tf.text,@"user_name":_username_tf.text,@"user_pwd":_password_tf.text,@"invite_code":_invitationCode_tf.text};
    }else{
        dic = @{@"user_mobile":_phone_num_tf.text,@"user_code":_verification_tf.text,@"user_name":_username_tf.text,@"user_pwd":_password_tf.text};
    }
    
    
    [[ZAPI manager] sendPost:ZHUCE_URL myParams:dic success:^(id data) {
        [loading hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if ([status intValue] == 1) {
                [ZTools showMBProgressWithText:@"注册成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
                [self disappearWithPOP:YES afterDelay:1.5];
            }else
            {
                [ZTools showErrorWithStatus:status InView:self.view isShow:YES];
            }
        }
    } failure:^(NSError *error) {
        [ZTools showMBProgressWithText:@"验证失败，请检查您当前网络" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }];

}


@end
