//
//  InvitationViewController.m
//  推盟
//
//  Created by joinus on 15/7/30.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "InvitationViewController.h"
#import "InvitationTableViewCell.h"
#import "InvitationModel.h"
#import "QRCodeViewController.h"
#import "InvitationListViewController.h"

@interface InvitationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    InvitationModel * invitation_info;
}

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
//我的返利
@property (weak, nonatomic) IBOutlet UILabel *my_invitation_money_label;
//邀请人被邀请人或得的奖励
@property (weak, nonatomic) IBOutlet UILabel *my_invitation_people_label;
//我的邀请码
@property (weak, nonatomic) IBOutlet UILabel *my_invitation_code_label;
//复制邀请码
@property (weak, nonatomic) IBOutlet UIButton *invitation_code_copy;
//二维码
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_imageView;
//二维码背景图片
@property (weak, nonatomic) IBOutlet UIImageView *qrcode_background_view;

//立即邀请按钮
@property (weak, nonatomic) IBOutlet UIButton *invitation_now_button;
//邀请规则
@property (weak, nonatomic) IBOutlet UILabel *Invited_rule_label;


@end

@implementation InvitationViewController

-(void)setup{
    
    _my_invitation_code_label.layer.cornerRadius = 5;
    _my_invitation_code_label.textColor = DEFAULT_LINE_COLOR;
    _my_invitation_code_label.layer.masksToBounds = YES;
    _my_invitation_code_label.layer.borderWidth = 1;
    _my_invitation_code_label.layer.borderColor = DEFAULT_BACKGROUND_COLOR.CGColor;
    _invitation_code_copy.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _invitation_code_copy.layer.cornerRadius = 5;
    _invitation_now_button.layer.cornerRadius = 5;
    _invitation_now_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    _my_invitation_money_label.font = [ZTools returnaFontWith:24];
    _my_invitation_people_label.font = [ZTools returnaFontWith:12];
    _my_invitation_code_label.font = [ZTools returnaFontWith:15];
    _Invited_rule_label.font = [ZTools returnaFontWith:12];
    _invitation_now_button.titleLabel.font = [ZTools returnaFontWith:15];
    _invitation_code_copy.titleLabel.font = [ZTools returnaFontWith:15];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"邀请好友";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"邀请列表"];
    
    
    _myScrollView.bounces = NO;
    _my_invitation_code_label.text = [NSString stringWithFormat:@"我的邀请码：%@",[ZTools getInvitationCode]];
    _QRCode_imageView.image = [UIImage imageNamed:@"qrcode_image"];
    
    
//    [self startLoading];
    [self setup];
    [self loadInvitationList];
}

-(void)rightButtonTap:(UIButton *)sender{
    InvitationListViewController * list = [[InvitationListViewController alloc] init];
    list.model = invitation_info;
    [self.navigationController pushViewController:list animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --------  网络请求
-(void)loadInvitationList{
    __weak typeof(self)wself = self;
    NSLog(@" ------   %@",[NSString stringWithFormat:@"%@&user_id=%@",INVITATION_LIST_URL,[ZTools getUid]]);
    [[ZAPI manager] sendGet:[NSString stringWithFormat:@"%@&user_id=%@",INVITATION_LIST_URL,[ZTools getUid]] success:^(id data) {
        [self endLoading];
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:@"status"] intValue] ==1) {
                invitation_info = [[InvitationModel alloc] initWithDictionary:data];
                [wself setInfomation];
            }
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

-(void)setInfomation{
    _my_invitation_money_label.text = [NSString stringWithFormat:@"您已获得奖励积分：%@",invitation_info.total_rebate];
}

#pragma mark  **********   UITableViewDelegate  ***************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return invitation_info.friend_list_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvitationTableViewCell * cell = (InvitationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    [cell setInfomationWith:invitation_info.friend_list_array[indexPath.row]];
    
    return cell;
}
//复制邀请码
- (IBAction)InvitationCodeCopyClicked:(id)sender {
    NSString * invitation_code = [ZTools getInvitationCode];
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    if (invitation_code.length > 0) {
        paste.string = invitation_code;
        [ZTools showMBProgressWithText:@"复制成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }else{
        [ZTools showMBProgressWithText:@"邀请码获取失败，请刷新个人信息重新获取" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }
}
#pragma mark - 邀请好友按钮
- (IBAction)invitationClicked:(id)sender {
    SShareView * shareView = [[SShareView alloc] initWithTitles:@[SHARE_WECHAT_FRIEND,SHARE_WECHAT_CIRCLE,SHARE_TENTCENT_QQ,SHARE_SINA_WEIBO,SHARE_QZONE,SHARE_DOUBAN,SHARE_COPY] title:@"下载注册推盟得积分奖励！" content:@"您的好友邀请您成为推盟好友，接受邀请注册成功并完善个人资料就可以有机会获得积分奖励." Url:WEBSITEH5 image:[UIImage imageNamed:@"Icon"] location:nil urlResource:nil presentedController:self];
    shareView.string_copy = [ZTools getInvitationCode];
    [shareView showInView:self.navigationController.view];
    
    
    [shareView shareButtonClicked:^(NSString *snsName, NSString *shareType) {
        [shareView shareWithSNS:snsName WithShareType:shareType];
    }];
    
    __weak typeof(shareView)wShareView = shareView;
    
    [shareView setShareSuccess:^(NSString *type) {
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享成功" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];

    } failed:^{
        [wShareView ShareViewRemoveFromSuperview];
        [ZTools showMBProgressWithText:@"分享失败" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
    }];
}

#pragma mark --  跳转到二维码界面
-(void)qrcodeClicked:(UITapGestureRecognizer*)sender{
    QRCodeViewController * qrcode_vc = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrcode_vc animated:YES];
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
