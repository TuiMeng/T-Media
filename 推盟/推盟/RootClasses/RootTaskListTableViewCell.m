//
//  RootTaskListTableViewCell.m
//  推盟
//
//  Created by joinus on 15/8/4.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "RootTaskListTableViewCell.h"
#define GRAY_TEXT_COLOR RGBCOLOR(95,95,95)

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
            _background_view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH-20, [ZTools autoWidthWith:100]+40)];
            _background_view.clipsToBounds = YES;
            _background_view.backgroundColor = [UIColor whiteColor];
            _background_view.layer.borderColor = RGBCOLOR(230, 231, 233).CGColor;
            _background_view.layer.borderWidth = 0.5;
            [self.contentView addSubview:_background_view];
        }
        //头图
        if (!_headerImageView) {
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, [ZTools autoWidthWith:100], [ZTools autoWidthWith:100])];
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
        
        if (!_date_label) {
            _date_label = [ZTools createLabelWithFrame:CGRectZero text:@"谁是事儿" textColor:DEFAULT_LINE_COLOR textAlignment:NSTextAlignmentLeft font:11];
            
            [_background_view addSubview:_date_label];
        }
        
        //任务总额
        if (!_bonus_label) {
            _bonus_label = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right+10, _title_label.bottom+10, _title_label.width, 20) tag:100 text:@"" textColor:GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:18];
            [_background_view addSubview:_bonus_label];
        }
        
        /*
        //用户等级说明
        if (!_system_label) {
            _system_label = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right+10, _background_view.height - 40, 110, 30) tag:101 text:@"" textColor:RGBCOLOR(127, 127, 127) textAlignment:NSTextAlignmentLeft font:10];
            _system_label.numberOfLines = 0;
            [_background_view addSubview:_system_label];
        }
         */
        //转发按钮
        if (!_forward_button) {
            _forward_button = [ZTools createButtonWithFrame:CGRectMake(_background_view.width-[ZTools autoWidthWith:90]-10, _bonus_label.bottom-40, [ZTools autoWidthWith:90], 30) tag:102 title:@"" image:nil];
            _forward_button.titleLabel.font = [ZTools returnaFontWith:14];
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
        
        if (!_forward_num) {
            _forward_num = [ZTools createLabelWithFrame:CGRectZero text:@"转发：1000次" textColor:GRAY_TEXT_COLOR textAlignment:NSTextAlignmentCenter font:13];
            [_background_view addSubview:_forward_num];
        }
        
        if (!_exposure_num) {
            _exposure_num = [ZTools createLabelWithFrame:CGRectZero text:@"曝光：1000000次" textColor:GRAY_TEXT_COLOR textAlignment:NSTextAlignmentCenter font:13];
            [_background_view addSubview:_exposure_num];
        }
        
        if (!_click_num) {
            _click_num = [ZTools createLabelWithFrame:CGRectZero text:@"点击：50000次" textColor:GRAY_TEXT_COLOR textAlignment:NSTextAlignmentCenter font:13];
            [_background_view addSubview:_click_num];
        }
        
        if (!_h_line_view) {
            _h_line_view = [[UIView alloc] init];
            _h_line_view.backgroundColor = RGBCOLOR(225, 225, 225);
            [_background_view addSubview:_h_line_view];
        }
        
        if (!_v_line_view1) {
            _v_line_view1 = [[UIView alloc] init];
            _v_line_view1.backgroundColor = RGBCOLOR(225, 225, 225);
            [_background_view addSubview:_v_line_view1];
        }
        
        if (!_v_line_view2) {
            _v_line_view2 = [[UIView alloc] init];
            _v_line_view2.backgroundColor = RGBCOLOR(225, 225, 225);
            [_background_view addSubview:_v_line_view2];
        }
        
                
        [self creareConstraints];
        
//        _forward_num.backgroundColor = [UIColor redColor];
//        _exposure_num.backgroundColor = [UIColor greenColor];
//        _click_num.backgroundColor = [UIColor yellowColor];
        
    }
    return self;
}

