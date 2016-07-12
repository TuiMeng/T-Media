//
//  WinnerListCell.m
//  推盟
//
//  Created by joinus on 16/6/6.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "WinnerListCell.h"

@implementation WinnerListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_mobileLabel) {
            _mobileLabel = [ZTools createLabelWithFrame:CGRectMake(10, 5, 90, 34)
                                                   text:@"186****5163"
                                              textColor:DEFAULT_BLACK_TEXT_COLOR
                                          textAlignment:NSTextAlignmentLeft
                                                   font:14];
            [self.contentView addSubview:_mobileLabel];
        }
        
        if (!_dateLabel) {
            _dateLabel = [ZTools createLabelWithFrame:CGRectMake(DEVICE_WIDTH-100, 5, 90, 34)
                                                 text:@"06-01 10:00"
                                            textColor:DEFAULT_BLACK_TEXT_COLOR
                                        textAlignment:NSTextAlignmentRight
                                                 font:14];
            [self.contentView addSubview:_dateLabel];
        }
        
        if (!_clickNumLabel) {
            _clickNumLabel = [ZTools createLabelWithFrame:CGRectMake(_mobileLabel.right+5, 5, _dateLabel.left-_mobileLabel.right-10, 34)
                                                     text:@"精品套餐一份"
                                                textColor:DEFAULT_BLACK_TEXT_COLOR
                                            textAlignment:NSTextAlignmentCenter
                                                     font:14];
            [self.contentView addSubview:_clickNumLabel];
        }
    }
    
    return self;
}

-(void)setInfomationWithWinnerModel:(WinnerModel *)model{
    _mobileLabel.text   = model.user_mobile;
    _clickNumLabel.text = model.prize_name;
    _dateLabel.text     = [ZTools timechangeWithTimestamp:model.draw_time WithFormat:@"MM-dd HH:mm"];
}



@end
