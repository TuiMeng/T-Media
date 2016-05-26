//
//  MOrderCell.m
//  推盟
//
//  Created by joinus on 16/4/26.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MOrderCell.h"
#define INDENT 15



@implementation MOrderCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_backContentView) {
            _backContentView = [[UIView alloc] initWithFrame:CGRectZero];
            _backContentView.backgroundColor = [UIColor whiteColor];
            _backContentView.clipsToBounds = YES;
            [self.contentView addSubview:_backContentView];
        }
        
        if (!_orderIdLebel) {
            _orderIdLebel = [ZTools createLabelWithFrame:CGRectZero
                                                    text:@""
                                               textColor:DEFAULT_BLACK_TEXT_COLOR
                                           textAlignment:NSTextAlignmentLeft
                                                    font:13];
            _orderIdLebel.adjustsFontSizeToFitWidth = YES;
            [_backContentView addSubview:_orderIdLebel];
        }
        
        if (!_orderDateLabel) {
            _orderDateLabel = [ZTools createLabelWithFrame:CGRectZero
                                                      text:@""
                                                 textColor:DEFAULT_ORANGE_TEXT_COLOR
                                             textAlignment:NSTextAlignmentRight
                                                      font:11];
            [_backContentView addSubview:_orderDateLabel];
        }
        
        if (!_lineView) {
            _lineView = [[UIView alloc] init];
            _lineView.backgroundColor = DEFAULT_MOVIE_LINE_COLOR;
            [_backContentView addSubview:_lineView];
        }
        
        if (!_movieNameLabel) {
            _movieNameLabel = [ZTools createLabelWithFrame:CGRectZero
                                                      text:@""
                                                 textColor:DEFAULT_RED_TEXT_COLOR
                                             textAlignment:NSTextAlignmentLeft
                                                      font:13];
            [_backContentView addSubview:_movieNameLabel];
        }
        
        if (!_cinemaNameLabel) {
            _cinemaNameLabel = [ZTools createLabelWithFrame:CGRectZero
                                                       text:@""
                                                  textColor:DEFAULT_BLACK_TEXT_COLOR
                                              textAlignment:NSTextAlignmentLeft
                                                       font:13];
            [_backContentView addSubview:_cinemaNameLabel];
        }
        
        if (!_playDateLabel) {
            _playDateLabel = [ZTools createLabelWithFrame:CGRectZero
                                                       text:@""
                                                  textColor:DEFAULT_BLACK_TEXT_COLOR
                                              textAlignment:NSTextAlignmentLeft
                                                       font:13];
            [_backContentView addSubview:_playDateLabel];
        }
        
        if (!_seatsLabel) {
            _seatsLabel = [ZTools createLabelWithFrame:CGRectZero
                                                       text:@""
                                                  textColor:DEFAULT_BLACK_TEXT_COLOR
                                              textAlignment:NSTextAlignmentLeft
                                                       font:13];
            [_backContentView addSubview:_seatsLabel];
        }
        
        if (!_totalMoneyLabel) {
            _totalMoneyLabel = [ZTools createLabelWithFrame:CGRectZero
                                                  text:@""
                                             textColor:DEFAULT_RED_TEXT_COLOR
                                         textAlignment:NSTextAlignmentLeft
                                                  font:15];
            [_backContentView addSubview:_totalMoneyLabel];
        }
        
        if (!_scoreNumLabel) {
            _scoreNumLabel = [ZTools createLabelWithFrame:CGRectZero
                                                  text:@""
                                             textColor:DEFAULT_ORANGE_TEXT_COLOR
                                         textAlignment:NSTextAlignmentLeft
                                                  font:11];
            [_backContentView addSubview:_scoreNumLabel];
        }
        
        if (!_getCodeButton) {
            _getCodeButton = [ZTools createButtonWithFrame:CGRectZero
                                                     title:@"重新获取取票码"
                                                     image:nil];
            _getCodeButton.titleLabel.font = [ZTools returnaFontWith:12];
            [_getCodeButton addTarget:self action:@selector(getCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_backContentView addSubview:_getCodeButton];
        }
        
        if (!_orderStatusLabel) {
            _orderStatusLabel = [ZTools createLabelWithFrame:CGRectZero
                                                       text:@""
                                                  textColor:[UIColor whiteColor]
                                              textAlignment:NSTextAlignmentCenter
                                                       font:12];
            _orderStatusLabel.backgroundColor = [UIColor lightGrayColor];
            [_backContentView addSubview:_orderStatusLabel];
        }
        
        
        //约束管理
        [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.contentView).with.offset(-10);
        }];
        
        [_orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(120));
            make.right.equalTo(@(-INDENT));
            make.height.equalTo(@(25));
            make.top.equalTo(@(5));
        }];
        
        [_orderIdLebel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.right.equalTo(_orderIdLebel).with.offset(10);
            make.height.equalTo(_orderDateLabel);
            make.top.equalTo(@(5));
        }];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.right.equalTo(@(-INDENT));
            make.top.equalTo(_orderIdLebel.mas_bottom).with.offset(5);
            make.height.equalTo(@(0.5));
        }];
        
        [_movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.right.equalTo(@(INDENT));
            make.height.equalTo(@(20));
            make.top.equalTo(_lineView.mas_bottom).with.offset(10);
        }];
        
        [_cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.right.equalTo(@(INDENT));
            make.height.equalTo(@(20));
            make.top.equalTo(_movieNameLabel.mas_bottom);
        }];
        
        [_playDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.right.equalTo(@(INDENT));
            make.height.equalTo(@(20));
            make.top.equalTo(_cinemaNameLabel.mas_bottom);
        }];
        
        [_seatsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.right.equalTo(@(INDENT));
            make.height.equalTo(@(20));
            make.top.equalTo(_playDateLabel.mas_bottom);
        }];
        
        [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.bottom.equalTo(_backContentView).with.offset(-10);
            make.height.equalTo(@(25));
            make.right.equalTo(_orderStatusLabel.mas_left);
        }];
        
        [_scoreNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(INDENT));
            make.bottom.equalTo(_totalMoneyLabel.mas_top);
            make.height.equalTo(@(18));
            make.right.equalTo(_getCodeButton.mas_left);
        }];
        
        [_getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(90));
            make.height.equalTo(@(25));
            make.right.equalTo(@(-INDENT));
            make.top.equalTo(_seatsLabel.mas_bottom).with.offset(5);
        }];
        
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(60));
            make.height.equalTo(@(25));
            make.right.equalTo(@(-25));
            make.top.equalTo(_getCodeButton.mas_bottom).with.offset(5);
        }];
    }
    
    return self;
}

