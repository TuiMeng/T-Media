//
//  LogInView.m
//  推盟
//
//  Created by joinus on 16/5/18.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "LogInView.h"
#import "WXUtil.h"
#define INDENT 25

@interface LogInView ()<UITextFieldDelegate>{
    float   keyboard_height;
    int     time_count;
    NSTimer * timer;
    
}

//背景视图
@property(nonatomic,strong)UIView       * contentView;
//标题
@property(nonatomic,strong)UILabel      * titleLabel;
//手机号码
@property(nonatomic,strong)UITextField  * phoneTF;
//下一步按钮
@property(nonatomic,strong)UIButton     * firstNextButon;
//关闭按钮
@property(nonatomic,strong)UIButton     * closeButton;

//验证码输入框
@property(nonatomic,strong)UITextField  * verificationCodeTF;
//确认按钮
@property(nonatomic,strong)UIButton     * secondNextButton;
//返回按钮
@property(nonatomic,strong)UIButton     * backButton;
//发送验证码按钮
@property(nonatomic,strong)UIButton     * sendButton;


//邀请码输入框
@property(nonatomic,strong)UITextField  * invitationCodeTF;
//跳过按钮
@property(nonatomic,strong)UIButton     * skipButton;
//确认按钮
@property(nonatomic,strong)UIButton     * doneButton;
//当前显示的第几页
@property(nonatomic,assign)int          currentPage;



@end

@implementation LogInView


+(instancetype)sharedInstance{
    /*
    static dispatch_once_t onceToken;
    static LogInView * sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LogInView alloc] init];
    });
    return sharedInstance;
     */
    return [[[self class] alloc] init];
}

