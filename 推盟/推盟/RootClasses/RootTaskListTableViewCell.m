//
//  RootTaskListTableViewCell.m
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "RootTaskListTableViewCell.h"

@implementation RootTaskListTableViewCell


- (void)awakeFromNib {
    // Initialization code
    _forward_button.layer.cornerRadius = 5;
    _background_view.layer.borderColor = RGBCOLOR(230, 231, 233).CGColor;
    _background_view.layer.borderWidth = 0.5;
    _forward_button.titleLabel.adjustsFontSizeToFitWidth = YES;
    _forward_button.titleEdgeInsets = UIEdgeInsetsMake(0,5,0,5);
    _title_label.verticalAlignment = VerticalAlignmentTop;
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 5;
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //背景视图
        if (!_background_view) {
            _background_view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, [ZTools autoWidthWith:95]+15)];
            _background_view.clipsToBounds = YES;
            _background_view.backgroundColor = [UIColor whiteColor];
            _background_view.layer.borderColor = RGBCOLOR(230, 231, 233).CGColor;
            _background_view.layer.borderWidth = 0.5;
            [self.contentView addSubview:_background_view];
        }
        //头图
        if (!_headerImageView) {
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, [ZTools autoWidthWith:95], [ZTools autoWidthWith:95])];
            _headerImageView.layer.masksToBounds = YES;
            _headerImageView.layer.cornerRadius = 5;
            [_background_view addSubview:_headerImageView];
        }
        
        //任务标题
        if (!_title_label) {
            _title_label = [[SLabel alloc] initWithFrame:CGRectMake(_headerImageView.right+10, 8, _background_view.width-_headerImageView.width-20-8-35, 35)];
            _title_label.verticalAlignment = VerticalAlignmentTop;
            _title_label.numberOfLines = 2;
            _title_label.font = [ZTools returnaFontWith:13];
            _title_label.textColor = RGBCOLOR(31, 31, 31);
            [_background_view addSubview:_title_label];
        }
        //任务总额
        if (!_bonus_label) {
            _bonus_label = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right+10, _title_label.bottom+10, _title_label.width, 20) tag:100 text:@"" textColor:RGBCOLOR(95, 95, 95) textAlignment:NSTextAlignmentLeft font:18];
            [_background_view addSubview:_bonus_label];
        }
        //用户等级说明
        if (!_system_label) {
            _system_label = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right+10, _background_view.height - 40, 100, 30) tag:101 text:@"" textColor:RGBCOLOR(127, 127, 127) textAlignment:NSTextAlignmentLeft font:10];
            _system_label.numberOfLines = 0;
            [_background_view addSubview:_system_label];
        }
        //转发按钮
        if (!_forward_button) {
            _forward_button = [ZTools createButtonWithFrame:CGRectMake(_background_view.width-[ZTools autoWidthWith:90]-10, _background_view.height-40, [ZTools autoWidthWith:90], 30) tag:102 title:@"" image:nil];
            _forward_button.titleLabel.font = [ZTools returnaFontWith:15];
            _forward_button.titleLabel.adjustsFontSizeToFitWidth = YES;
            _forward_button.layer.cornerRadius = 5;
            [_background_view addSubview:_forward_button];
            
            [_forward_button addTarget:self action:@selector(forwardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (!_tag_label) {
            _tag_label = [[SLabel alloc] initWithFrame:CGRectMake(_background_view.width-35, -35, 70, 70) WithVerticalAlignment:VerticalAlignmentBottom];
            _tag_label.center = CGPointMake(_background_view.width, 0);
            _tag_label.textAlignment = NSTextAlignmentCenter;
            _tag_label.adjustsFontSizeToFitWidth = YES;
            _tag_label.numberOfLines = 0;
            _tag_label.textColor = [UIColor whiteColor];
            _tag_label.font = [ZTools returnaFontWith:11];
            _tag_label.backgroundColor = DEFAULT_BACKGROUND_COLOR;
            
            _tag_label.transform = CGAffineTransformMakeRotation(45 *M_PI / 180.0);
            [_background_view addSubview:_tag_label];
        }
    }
    return self;
}


-(void)setInfoWith:(RootTaskListModel *)model showTag:(BOOL)show WithShare:(RootForwardBlock)block{
    
    forward_block = block;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.task_img] placeholderImage:[UIImage imageNamed:@"default_loading_small_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    NSString * title = [NSString stringWithFormat:@"%@  %@",model.task_name,@"2015-08-09"];
    
    NSMutableAttributedString *title_str = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:@"2015-08-09"];
    [title_str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    [title_str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:12] range:range];
    _title_label.attributedText = title_str;
    
    
    CGSize title_size = [ZTools stringHeightWithFont:_title_label.font WithString:model.task_name WithWidth:_title_label.width];
    _title_label.height = title_size.height;
    _title_label.text = model.task_name;
    _bonus_label.top = _title_label.bottom+10+_bonus_label.height > _system_label.top ?38:_title_label.bottom+10;
    
    NSString * money = [NSString stringWithFormat:@"奖金 ￥%@",model.total_task];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:money];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(255, 149, 46) range:NSMakeRange(3,money.length-3)];
    _bonus_label.attributedText = str;
    
    if (model.task_status.intValue != 1) {
        [_forward_button setTitle:@"已结束" forState:UIControlStateNormal];
        _forward_button.backgroundColor = RGBCOLOR(251, 154, 155);
    }else{
        [_forward_button setTitle:@"转发赚钱" forState:UIControlStateNormal];
        _forward_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    }
    if (show) {
        _tag_label.hidden = NO;
        _tag_label.text = model.column_name;
    }else{
        _tag_label.text = @"";
        _tag_label.hidden = YES;
    }
    
    _system_label.text = [NSString stringWithFormat:@"普通会员:￥%@/点击\n高级会员:￥%@/点击",model.task_price,model.gao_click_price];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)forwardButtonClicked:(UIButton*)sender {
    if (forward_block) {
        forward_block();
    }
}
@end
