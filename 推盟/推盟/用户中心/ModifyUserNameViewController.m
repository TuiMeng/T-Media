//
//  ModifyUserNameViewController.m
//  推盟
//
//  Created by joinus on 15/8/31.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ModifyUserNameViewController.h"

@interface ModifyUserNameViewController (){
    
}

@property(nonatomic,strong)STextField * myTextField;

@end

@implementation ModifyUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"修改昵称";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myTextField = [ZTools createTextFieldWithFrame:CGRectMake(40, 50, DEVICE_WIDTH-80, 45) tag:10 font:15 placeHolder:[ZTools getUserName] secureTextEntry:NO];
    _myTextField.delegate = self;
    [self.view addSubview:_myTextField];
    
    
    UIButton * done_button = [ZTools createButtonWithFrame:CGRectMake(40,_myTextField.bottom+50, DEVICE_WIDTH-80, 45) tag:10 title:@"确认" image:nil];
    [done_button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:done_button];
}

-(void)doneButtonClicked:(UIButton*)sender{
    if (_myTextField.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入新用户名" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    MBProgressHUD * hud = [ZTools showMBProgressWithText:@"提交中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:MODIFY_USER_INFOMATION_URL myParams:@{@"user_id":[ZTools getUid],@"user_name":_myTextField.text} success:^(id data) {
        [hud hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString * status = [data objectForKey:@"status"];
            if (status.intValue == 1) {
                [ZTools showMBProgressWithText:@"修改成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserInfomation" object:nil];
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
