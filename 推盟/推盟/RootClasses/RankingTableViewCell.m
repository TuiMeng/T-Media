//
//  RankingTableViewCell.m
//  推盟
//
//  Created by joinus on 15/8/25.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "RankingTableViewCell.h"

@implementation RankingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_ranging_label) {
            _ranging_label = [self createLabelWithFrame:CGRectMake((DEVICE_WIDTH/4.0f-20)/2,5,20,34)];
        }
        if (!_ranging_imageView) {
            _ranging_imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH/4.0f-20)/2,5,20,34)];
            [self.contentView addSubview:_ranging_imageView];
        }
        
        if (!_user_name_label) {
            _user_name_label = [self createLabelWithFrame:CGRectMake(DEVICE_WIDTH/4.0 + 5,5,DEVICE_WIDTH/4.0f-10,34)];
        }
        if (!_phone_num_label) {
            _phone_num_label = [self createLabelWithFrame:CGRectMake(DEVICE_WIDTH/4.0*2 + 5,5,DEVICE_WIDTH/4.0f-10,34)];
        }
        if (!_total_money_label) {
            _total_money_label = [self createLabelWithFrame:CGRectMake(DEVICE_WIDTH/4.0*3 + 5,5,DEVICE_WIDTH/4.0f-10,34)];
        }
    }
    return self;
}

-(void)setInfomationWith:(RankingModel *)model{
    if (model.num.intValue == 1) {
        _ranging_imageView.image = [UIImage imageNamed:@"root_golden_image"];
        _ranging_label.text = @"";
        _user_name_label.textColor = RGBCOLOR(255, 0, 61);
        _phone_num_label.textColor = RGBCOLOR(255, 0, 61);
        _total_money_label.textColor = RGBCOLOR(255, 0, 61);
    }else if (model.num.intValue == 2){
        _ranging_imageView.image = [UIImage imageNamed:@"root_silver_image"];
        _ranging_label.text = @"";
        _user_name_label.textColor = RGBCOLOR(12,129,208);
        _phone_num_label.textColor = RGBCOLOR(12,129,208);
        _total_money_label.textColor = RGBCOLOR(12,129,208);
    }else if (model.num.intValue == 3){
        _ranging_imageView.image = [UIImage imageNamed:@"root_copper_image"];
        _ranging_label.text = @"";
        _user_name_label.textColor = RGBCOLOR(6, 145, 123);
        _phone_num_label.textColor = RGBCOLOR(6, 145, 123);
        _total_money_label.textColor = RGBCOLOR(6, 145, 123);
    }else{
        _ranging_imageView.image = nil;
        _ranging_label.text = [NSString stringWithFormat:@"%@",model.num];
        _user_name_label.textColor = RGBCOLOR(42, 42, 42);
        _phone_num_label.textColor = RGBCOLOR(42, 42, 42);
        _total_money_label.textColor = RGBCOLOR(42, 42, 42);
    }
    
    _user_name_label.text = model.user_name;
    _total_money_label.text = [NSString stringWithFormat:@"￥%@",model.all_money];
    _phone_num_label.text = [ZTools returnEncryptionMobileNumWith:model.user_mobile];
}

-(UILabel*)createLabelWithFrame:(CGRect)frame{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [ZTools returnaFontWith:12];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = RGBCOLOR(42, 42, 42);
    [self.contentView addSubview:label];
    return label;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
