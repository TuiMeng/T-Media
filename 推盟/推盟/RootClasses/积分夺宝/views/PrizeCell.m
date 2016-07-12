//
//  PrizeCell.m
//  推盟
//
//  Created by joinus on 16/6/4.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "PrizeCell.h"

@implementation PrizeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_backView) {
            _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 208)];
            _backView.backgroundColor = RGBCOLOR(237, 237, 237);
            [self.contentView addSubview:_backView];
        }
        
        if (!_imageV) {
            _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, DEVICE_WIDTH, _backView.height-15)];
            _imageV.backgroundColor = [UIColor greenColor];
            [_backView addSubview:_imageV];
        }
        
        if (!_titleView) {
            _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.height-35, DEVICE_WIDTH, 35)];
            _titleView.backgroundColor = [UIColor whiteColor];//[RGBCOLOR(40, 40, 40) colorWithAlphaComponent:0.35];
            [_backView addSubview:_titleView];
        }
        
        if (!_titleLabel) {
            _titleLabel = [[CLRollLabel alloc] initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-130, _titleView.height) font:[ZTools returnaFontWith:12] textColor:DEFAULT_BLACK_TEXT_COLOR];
            
            [_titleView addSubview:_titleLabel];
        }
        
        if (!_restLabel) {
            _restLabel = [ZTools createLabelWithFrame:CGRectMake(_titleLabel.right + 10, 0, DEVICE_WIDTH-_titleLabel.right-20, _titleView.height)
                                                 text:@""
                                            textColor:DEFAULT_RED_TEXT_COLOR
                                        textAlignment:NSTextAlignmentRight
                                                 font:12];
            [_titleView addSubview:_restLabel];
        }
        
        if (!_endRemindImageView) {
            UIImage * image = [UIImage imageNamed:@"prizeTaskEndImage"];
            _endRemindImageView = [[UIImageView alloc] initWithImage:image];
            _endRemindImageView.center = CGPointMake(_backView.width - image.size.width/2.0f - 10, image.size.height/2.0f+40);
            _endRemindImageView.hidden = YES;
            [_backView addSubview:_endRemindImageView];
        }
        
    }
    return self;
}

-(void)setInfomationWithPrizeModel:(PrizeModel *)model{
    [_imageV sd_cancelCurrentImageLoad];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.task_img] placeholderImage:[UIImage imageNamed:@"prize_loading_image"]];
    _titleLabel.text = model.task_name;
    _restLabel.text = [NSString stringWithFormat:@"奖品剩余：%@/%@",model.task_prize_surplus,model.task_prize_num];
    _endRemindImageView.hidden = model.task_status.intValue == 1?YES:NO;
}






@end
