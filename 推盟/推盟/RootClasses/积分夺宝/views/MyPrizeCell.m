//
//  MyPrizeCell.m
//  推盟
//
//  Created by joinus on 16/6/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyPrizeCell.h"

#define INDENT 15

@interface MyPrizeCell ()

@property(nonatomic,strong)MyPrizeModel * prizeModel;

@end

@implementation MyPrizeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_backView) {
            _backView = [[UIView alloc] initWithFrame:CGRectMake(INDENT, 0, DEVICE_WIDTH-INDENT*2, 65)];
            _backView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
            _backView.layer.borderWidth = 0.5;
            [self.contentView addSubview:_backView];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTaskContent:)];
            [_backView addGestureRecognizer:tap];
        }
        
        if (!_titleView) {
            _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, 20)];
            _titleView.backgroundColor = RGBCOLOR(251, 142, 145);
            [_backView addSubview:_titleView];
        }
        
        if (!_timeLabel) {
            _timeLabel = [ZTools createLabelWithFrame:CGRectMake(_titleView.width-95, 0, 90, _titleView.height)
                                                 text:@"2016-06-01"
                                            textColor:[UIColor whiteColor]
                                        textAlignment:NSTextAlignmentRight
                                                 font:13];
            [_titleView addSubview:_timeLabel];
        }
        
        if (!_PrizeNameLabel) {
            _PrizeNameLabel = [ZTools createLabelWithFrame:CGRectMake(5, 0, _timeLabel.left - 15, 20)
                                                      text:@"爱奇艺黄金会员"
                                                 textColor:[UIColor whiteColor]
                                             textAlignment:NSTextAlignmentLeft
                                                      font:14];
            [_titleView addSubview:_PrizeNameLabel];
        }
        
        if (!_contentBackView) {
            _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleView.bottom, _backView.width, 45)];
            _contentBackView.backgroundColor = RGBCOLOR(229, 229, 229);
            [_backView addSubview:_contentBackView];
        }
        
        if (!_contentLabel) {
            _contentLabel = [ZTools createLabelWithFrame:CGRectMake(INDENT, 2.5, _contentBackView.width-INDENT*2, _contentBackView.height-5)
                                                    text:@"不约而同！《刺猬小子之天生我次》7月22日 渣渣来袭"
                                               textColor:DEFAULT_BLACK_TEXT_COLOR
                                           textAlignment:NSTextAlignmentLeft
                                                    font:14];
            [_contentBackView addSubview:_contentLabel];
        }
        
        if (!_lotteryNumLabel) {
            _lotteryNumLabel = [ZTools createLabelWithFrame:CGRectMake((DEVICE_WIDTH-80)/2.0f, _backView.bottom, 80, 20)
                                                       text:@"抽奖：5次"
                                                  textColor:DEFAULT_BLACK_TEXT_COLOR
                                              textAlignment:NSTextAlignmentCenter
                                                       font:13];
            [self.contentView addSubview:_lotteryNumLabel];
        }
        
        if (!_clickedNumLabel) {
            _clickedNumLabel = [ZTools createLabelWithFrame:CGRectMake(INDENT, _backView.bottom, _lotteryNumLabel.left-25, 20)
                                                       text:@"点击：50次"
                                                  textColor:DEFAULT_BLACK_TEXT_COLOR
                                              textAlignment:NSTextAlignmentLeft
                                                       font:13];
            [self.contentView addSubview:_clickedNumLabel];
        }
        
        if (!_lookButton) {
            _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _lookButton.frame = CGRectMake(_backView.right-70, _backView.bottom, 60, 25);
            [_lookButton setTitle:@"领取" forState:UIControlStateNormal];
            _lookButton.titleLabel.font = [ZTools returnaFontWith:13];
            [_lookButton setTitleColor:DEFAULT_RED_TEXT_COLOR forState:UIControlStateNormal];
            [_lookButton addTarget:self action:@selector(lookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_lookButton];
        }
        
        if (!_statusLabel) {
            _statusLabel = [ZTools createLabelWithFrame:CGRectMake(INDENT, _clickedNumLabel.bottom, 90, 20)
                                                   text:@"状态：已发放"
                                              textColor:DEFAULT_GRAY_TEXT_COLOR
                                          textAlignment:NSTextAlignmentLeft
                                                   font:12];
            [self.contentView addSubview:_statusLabel];
        }
        
        if (!_platformLabel) {
            _platformLabel = [ZTools createLabelWithFrame:CGRectMake(_statusLabel.right+10, _clickedNumLabel.bottom, DEVICE_WIDTH-_platformLabel.right-20, 20)
                                                     text:@"物流：圆通 运单号：123456789012"
                                                textColor:DEFAULT_GRAY_TEXT_COLOR
                                            textAlignment:NSTextAlignmentRight
                                                     font:12];
            [self.contentView addSubview:_platformLabel];
        }
    }
    return self;
}

-(void)setInfomationWithMyPrizeModel:(MyPrizeModel *)model
                       getPrizeBlock:(MyPrizeCellGetPrizeBlock)gBlock
                lookTaskContentBlock:(MyPrizeCellLookTaskContentBlock)lBlock{

    getBlock = gBlock;
    lookBlock = lBlock;
    _prizeModel = model;
    
    _PrizeNameLabel.text = model.prize_name;
    _contentLabel.text = model.task_name;
    _clickedNumLabel.text = [NSString stringWithFormat:@"点击：%@次",model.all_click];
    _lotteryNumLabel.text = [NSString stringWithFormat:@"抽奖：%@次",model.drawed_num];
    
    _statusLabel.text = [self handleStatusWith:model.status];
    _platformLabel.text = [self returnPlatformString];
    
    //奖品未领取，可以领取
    _lookButton.hidden = model.canAcceptPrize.intValue?NO:YES;
    
}

#pragma mark ---  查看/领取奖品
-(void)lookButtonClicked:(UIButton *)button{
    if (_prizeModel.canAcceptPrize.integerValue) {
        if (getBlock) {
            getBlock();
        }
    }else{
        if (lookBlock) {
            lookBlock();
        }
    }
    
}

#pragma mark ----- 查看任务详情
-(void)showTaskContent:(UITapGestureRecognizer *)sender{
    if (lookBlock) {
        lookBlock();
    }
}

#pragma mark ------  处理状态值
-(NSString *)handleStatusWith:(NSString *)status{
    if (status.integerValue == 0) {
        return @"状态:审核中";
    }else if (status.intValue == 1) {
        return @"状态:已发放";
    }else if (status.intValue == 2) {
        return @"状态:已拒绝";
    }
    return @"";
}
-(NSString *)returnPlatformString{
    if (_prizeModel.isVirtual.intValue && _prizeModel.status.intValue == 2) {
        return _prizeModel.reason;
    }
    
    if (!_prizeModel.isVirtual.intValue) {
        if (_prizeModel.status.intValue == 1) {
            return [NSString stringWithFormat:@"物流：圆通 运单号：123456789012"];
        }else if (_prizeModel.status.intValue == 2)  {
            return _prizeModel.reason;
        }
    }
    return @"";
}

@end








