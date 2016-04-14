//
//  FindPWViewController.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "FindPWViewController.h"

@interface FindPWViewController (){
    NSTimer * timer;
    int time_count;
}

///手机号
@property (weak, nonatomic) IBOutlet UITextField *phone_tf;
///验证码
@property (weak, nonatomic) IBOutlet UITextField *verification_tf;
/**
 *  获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *verification_button;

///新密码
@property (weak, nonatomic) IBOutlet UITextField *password_tf;
/**
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *done_button;

///获取验证码
- (IBAction)getVerificationClicked:(id)sender;

@end

@implementation FindPWViewController

-(void)setTextFont{
    _phone_tf.font = [ZTools returnaFontWith:15];
    _verification_tf.font = [ZTools returnaFontWith:15];
    _password_tf.font = [ZTools returnaFontWith:15];
    _verification_button.titleLabel.font = [ZTools returnaFontWith:15];
    _done_button.titleLabel.font = [ZTools returnaFontWith:15];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"找回密码";
    
    self.done_button.layer.cornerRadius = 5;
    self.verification_button.layer.cornerRadius = 5;
    
    [self setTextFont];
}

-(void)selfDismiss{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark --------------获取验证码-----------------
- (IBAction)getVerificationClicked:(id)sender {
    if (_phone_tf.text.length != 11)
    {
        [ZTools showMBProgressWithText:@"请输入正确的手机号" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    [self addTimer];
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    
    NSDictionary * dic = @{@"user_mobile":_phone_tf.text};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:PASSWORD_YANZHENGMA_URL myParams:dic success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if ([status intValue] == 1)
            {
                [ZTools showMBProgressWithText:@"验证码已发送到您的手机上" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }else
            {
                [wself removeTimer];
                [ZTools showErrorWithStatus:status InView:wself.view isShow:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself removeTimer];
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"发送失败，请检查当前网络" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}



#pragma mark ---=-=-=   找回密码
- (IBAction)doneButtonClicked:(id)sender {
    if (_phone_tf.text.length == 0)
    {
        [ZTools showMBProgressWithText:@"请输入手机号码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (_verification_tf.text.length == 0)
    {
        [ZTools showMBProgressWithText:@"请输入验证码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (_password_tf.text.length == 0)
    {
        [ZTools showMBProgressWithText:@"请输入新密码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];

    
    NSDictionary * dic = @{@"user_mobile":_phone_tf.text,@"user_code":_verification_tf.text,@"user_pwd":_password_tf.text};
    
    __weak typeof(self)bself = self;
    [[ZAPI manager] sendPost:PASSWORD_MODIFY_URL myParams:dic success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            
            if ([status intValue] == 1) {
                [ZTools showMBProgressWithText:@"修改密码成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
                [bself performSelector:@selector(selfDismiss) withObject:nil afterDelay:1.6];
            }else
            {
                [ZTools showErrorWithStatus:status InView:self.view isShow:YES];
            }
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"修改失败，请检查当前网络" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
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


@end