-(void)creareConstraints {
    __WeakSelf__ wself = self;
    [_background_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@6);
        make.right.equalTo(@(-6));
        make.top.equalTo(wself.contentView).offset(10.0f);
        make.bottom.equalTo(wself.contentView);
    }];
    
    float imageSize = [ZTools autoWidthWith:90];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@8);
        make.top.equalTo(@8);
        make.width.equalTo(@(imageSize));
        make.height.equalTo(@(imageSize));
    }];
    
    [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageView.mas_right).offset(10);
        make.top.equalTo(@8);
        make.right.equalTo(_tag_label.mas_left).offset(-5);
        make.height.equalTo(@33);
    }];
    
    [_date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.title_label.mas_left).offset(0);
        make.top.equalTo(wself.title_label.mas_bottom).offset(3.0f);
        make.right.equalTo(_tag_label.mas_left).offset(5);
        make.height.equalTo(@10);
    }];
    
    [_bonus_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.title_label.mas_left).offset(0);
        make.bottom.equalTo(wself.headerImageView.mas_bottom).offset(0.0f);
        make.right.equalTo(_tag_label.mas_left).offset(5);
        make.height.equalTo(@20);
    }];
    
    [_forward_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wself.headerImageView.mas_bottom).offset(0);
        make.right.equalTo(wself.background_view.mas_right).offset(-10.0f);
        make.width.equalTo(@([ZTools autoWidthWith:90]));
        make.height.equalTo(@30);
    }];
    
    [_tag_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@70);
        make.left.equalTo(wself.background_view.mas_right).offset(-35.0f);
        make.top.equalTo(wself.background_view.mas_top).offset(-35.0f);
    }];
    
    //转发 曝光 点击 宽度
    float width = (self.contentView.width-10-40)/3.0f;
    
    [_forward_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@(width));
        make.top.equalTo(wself.h_line_view.mas_bottom).offset(5.0f);
        make.bottom.equalTo(wself.background_view.mas_bottom).offset(-5.0f);
    }];
    
    [_exposure_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_forward_num.mas_right).offset(10.0f);
        make.right.equalTo(_click_num.mas_left).offset(-10.0f);
        make.top.equalTo(wself.h_line_view.mas_bottom).offset(5.0f);
        make.bottom.equalTo(wself.background_view.mas_bottom).offset(-5.0f);
    }];
    [_click_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.background_view.mas_right).offset(-10.0f);
        make.width.equalTo(@(width));
        make.top.equalTo(wself.h_line_view.mas_bottom).offset(5.0f);
        make.bottom.equalTo(wself.background_view.mas_bottom).offset(-5.0f);
    }];
    
    [_h_line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_forward_num.mas_left).offset(0.0f);
        make.right.equalTo(_click_num.mas_right).offset(0.0f);
        make.top.equalTo(wself.headerImageView.mas_bottom).offset(10.0f);
        make.height.equalTo(@0.5);
    }];
    
    [_v_line_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_forward_num.mas_right).offset(5.0f);
        make.width.equalTo(@0.5);
        make.top.equalTo(wself.h_line_view.mas_bottom).offset(3.0f);
        make.bottom.equalTo(wself.background_view.mas_bottom).offset(-3.0f);
    }];
    
    [_v_line_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.exposure_num.mas_right).offset(5.0f);
        make.width.equalTo(@0.5);
        make.top.equalTo(wself.h_line_view.mas_bottom).offset(3.0f);
        make.bottom.equalTo(wself.background_view.mas_bottom).offset(-3.0f);
    }];
    
}

-(void)setInfoWith:(RootTaskListModel *)model showTag:(BOOL)show WithShare:(RootForwardBlock)block{
    
    forward_block = block;
    [_headerImageView sd_cancelCurrentImageLoad];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.task_img] placeholderImage:[UIImage imageNamed:@"default_loading_small_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    _title_label.text = model.task_name;
    _date_label.text = [ZTools timeIntervalFromNowWithformateDate:model.online_time];
    
    NSString * money = [NSString stringWithFormat:@"总积分：%@",model.total_task];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:money];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(255, 149, 46) range:NSMakeRange(3,money.length-3)];
    [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:13] range:[money rangeOfString:@"总积分："]];
    _bonus_label.attributedText = str;

    if (model.task_status.intValue != 1) {
        [_forward_button setTitle:@"已结束" forState:UIControlStateNormal];
        _forward_button.backgroundColor = RGBCOLOR(251, 154, 155);
    }else{
        [_forward_button setTitle:@"分享得积分" forState:UIControlStateNormal];
        _forward_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    }

    _tag_label.text = model.column_name;
    
    //转发  曝光 点击
    NSString * forwardNumString = [NSString stringWithFormat:@"转发：%@次",model.forward_num];
    NSString * exposure_num_string = [NSString stringWithFormat:@"曝光：%@次",model.exposure_num];
    NSString * clickNumString = [NSString stringWithFormat:@"点击：%@次",model.click_num];
    _forward_num.text = forwardNumString;
    _exposure_num.text = exposure_num_string;
    _click_num.text = clickNumString;
    
    
//    _forward_num.attributedText = [ZTools labelTextFontWith:forwardNumString Color:GRAY_TEXT_COLOR Font:9 range:[forwardNumString rangeOfString:@"转发："]];
//    _exposure_num.attributedText = [ZTools labelTextFontWith:exposure_num_string Color:GRAY_TEXT_COLOR Font:9 range:[exposure_num_string rangeOfString:@"曝光："]];
//    _click_num.attributedText = [ZTools labelTextFontWith:clickNumString Color:GRAY_TEXT_COLOR Font:9 range:[clickNumString rangeOfString:@"点击："]];
    
    
    /*
    NSString * time = [ZTools timeIntervalFromNowWithformateDate:model.online_time];
    NSString * title = [NSString stringWithFormat:@"%@  %@",model.task_name,time];
    NSMutableAttributedString *title_str = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:time];
    [title_str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    [title_str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:12] range:range];
    _title_label.attributedText = title_str;
    
    
    CGSize title_size = [ZTools stringHeightWithFont:_title_label.font WithString:title WithWidth:_title_label.width];
    _title_label.height = title_size.height;
//    _title_label.text = model.task_name;
    _bonus_label.top = _title_label.bottom+10+_bonus_label.height > _system_label.top ?38:_title_label.bottom+10;
    
    NSString * money = [NSString stringWithFormat:@"总积分：%@",model.total_task];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:money];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(255, 149, 46) range:NSMakeRange(3,money.length-3)];
    [str addAttribute:NSFontAttributeName value:[ZTools returnaFontWith:12] range:[money rangeOfString:@"总积分："]];
    _bonus_label.attributedText = str;
    
    if (model.task_status.intValue != 1) {
        [_forward_button setTitle:@"已结束" forState:UIControlStateNormal];
        _forward_button.backgroundColor = RGBCOLOR(251, 154, 155);
    }else{
        [_forward_button setTitle:@"分享得积分" forState:UIControlStateNormal];
        _forward_button.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    }
    if (show) {
        _tag_label.hidden = NO;
        _tag_label.text = model.column_name;
    }else{
        _tag_label.text = @"";
        _tag_label.hidden = YES;
    }
    
//    _system_label.text = [NSString stringWithFormat:@"普通会员:%@积分/点击\n高级会员:%@积分/点击",model.task_price,model.gao_click_price];
     
     */
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
