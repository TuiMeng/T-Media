//
//  PersonalCenterCell.m
//  推盟
//
//  Created by joinus on 15/8/5.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "PersonalCenterCell.h"

@implementation PersonalCenterCell

- (void)awakeFromNib {
    _background_view.layer.borderWidth = 0.5;
    _background_view.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    
    _title_label.verticalAlignment = VerticalAlignmentTop;
    
    _title_label.font = [ZTools returnaFontWith:15];
    _clicked_num_label.font = [ZTools returnaFontWith:12];
    _total_money_label.font = [ZTools returnaFontWith:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setInfomationWithModel:(UserTaskModel *)info{
    
    _title_label.text = info.task_name;
    _clicked_num_label.text = [NSString stringWithFormat:@"累计点击：%@",info.click_num];
    _total_money_label.text = [NSString stringWithFormat:@"累计积分：%@",info.get_points];
}


@end
