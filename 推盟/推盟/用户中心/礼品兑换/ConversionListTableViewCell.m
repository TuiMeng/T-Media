//
//  GiftListTableViewCell.m
//  推盟
//
//  Created by joinus on 15/8/10.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ConversionListTableViewCell.h"

@interface ConversionListTableViewCell ()
/**
 *  头图
 */
@property (weak, nonatomic) IBOutlet UIImageView *header_imageView;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_label;
/**
 *  金额
 */
@property (weak, nonatomic) IBOutlet UILabel *amount_label;
/**
 *  手机号码/券码/联系人
 */
@property (weak, nonatomic) IBOutlet UILabel *phone_num_label;
/**
 *  状态
 */
@property (weak, nonatomic) IBOutlet UILabel *state_label;
/**
 *  充值时间/详情介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *date_label;

/**
 *  状态值宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *state_width_constraints;

@end

@implementation ConversionListTableViewCell


- (void)awakeFromNib {
    // Initialization code
    _state_width_constraints.constant = 20;
    
    _title_label.font = [ZTools returnaFontWith:14];
    _amount_label.font = [ZTools returnaFontWith:18];
    _phone_num_label.font = [ZTools returnaFontWith:13];
    _state_label.font = [ZTools returnaFontWith:12];
    _date_label.font = [ZTools returnaFontWith:13];
}

-(void)setInfomationWith:(GiftRecordModel *)model{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.gift_image_small] placeholderImage:[UIImage imageNamed:@"default_loading_small_image"]];
    _title_label.text = model.gift_name;
    
    NSString * amountString = [NSString stringWithFormat:@"%@积分",model.price];
    _amount_label.attributedText = [ZTools labelTextFontWith:amountString
                                                       Color:DEFAULT_BLACK_TEXT_COLOR
                                                        Font:11
                                                       range:[amountString rangeOfString:@"积分"]];
    
    
    if (model.status.intValue == 1)//未充值
    {
        if (model.type.intValue == 1)//充话费
        {
            NSString * status = @"状态：未充值";
            
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"未充值"]];
            _phone_num_label.text = @"等待系统发放";
            _date_label.text = @"";
        }else if (model.type.intValue == 2 || model.type.intValue == 3)//电影票/视频会员券码
        {
            NSString * status = @"状态：审核中";
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"审核中"]];
            _date_label.text = @"";
            _date_label.text = @"使用方式请查看礼品详情页";
            _date_label.textColor = DEFAULT_BACKGROUND_COLOR;
            _phone_num_label.text = @"等待系统发放";
        }else if (model.type.intValue == 4)//实物订单
        {
            NSString * status = @"状态：审核中";
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"审核中"]];
            _phone_num_label.text = @"等待系统发放";
            _date_label.text = @"";
        }
    }else if(model.status.intValue == 2)///已处理
    {
        if (model.type.intValue == 1)//充话费
        {
            ///如果充值卡号不为空，说明给用户发送了充值卡号
            if ([ZTools replaceNullString:model.number WithReplaceString:@""].length > 0) {
                _state_label.text = [NSString stringWithFormat:@"有效期：%@",model.end_time];
                _phone_num_label.text = [NSString stringWithFormat:@"充值卡号：%@",model.number];
                _date_label.text = [NSString stringWithFormat:@"充值日期：%@",[ZTools timechangeWithTimestamp:model.handling_time WithFormat:@"YYYY-MM-dd"]];
                _date_label.textColor = DEFAULT_LINE_COLOR;
                
                NSString * passWord = [ZTools replaceNullString:model.password WithReplaceString:@""];
                if (passWord.length) {
                    _date_label.text = [NSString stringWithFormat:@"密码：%@",passWord];
                }
            }else///如果充值卡号为空，说明人工充值
            {
                NSString * status = @"状态：已充值";
                _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"已充值"]];
                _phone_num_label.text = [NSString stringWithFormat:@"充值号码：%@",model.phone_num];
                _date_label.text = [NSString stringWithFormat:@"充值日期：%@",[ZTools timechangeWithTimestamp:model.handling_time WithFormat:@"YYYY-MM-dd"]];
                _date_label.textColor = DEFAULT_LINE_COLOR;
            }
        }else if (model.type.intValue == 2 || model.type.intValue == 3)//电影票/视频会员券码
        {
            _state_label.text = [NSString stringWithFormat:@"有效期：%@",model.end_time];
            _phone_num_label.text = [NSString stringWithFormat:@"券号：%@",model.number];
            _date_label.text = @"使用方式请查看礼品详情页";
            _date_label.textColor = DEFAULT_BACKGROUND_COLOR;
            
            NSString * passWord = [ZTools replaceNullString:model.password WithReplaceString:@""];
            if (passWord.length) {
                _date_label.text = [NSString stringWithFormat:@"密码：%@",passWord];
            }
        }else if (model.type.intValue == 4)//实物订单
        {
            NSString * status = @"状态：已发货";
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"已充值"]];
            //物流平台+运单号
            _phone_num_label.text = [NSString stringWithFormat:@"%@",model.number];
            _date_label.text = [NSString stringWithFormat:@"发货日期：%@",[ZTools timechangeWithTimestamp:model.handling_time WithFormat:@"YYYY-MM-dd"]];
            _date_label.textColor = DEFAULT_LINE_COLOR;
        }
    }else///已拒绝
    {
        if (model.type.intValue == 1)//充话费
        {
            NSString * status = @"状态：已拒绝";
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"已拒绝"]];
            
            _phone_num_label.text = [NSString stringWithFormat:@"拒绝原因：%@",model.reason];
            _date_label.text = [NSString stringWithFormat:@"审核日期：%@",[ZTools timechangeWithTimestamp:model.handling_time WithFormat:@"YYYY-MM-dd"]];
            _date_label.textColor = DEFAULT_LINE_COLOR;
        }else if (model.type.intValue == 2 || model.type.intValue == 3)//电影票/视频会员券码
        {
            NSString * status = @"状态：已拒绝";
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"已拒绝"]];
            _phone_num_label.text = [NSString stringWithFormat:@"拒绝原因：%@",model.reason];
            _date_label.text = [NSString stringWithFormat:@"审核日期：%@",[ZTools timechangeWithTimestamp:model.handling_time WithFormat:@"YYYY-MM-dd"]];
            _date_label.textColor = DEFAULT_LINE_COLOR;
        }else if (model.type.intValue == 4)//实物订单
        {
            NSString * status = @"状态：已拒绝";
            _state_label.attributedText = [ZTools labelTextColorWith:status Color:DEFAULT_LINE_COLOR range:[status rangeOfString:@"已拒绝"]];
            _phone_num_label.text = [NSString stringWithFormat:@"拒绝原因：%@",model.reason];
            _date_label.text = [NSString stringWithFormat:@"审核日期：%@",[ZTools timechangeWithTimestamp:model.handling_time WithFormat:@"YYYY-MM-dd"]];
            _date_label.textColor = DEFAULT_LINE_COLOR;
        }
    }
    
    CGSize state_size = [ZTools stringHeightWithFont:_state_label.font WithString:_state_label.text WithWidth:MAXFLOAT];
    _state_width_constraints.constant = state_size.width;
    
    [_state_label sizeToFit];
    _state_width_constraints.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
