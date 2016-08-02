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
            _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH,[ZTools autoWidthWith:180] + 40)];
            _backView.backgroundColor = RGBCOLOR(237, 237, 237);
            [self.contentView addSubview:_backView];
        }
        
        if (!_imageV) {
            _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _backView.height-40)];
            [_backView addSubview:_imageV];
        }
        
        if (!_titleView) {
            _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, _imageV.bottom, DEVICE_WIDTH, 40)];
            _titleView.backgroundColor = RGBCOLOR(143, 143, 145);//[RGBCOLOR(40, 40, 40) colorWithAlphaComponent:0.35];
            [_backView addSubview:_titleView];
        }
        
        if (!_titleLabel) {
            _titleLabel = [[CLRollLabel alloc] initWithFrame:CGRectMake(10, 3, DEVICE_WIDTH-20, 20) font:[ZTools returnaFontWith:14] textColor:[UIColor whiteColor]];
            
            [_titleView addSubview:_titleLabel];
        }
//        
        /*
        if (!_progress_hud) {
            _progress_hud = [[CAShapeLayer alloc] init];
            _progress_hud.frame = CGRectMake(10, _titleLabel.bottom+5, 100, 10);
            _progress_hud.cornerRadius = 5;
            _progress_hud.masksToBounds = YES;
            _progress_hud.backgroundColor = RGBCOLOR(216, 216, 216).CGColor;
            _progress_hud.lineCap = kCALineCapRound;//指定线的边缘是圆的
            _progress_hud.lineWidth = 3;
            _progress_hud.fillColor = RGBCOLOR(248, 172, 62).CGColor;
            [_titleView.layer addSublayer:_progress_hud];
        }
        */
        if (!_restLabel) {
            _restLabel = [ZTools createLabelWithFrame:CGRectMake(10, _titleLabel.bottom, DEVICE_WIDTH-20, 10)
                                                 text:@""
                                            textColor:[UIColor whiteColor]
                                        textAlignment:NSTextAlignmentCenter
                                                 font:11];
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
    _restLabel.text = model.prizeRestString;//[NSString stringWithFormat:@"奖品剩余：%@/%@",model.task_prize_surplus,model.task_prize_num];
    _endRemindImageView.hidden = model.task_status.intValue == 1?YES:NO;
    
    
    /*
    float surplus = model.task_prize_surplus.intValue/model.task_prize_num.intValue;
    float surplus = 100/130.0;
    _restLabel.text = [NSString stringWithFormat:@"%d%%",(int)((1-surplus)*100)];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _progress_hud.bounds.size.width*(1-surplus), 10)];
    _progress_hud.path = path.CGPath;
    */
    
    
}






@end
