//
//  MyOutPrizeCell.m
//  推盟
//
//  Created by joinus on 16/7/1.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyOutPrizeCell.h"
#define INDENT 15


@implementation MyOutPrizeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_contentBackView) {
            _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(INDENT, 0, DEVICE_WIDTH-INDENT*2, 45)];
            _contentBackView.backgroundColor = RGBCOLOR(229, 229, 229);
            _contentBackView.layer.borderColor = RGBCOLOR(116, 116, 116).CGColor;
            _contentBackView.layer.borderWidth = 0.5;
            [self.contentView addSubview:_contentBackView];
        }
        
        if (!_contentLabel) {
            _contentLabel = [ZTools createLabelWithFrame:CGRectMake(INDENT, 2.5, _contentBackView.width-INDENT*2, _contentBackView.height-5)
                                                    text:@"不约而同！《刺猬小子之天生我次》7月22日 渣渣来袭"
                                               textColor:DEFAULT_BLACK_TEXT_COLOR
                                           textAlignment:NSTextAlignmentLeft
                                                    font:14];
            [_contentBackView addSubview:_contentLabel];
        }
        
        if (!_clickAndLotteryNum) {
            _clickAndLotteryNum = [ZTools createLabelWithFrame:CGRectMake(INDENT, _contentBackView.bottom, 80, 20)
                                                          text:@""
                                                     textColor:RGBCOLOR(73,73,73)
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:10];
            [self.contentView addSubview:_clickAndLotteryNum];
        }
        
        
        
        [_contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(INDENT);
            make.right.equalTo(self.contentView).offset(-INDENT);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentBackView).offset(INDENT);
            make.right.equalTo(_contentBackView).offset(-INDENT);
            make.top.equalTo(_contentBackView);
            make.height.equalTo(_contentBackView.mas_height);
        }];
        
        [_clickAndLotteryNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-16.0f);
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(_contentBackView.mas_bottom);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

-(void)setInfomationWithMyPrizeModel:(MyPrizeModel *)model{
    _contentLabel.text = model.task_name;
    _clickAndLotteryNum.text = [NSString stringWithFormat:@"点击：%@次  抽奖：%@次",model.all_click,model.drawed_num];
}

@end






