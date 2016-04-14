//
//  ModifyPWViewController.m
//  推盟
//
//  Created by joinus on 15/8/31.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ModifyPWViewController.h"

@interface ModifyPWViewController ()

@end

@implementation ModifyPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"修改密码";
    
    [self setup];
    
}

-(void)setup{
    NSArray * array = @[@"请输入原始密码",@"请输入新密码",@"请再次输入新密码"];
    for (int i = 0; i < array.count; i++) {
        STextField * textField = [ZTools createTextFieldWithFrame:CGRectMake(40, 40 + 74*i, DEVICE_WIDTH-80, 44) tag:100+i font:15 placeHolder:array[i] secureTextEntry:YES];
        textField.delegate = self;
        [self.view addSubview:textField];
    }
    
    
    UIButton * modify_button = [UIButton buttonWithType:UIButtonTypeCustom];
    modify_button.frame = CGRectMake(40, 306, DEVICE_WIDTH-80, 44);
    [modify_button setTitle:@"确认" forState:UIControlStateNormal];
    [modify_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modify_button.layer.cornerRadius = 5;
    modify_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [modify_button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modify_button];
}

-(void)doneButtonClicked:(UIButton*)sender{
    NSString * old_pw;
    NSString * new_pw;
    NSString * again_pw;
    for (int i = 0; i<3; i++) {
        STextField * tf = (STextField*)[self.view viewWithTag:100+i];
        if (i == 0) {
            old_pw = tf.text;
        }else if (i == 1){
            new_pw = tf.text;
        }else if (i == 2){
            again_pw = tf.text;
        }
    }
    
    if (old_pw.length == 0 || new_pw.length == 0 || again_pw.length == 0) {
        [ZTools showMBProgressWithText:@"请完整填写信息" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    if (![new_pw isEqualToString:again_pw]) {
        [ZTools showMBProgressWithText:@"输入的新密码不一致" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    __weak typeof(self)wself = self;
    NSLog(@"dic -----   %@",@{@"user_id":[ZTools getUid],@"old_pw":old_pw,@"new_pw":new_pw});
    [[ZAPI manager] sendPost:MODIFY_PASSWORD_URL myParams:@{@"user_id":[ZTools getUid],@"old_pwd":old_pw,@"new_pwd":new_pw} success:^(id data) {
        if ( data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if (status.intValue == 1) {
                [ZTools showMBProgressWithText:@"修改成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                [wself disappearWithPOP:YES afterDelay:1.6];
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:@"errorinfo"] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
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

@end