-(void)setInfomationWithOrderModel:(MovieOrderListModel *)model{
    info = model;
    _orderIdLebel.text      = [NSString stringWithFormat:@"订单编号：%@",model.pay_no];
    _orderDateLabel.text    =  model.feature_time;//[ZTools timechangeWithTimestamp:model.order_data WithFormat:@"YYYY-MM-dd HH:mm"];
    _movieNameLabel.text    = [NSString stringWithFormat:@"影片：《%@》",model.movie_name];
    _cinemaNameLabel.text   = [NSString stringWithFormat:@"影院：%@  %@",model.cinema_name,model.hall_name];
    _playDateLabel.text     = [NSString stringWithFormat:@"放映时间：%@",model.feature_time];
    _seatsLabel.text        = [NSString stringWithFormat:@"座位：%@  共%@张",model.ticket_desc,model.tickts_amount];
    _totalMoneyLabel.text   = [NSString stringWithFormat:@"总金额：%@元",model.all_money];
    
    if (model.integral.intValue==0) {
        _scoreNumLabel.hidden = YES;
    }else if(model.integral.intValue != 0 && model.status.intValue == 1){
        _scoreNumLabel.hidden   = NO;
        _scoreNumLabel.text     = [NSString stringWithFormat:@"使用积分%d，已为您节省%@元",model.integral.intValue*10,model.integral];
    }
    
    _orderStatusLabel.text = model.status.intValue == 1?@"交易完成":@"交易失败";
    _getCodeButton.hidden = model.status.intValue==1?NO:YES;
}

-(void)getTicketCodeClicked:(MOrderGetTicketCodeBlock)block{
    getTicketCodeBlock = block;
}

-(void)getCodeClicked:(UIButton *)button{
    getTicketCodeBlock(info.pay_no);
}








@end
