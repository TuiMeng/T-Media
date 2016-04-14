//
//  ApplyMoneyCell.m
//  推盟
//
//  Created by joinus on 15/8/25.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ApplyMoneyCell.h"

@implementation ApplyMoneyCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_apply_date_label) {
            _apply_date_label = [self createLabelWithFrame:CGRectMake(10, 5, DEVICE_WIDTH*4*0.5/7.0f-20, 34)];
        }
        
        if (!_handle_date_label) {
            _handle_date_label = [self createLabelWithFrame:CGRectMake(_apply_date_label.right+20, 5, DEVICE_WIDTH*4*0.5/7.0f - 20, 34)];
        }
        
        if (!_total_moeny_label) {
            _total_moeny_label = [self createLabelWithFrame:CGRectMake(_handle_date_label.right + 20, 5, DEVICE_WIDTH*3*0.5/7.0f - 20, 34)];
        }
        
        if (!_status_label) {
            _status_label = [self createLabelWithFrame:CGRectMake(_total_moeny_label.right + 12, 2, DEVICE_WIDTH*3*0.5/7.0f-4, 40)];
            _status_label.adjustsFontSizeToFitWidth = YES;
//            _status_label.backgroundColor = [UIColor redColor];
        }
        
    }
    return self;
}

-(void)setInfomationWith:(ApplyRecordModel *)model{
    _apply_date_label.text = [ZTools timechangeWithTimestamp:model.create_time WithFormat:@"YYYY-MM-dd HH:mm"];
    _total_moeny_label.text = [NSString stringWithFormat:@"￥%@",model.money];
    _handle_date_label.text = @"";
    if (model.solve_status.intValue == 0)//未处理
    {
        _status_label.text = @"审核中";
    }else if (model.solve_status.intValue == 1)//已处理
    {
        _status_label.text = @"已提现";
        if ([ZTools replaceNullString:model.solve_time WithReplaceString:@""].length > 0) {
            _handle_date_label.text = [ZTools timechangeWithTimestamp:model.solve_time WithFormat:@"YYYY-MM-dd HH:mm"];
        }
        
    }else//已拒绝
    {
        _status_label.text = model.reason;
        if ([ZTools replaceNullString:model.solve_time WithReplaceString:@""].length > 0) {
            _handle_date_label.text = [ZTools timechangeWithTimestamp:model.solve_time WithFormat:@"YYYY-MM-dd HH:mm"];
        }
    }
}


-(UILabel *)createLabelWithFrame:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = RGBCOLOR(42, 42, 42);
    label.font = [ZTools returnaFontWith:13];
    [self.contentView addSubview:label];
    return label;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
