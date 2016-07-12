//
//  BasePrizeView.m
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BasePrizeView.h"

#define INDENT 10.0f

@implementation BasePrizeView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(229, 229, 229);
        [self createUI];
    }
    return self;
}

-(void)createUI{
    if (!_name) {
        _name = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                        text:@"爱奇艺黄金会员"
                                   textColor:RGBCOLOR(73,73,73)
                               textAlignment:NSTextAlignmentLeft
                                        font:13];
        [self addSubview:_name];
    }
    
    if (!_date) {
        _date = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                        text:@"07-01 15:09"
                                   textColor:RGBCOLOR(73,73,73)
                               textAlignment:NSTextAlignmentRight
                                        font:12];
        [self addSubview:_date];
    }
    
    if (!_extra1) {
        _extra1 = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                          text:@"账号：123456789"
                                     textColor:RGBCOLOR(73,73,73)
                                 textAlignment:NSTextAlignmentLeft
                                          font:10];
        [self addSubview:_extra1];
    }
    
    if (!_extra2) {
        _extra2 = [ZTools createLabelWithFrame:CGRectMake(INDENT, INDENT, 90, 16)
                                          text:@"密码：123456"
                                     textColor:RGBCOLOR(73,73,73)
                                 textAlignment:NSTextAlignmentLeft
                                          font:10];
        [self addSubview:_extra2];
    }
    
    if (!_convert) {
        _convert = [ZTools createButtonWithFrame:CGRectZero
                                           title:@"立即领取"
                                           image:nil];
        _convert.titleLabel.font = [ZTools returnaFontWith:10];
        _convert.hidden = YES;
        [_convert addTarget:self action:@selector(convertTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_convert];
    }
    
    ///Add AutoLayout
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@INDENT);
        make.top.equalTo(@INDENT);
        make.height.equalTo(@16);
        make.right.equalTo(_date);
    }];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name).offset(INDENT);
        make.right.equalTo(self).offset(INDENT);
        make.width.equalTo(@90);
        make.height.equalTo(_name);
    }];
    
    
    [_extra1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(INDENT);
        make.top.equalTo(_name).offset(5);
        make.height.equalTo(@15);
        make.width.equalTo(@((self.width-30)/2.0f));
    }];
    
    [_extra2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_extra1).offset(INDENT);
        make.top.equalTo(_extra1);
        make.height.equalTo(_extra1);
        make.width.equalTo(_extra1);
    }];
    
    [_convert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_date);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
}

-(void)convertTap:(UIButton *)button{
    
}

@end










