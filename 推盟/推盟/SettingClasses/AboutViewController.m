//
//  AboutViewController.m
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>

//影迷乐客服信息
#define YML_KEFU_EMAIL @"kefu@yingmile.com"
#define BUSINESS_EMAIL @"350656912@qq.com"
//推盟客服信息
#define TM_KEFU_EMAIL @"511968851@qq.com"

@interface AboutViewController ()<MFMailComposeViewControllerDelegate>

/**
 *  客服电话
 */
@property (weak, nonatomic) IBOutlet UILabel *service_phone_num_label;

/**
 *  商务合作电话
 */
@property (weak, nonatomic) IBOutlet UILabel *joinus_num_label;
///商务邮箱
@property (weak, nonatomic) IBOutlet UILabel *joinus_mail_label;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title_label.text = [NSString stringWithFormat:@"关于%@",APP_NAME];
    
    
    NSString * kefuEmail = IS_YML?YML_KEFU_EMAIL:TM_KEFU_EMAIL;
    
    NSString * service_num = [NSString stringWithFormat:@"客服邮箱：%@",kefuEmail];
    NSMutableAttributedString * service_attributed_string = [ZTools labelTextColorWith:service_num Color:DEFAULT_BACKGROUND_COLOR range:[service_num rangeOfString:kefuEmail]];
    [service_attributed_string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[service_num rangeOfString:kefuEmail]];
    _service_phone_num_label.attributedText = service_attributed_string;
    
    
    NSString * joinus_mail = [NSString stringWithFormat:@"商务合作：%@",BUSINESS_EMAIL];
    NSMutableAttributedString * joinus_attributed_string = [ZTools labelTextColorWith:joinus_mail Color:DEFAULT_BACKGROUND_COLOR range:[joinus_mail rangeOfString:BUSINESS_EMAIL]];
    [joinus_attributed_string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[joinus_mail rangeOfString:BUSINESS_EMAIL]];
    _joinus_mail_label.attributedText = joinus_attributed_string;
    
    
    UITapGestureRecognizer * service_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceTap:)];
    [_service_phone_num_label addGestureRecognizer:service_tap];
    
    UITapGestureRecognizer * joinus_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinus_tapTap:)];
    [_joinus_mail_label addGestureRecognizer:joinus_tap];
    _joinus_mail_label.userInteractionEnabled = YES;
    
    _iconImageView.image = IS_YML?[UIImage imageNamed:@"yml_Icon"]:[UIImage imageNamed:@"Icon"];
}

-(void)serviceTap:(UITapGestureRecognizer*)sender{
    [self sendEMailWith:(IS_YML?YML_KEFU_EMAIL:TM_KEFU_EMAIL)];
}

-(void)joinus_tapTap:(UITapGestureRecognizer*)sender{
    [self sendEMailWith:BUSINESS_EMAIL];
}

-(void)sendEMailWith:(NSString*)email{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:@""];
    
    //设置收件人
    NSArray *toRecipients = [NSArray arrayWithObjects:email,nil];
    [picker setToRecipients:toRecipients];
    
    //邮件发送的模态窗口
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
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
