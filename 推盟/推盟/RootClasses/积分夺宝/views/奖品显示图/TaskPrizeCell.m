//
//  TaskPrizeCell.m
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "TaskPrizeCell.h"
#define INDENT 10.0f

@implementation TaskPrizeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}

-(void)createUI{
    
    if (!_backV) {
        _backV = [[UIView alloc] init];
        _backV.backgroundColor = RGBCOLOR(227, 227, 227);
        [self.contentView addSubview:_backV];
    }
    
    
    if (!_name) {
        _name = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                        text:@"爱奇艺黄金会员"
                                   textColor:RGBCOLOR(73,73,73)
                               textAlignment:NSTextAlignmentLeft
                                        font:13];
        [_backV addSubview:_name];
    }
    
    if (!_date) {
        _date = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                        text:@"07-01 15:09"
                                   textColor:RGBCOLOR(73,73,73)
                               textAlignment:NSTextAlignmentRight
                                        font:12];
        [_backV addSubview:_date];
    }
    
    if (!_extra1) {
        _extra1 = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                          text:@"账号：123456789"
                                     textColor:RGBCOLOR(73,73,73)
                                 textAlignment:NSTextAlignmentLeft
                                          font:10];
        [_backV addSubview:_extra1];
    }
    
    if (!_extra2) {
        _extra2 = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                          text:@"密码：123456"
                                     textColor:RGBCOLOR(73,73,73)
                                 textAlignment:NSTextAlignmentRight
                                          font:10];
        [_backV addSubview:_extra2];
    }
    
    if (!_convert) {
        _convert = [ZTools createButtonWithFrame:CGRectZero
                                           title:@"立即领取"
                                           image:nil];
        _convert.titleLabel.font = [ZTools returnaFontWith:10];
        _convert.hidden = YES;
        [_convert addTarget:self action:@selector(convertTap:) forControlEvents:UIControlEventTouchUpInside];
        [_backV addSubview:_convert];
    }
    
    ///Add AutoLayout
    
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2.5f);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@INDENT);
        make.top.equalTo(@INDENT);
        make.height.equalTo(@16);
        make.right.equalTo(_date);
    }];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backV.mas_right).offset(-INDENT);
        make.top.equalTo(_backV).offset(5);
        make.width.equalTo(@90);
        make.height.equalTo(_name.mas_height);
    }];
    
    
    [_extra1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backV).offset(INDENT);
        make.top.equalTo(_name.mas_bottom).offset(5);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.width-30)/2.0f));
    }];
    
    [_extra2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backV.mas_right).offset(-INDENT);
        make.top.equalTo(_extra1.mas_top);
        make.height.equalTo(_extra1.mas_height);
        make.width.equalTo(_extra1.mas_width);
    }];
    
    [_convert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backV.mas_right).offset(-INDENT);
        make.top.equalTo(_date.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
}

-(void)setInfomationWithPrizeModel:(PrizeStatusModel *)model{
    _name.text = model.prize_name;
    
    _date.text = model.date?[ZTools timechangeWithTimestamp:model.date WithFormat:@"MM-dd HH:mm"]:@"";
    
    _extra1.text  = @"";
    _extra2.text  = @"";
    
    _convert.hidden = !(model.canAcceptPrize.intValue == 1);
    
    if (model.canAcceptPrize.intValue == 1) //是否可以领奖
    {
        return;
    }
    
    if (model.Status.intValue == 1) //审核中
    {
        _extra1.text = @"状态：审核中";
        
    } else if (model.Status.intValue == 3) //拒绝
    {
        _extra1.text = [NSString stringWithFormat:@"状态：已拒绝"];
        _extra2.text = [NSString stringWithFormat:@"原因：%@",model.Reason];
    } else if (model.Status.intValue == 2) //通过
    {
        if (model.isVirtual.intValue == 1) //虚拟物品
        {
            _extra1.text = [NSString stringWithFormat:@"账号：%@",model.account];
            _extra2.text = model.pwd.length?[NSString stringWithFormat:@"密码：%@",model.pwd]:@"";
        } else {
            _extra1.text = model.orderNo.length?[NSString stringWithFormat:@"运单号：%@",model.orderNo]:@"暂无物流信息";
            _extra2.text = model.Platform.length?[NSString stringWithFormat:@"承运来源：%@",model.Platform]:@"";
        }
    }
}

#pragma mak ----  立即兑换按钮
-(void)convertTap:(UIButton *)button{
    
    if (_delegate && [_delegate respondsToSelector:@selector(convertClicked:)]) {
        [_delegate convertClicked:self];
    }
}



@end