-(void)loginShowWithSuccess:(LoginViewSuccessBlock)success{
    
    successBlock = success;
    
    self.currentPage = 1;
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    self.window.windowLevel = UIWindowLevelAlert;
    UIImage * screenShotImage = [ZTools screenShotVague];
    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image = screenShotImage;
    [self addSubview:backgroundImageView];
    
    [keyWindow addSubview:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [self setContentView];
}

#pragma mark -----  创建输入手机号视图
-(void)setContentView{
    
    if (!self.contentView) {
        self.contentView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH-50, 170)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.center          = self.center;
        self.contentView.clipsToBounds   = YES;
        self.contentView.layer.cornerRadius = 5;
    }
    
    
    
    if (!self.titleLabel) {
        self.titleLabel = [ZTools createLabelWithFrame:CGRectMake(40, 5, self.contentView.width-80, 30)
                                                  text:@"登录"
                                             textColor:DEFAULT_BLACK_TEXT_COLOR
                                         textAlignment:NSTextAlignmentCenter
                                                  font:16];
    }
    
    if (!self.closeButton) {
        self.closeButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame       = CGRectMake(self.contentView.width-40, 0, 40, 40);
        [self.closeButton setImage:[UIImage imageNamed:@"login_close_image"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if (!self.phoneTF) {
        self.phoneTF = [self createTextFieldWithFrame:CGRectMake(INDENT, 60, self.contentView.width-INDENT*2, 30) placeHolder:@"请输入手机号"];
        [self.phoneTF becomeFirstResponder];
    }
    
    if (!self.firstNextButon) {
        self.firstNextButon = [ZTools createButtonWithFrame:CGRectMake(INDENT, self.contentView.height-INDENT*2, self.contentView.width-50, 30) title:@"下一步" image:nil];
        [self.firstNextButon addTarget:self action:@selector(goToSecondView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.phoneTF];
    [self.contentView addSubview:self.firstNextButon];
}

-(void)setVerificationView{
    if (!self.sendButton) {
        self.sendButton = [ZTools createButtonWithFrame:CGRectMake(self.contentView.width-80-INDENT, 40, 80, 30) title:@"60秒后重发" image:nil];
        self.sendButton.enabled = NO;
        self.sendButton.titleLabel.font = [ZTools returnaFontWith:10];
        [self.sendButton addTarget:self action:@selector(reGetVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.verificationCodeTF) {
        self.verificationCodeTF = [self createTextFieldWithFrame:CGRectMake(INDENT, self.sendButton.bottom+15, self.contentView.width-INDENT*2, 30) placeHolder:@"请输入验证码"];
        self.verificationCodeTF.delegate = self;
    }
    
    if (!self.secondNextButton) {
        self.secondNextButton = [ZTools createButtonWithFrame:CGRectMake(INDENT, self.verificationCodeTF.bottom+15, self.contentView.width-INDENT*2, 30)
                                                        title:@"确 认"
                                                        image:nil];
        [self.secondNextButton addTarget:self action:@selector(loginTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.backButton) {
        self.backButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame       = CGRectMake(0, 0, 40, 40);
        [self.backButton setImage:[UIImage imageNamed:@"login_back_image"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self.contentView addSubview:self.sendButton];
    [self.contentView addSubview:self.verificationCodeTF];
    [self.contentView addSubview:self.secondNextButton];
    [self.contentView addSubview:self.backButton];
}

-(void)setInvitationView{
    if (!_invitationCodeTF) {
        _invitationCodeTF = [self createTextFieldWithFrame:CGRectMake(self.contentView.width, 60, self.contentView.width-INDENT*2, 30) placeHolder:@"无邀请码请点击跳过"];
        _invitationCodeTF.keyboardType = UIKeyboardTypeDefault;
       
    }
    
    
    if (!self.skipButton) {
        self.skipButton = [ZTools createButtonWithFrame:CGRectMake(self.contentView.width, _invitationCodeTF.bottom+20, 80, 30) title:@"跳过" image:nil];
        [self.skipButton addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.doneButton) {
        self.doneButton = [ZTools createButtonWithFrame:CGRectMake(self.skipButton.right+self.contentView.width, _invitationCodeTF.bottom+20, 80, 30)
                                                  title:@"确认"
                                                  image:nil];
        [self.doneButton addTarget:self action:@selector(addInvitationRequest:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self.contentView addSubview:_invitationCodeTF];
    [self.contentView addSubview:self.skipButton];
    [self.contentView addSubview:self.doneButton];
}

#pragma mark -----  显示某页视图
-(void)showContentView{
    if (self.currentPage == 1) {
        self.titleLabel.text = @"登录";
        [self.phoneTF becomeFirstResponder];
        self.phoneTF.textColor = DEFAULT_BLACK_TEXT_COLOR;
        self.phoneTF.enabled = YES;
        
        if (_verificationCodeTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.verificationCodeTF.alpha   = 0;
                self.sendButton.alpha           = 0;
                self.secondNextButton.alpha     = 0;
                self.backButton.alpha           = 0;
                self.verificationCodeTF.text    = @"";
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.contentView.center     = CGPointMake(DEVICE_WIDTH/2.0f, (DEVICE_HEIGHT-keyboard_height)/2.0f);
            self.phoneTF.top            = 60;
            self.firstNextButon.top     = self.contentView.height-INDENT*2;
            self.firstNextButon.alpha   = 1;
            
            self.phoneTF.layer.borderWidth  = 0.5;
            self.phoneTF.left               = INDENT;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else if (self.currentPage == 2){
        self.titleLabel.text = @"输入验证码";
        self.firstNextButon.alpha = 0;
        self.phoneTF.textColor = DEFAULT_GRAY_TEXT_COLOR;
        self.phoneTF.enabled = NO;
        self.phoneTF.layer.borderWidth = 0;
        [self.verificationCodeTF becomeFirstResponder];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.center     = CGPointMake(DEVICE_WIDTH/2.0f, (DEVICE_HEIGHT-keyboard_height)/2.0f);
            self.phoneTF.top            = 40;
            self.phoneTF.left           = -20;
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.verificationCodeTF.alpha   = 1;
            self.sendButton.alpha           = 1;
            self.secondNextButton.alpha     = 1;
            self.backButton.alpha           = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else if (self.currentPage == 3){
        self.titleLabel.text = @"输入邀请码";
//        [self.backButton removeFromSuperview];
        [self.invitationCodeTF becomeFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            self.contentView.center     = CGPointMake(DEVICE_WIDTH/2.0f, (DEVICE_HEIGHT-keyboard_height)/2.0f);
            
            self.phoneTF.right              = 0;
            self.firstNextButon.right       = 0;
            self.verificationCodeTF.right   = 0;
            self.sendButton.right           = 0;
            self.secondNextButton.right     = 0;
            self.backButton.right           = 0;
            
        } completion:^(BOOL finished) {
            
            self.phoneTF.alpha              = 0;
            self.firstNextButon.alpha       = 0;
            self.verificationCodeTF.alpha   = 0;
            self.sendButton.alpha           = 0;
            self.secondNextButton.alpha     = 0;
            self.backButton.alpha           = 0;
        }];
        
        
        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
            float space = (self.contentView.width-160)/3.0f;
            self.invitationCodeTF.left  = INDENT;
            self.skipButton.left        = space;
            self.doneButton.left        = space*2+80;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark ***************   网络请求
-(void)loginTap:(UIButton *)button{
    
    if (self.phoneTF.text.length != 11) {
        [ZTools showMBProgressWithText:@"请输入正确的手机号" WihtType:MBProgressHUDModeText addToView:self.contentView isAutoHidden:YES];
        return;
    }
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"登录中..." WihtType:MBProgressHUDModeText addToView:self.contentView isAutoHidden:NO];
    
    NSDictionary * aDic = @{@"user_mobile":self.phoneTF.text,
                            @"Code_num":self.verificationCodeTF.text,
                            @"deviceToken":[ZTools getDeviceToken]};
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:LOGIN_URL myParams:aDic success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue]==1)
            {
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                [user setObject:[data objectForKey:@"user_id"] forKey:UID];
                [user setObject:self.phoneTF.text forKey:PHONE_NUMBER];
                [user setBool:YES forKey:LOGIN];
                [user setObject:[ZTools CutAreaString:[data objectForKey:@"mobile_area"]] forKey:PHONE_ADDRESS];
                [user setObject:[ZTools CutAreaString:[data objectForKey:@"ip_area"]] forKey:IP_ADRESS];
                //登录时间
                [user setObject:[ZTools timechangeToDateline] forKey:LOGIN_TIME];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"successLogin" object:nil userInfo:nil];
                
                if ([data[@"type"] intValue] == 1) {
                    [wself goToThirdView];
                }else{
                    if (successBlock) {
                        successBlock();
                    }
                    
                    [ZTools showMBProgressWithText:@"登录成功" WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
                    [wself performSelector:@selector(loginHidden) withObject:nil afterDelay:1.5];
                }
            }else
            {
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
            }
        }
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"登录失败" WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
    }];

}
#pragma mark --------  获取验证码
- (void)getVerificationCode {
    
    if (_phoneTF.text.length != 11)
    {
        [ZTools showMBProgressWithText:@"请输入正确的手机号" WihtType:MBProgressHUDModeText addToView:self.contentView isAutoHidden:YES];
        return;
    }
    
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"发送中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.contentView isAutoHidden:NO];
    NSString * time = [ZTools timechangeToDateline];
    NSDictionary * dic = @{@"user_mobile":_phoneTF.text,
                           @"sendtime":time,
                           @"sign":[self buildSignWithDateLine:time]};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:LOGIN_VERIFICATION_CODE_URL myParams:dic success:^(id data) {
        [hud hide:YES];
        
        
        wself.sendButton.enabled = NO;
        wself.sendButton.backgroundColor = [UIColor lightGrayColor];
        [wself addTimer];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:ERROR_CODE];
            if ([status intValue] == 1)
            {
                [ZTools showMBProgressWithText:@"验证码已发送" WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
            }else
            {
                [wself removeTimer];
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself removeTimer];
        [hud hide:YES];
        [ZTools showMBProgressWithText:@"发送失败，请检查当前网络" WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
    }];
}
#pragma mark --------  增加邀请码
-(void)addInvitationRequest:(UIButton *)button{
    __weak typeof(self)wself = self;
    if (_invitationCodeTF.text.length != 6) {
        [ZTools showMBProgressWithText:@"邀请码不正确" WihtType:MBProgressHUDModeText addToView:self.contentView isAutoHidden:YES];
    }
    
    NSString * time = [ZTools timechangeToDateline];
    NSDictionary * dic = @{@"user_mobile":self.phoneTF.text,
                           @"invite_time":time,
                           @"invite_code":_invitationCodeTF.text,
                           @"sign":[self buildSignWithDateLine:time]};
    
    [[ZAPI manager] sendPost:LOG_ADD_INVITATION_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 1) {
                if (successBlock) {
                    successBlock();
                }
                [ZTools showMBProgressWithText:@"登录成功" WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
                [wself performSelector:@selector(loginHidden) withObject:nil afterDelay:1.5];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.contentView isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --------  跳过输入邀请码
-(void)skipButtonClicked:(UIButton *)button{
    if (successBlock) {
        successBlock();
    }
    [self loginHidden];
}


#pragma mark ---------  跳转到第二页
-(void)goToSecondView:(UIButton *)button{
    
    if (_phoneTF.text.length != 11) {
        [ZTools showMBProgressWithText:@"请输入正确的手机号" WihtType:MBProgressHUDModeText addToView:self.contentView isAutoHidden:YES];
        return;
    }
    [self setVerificationView];
    self.currentPage = 2;
    [self showContentView];
    
    //判断是否是测试账号，测试账号不需要发送短信
    if (![_phoneTF.text isEqualToString:@"18600755163"]) {
        [self getVerificationCode];
    }
}

#pragma mark ---------  跳转到第一页
-(void)backButtonClicked:(UIButton *)button{
    //因为输入邀请码页面（第三页）没有返回按钮，所以只能是返回到第一页
    self.currentPage--;
    [self showContentView];
}
#pragma mark ---------  跳转到第三页
-(void)goToThirdView{
    self.currentPage = 3;
    [self setInvitationView];
    [self showContentView];
}

#pragma mark ---------  重新发送验证码
-(void)reGetVerificationCode:(UIButton *)button{
    [self getVerificationCode];
}

#pragma mark ------- 检测键盘状态
-(void)LoginKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboard_height = keyboardRect.size.height;
    
    [self showContentView];
}

#pragma mark -------  关闭按钮
-(void)closeButtonClicked:(UIButton *)button{
    [self loginHidden];
}
#pragma mark -------   视图消失
-(void)loginHidden{
    [self removeFromSuperview];
}

#pragma mark ------  创建UITextField
-(UITextField *)createTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    UITextField * textField         = [[UITextField alloc] initWithFrame:frame];
    textField.backgroundColor       = [UIColor clearColor];
    textField.placeholder           = placeHolder;
    textField.layer.cornerRadius    = 5;
    textField.layer.borderColor     = DEFAULT_BACKGROUND_COLOR.CGColor;
    textField.layer.borderWidth     = 0.5;
    textField.textAlignment         = NSTextAlignmentCenter;
    textField.keyboardType          = UIKeyboardTypePhonePad;
    textField.font                  = [ZTools returnaFontWith:14];
    
    return textField;
}



#pragma mark -----  增加计时器
-(void)addTimer{
    time_count = 60;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)removeTimer{
    [timer invalidate];
    timer = nil;
    _sendButton.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [_sendButton setTitle:@"重新获取" forState:UIControlStateNormal];
    _sendButton.enabled = YES;
}

-(void)timeCount{
    if (time_count < 1) {
        [self removeTimer];
        return;
    }
    
    _sendButton.titleLabel.text = [NSString stringWithFormat:@"%d秒后重发",time_count];
    [_sendButton setTitle:[NSString stringWithFormat:@"%d秒后重发",time_count] forState:UIControlStateNormal];
    time_count--;
}

#pragma mark -------  创建加密字符
-(NSString *)buildSignWithDateLine:(NSString *)dateline{
    if (dateline && dateline.length > 6) {
        dateline = [[dateline substringToIndex:dateline.length] substringFromIndex:dateline.length-6];
    }
    
    NSString * firstSign = [[WXUtil md5:[NSString stringWithFormat:@"%@%@",_phoneTF.text,dateline]] lowercaseString];
    
    NSString * sign = [[WXUtil md5:[NSString stringWithFormat:@"%@ig61021113",firstSign]] lowercaseString];
    
    return sign;
}

#pragma mark -----------  代理回调 start
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _verificationCodeTF) {
        NSMutableString *newValue = [textField.text mutableCopy];
        [newValue replaceCharactersInRange:range withString:string];
        //如果验证码为6位，直接发送请求
        if (newValue.length == 6) {
            
        }
    }

    return YES;
}
#pragma mark -----------  代理回调 end


@end




