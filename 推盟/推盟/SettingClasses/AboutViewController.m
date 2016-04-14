//
//  AboutViewController.m
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>

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


@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title_label.text = @"关于推盟";
    
    NSString * service_num = @"客服邮箱：511968851@qq.com";
    NSMutableAttributedString * service_attributed_string = [ZTools labelTextColorWith:service_num Color:DEFAULT_BACKGROUND_COLOR range:[service_num rangeOfString:@"511968851@qq.com"]];
    [service_attributed_string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[service_num rangeOfString:@"511968851@qq.com"]];
    _service_phone_num_label.attributedText = service_attributed_string;
    
    
    NSString * joinus_mail = @"商务合作：350656912@qq.com";
    NSMutableAttributedString * joinus_attributed_string = [ZTools labelTextColorWith:joinus_mail Color:DEFAULT_BACKGROUND_COLOR range:[joinus_mail rangeOfString:@"350656912@qq.com"]];
    [joinus_attributed_string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[joinus_mail rangeOfString:@"350656912@qq.com"]];
    _joinus_mail_label.attributedText = joinus_attributed_string;
    
    
    UITapGestureRecognizer * service_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceTap:)];
    [_service_phone_num_label addGestureRecognizer:service_tap];
    
    UITapGestureRecognizer * joinus_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinus_tapTap:)];
    [_joinus_mail_label addGestureRecognizer:joinus_tap];
    _joinus_mail_label.userInteractionEnabled = YES;
}

-(void)serviceTap:(UITapGestureRecognizer*)sender{
    [self sendEMailWith:@"511968851@qq.com"];
}

-(void)joinus_tapTap:(UITapGestureRecognizer*)sender{
    [self sendEMailWith:@"350656912@qq.com"];
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
