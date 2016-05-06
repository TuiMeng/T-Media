//
//  GiftListCell.m
//  推盟
//
//  Created by joinus on 15/8/17.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "GiftListCell.h"

@interface GiftListCell ()


/**
 *  左礼品名称
 */
@property (weak, nonatomic) IBOutlet SLabel *title_label1;
/**
 *  左 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *header_imageView1;
/**
 *  左 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *price_label1;
/**
 *  右礼品名称
 */
@property (weak, nonatomic) IBOutlet SLabel *title_label2;
/**
 *  右图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *header_imageView2;
/**
 *  右  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *price_label2;
/**
 *  左边视图
 */
@property (weak, nonatomic) IBOutlet UIView *left_view;
/**
 *  右边视图
 */
@property (weak, nonatomic) IBOutlet UIView *right_view;
/**
 *  中间分割线
 */
@property (weak, nonatomic) IBOutlet UIView *line_view;


@end

@implementation GiftListCell

- (void)awakeFromNib {
    _title_label1.adjustsFontSizeToFitWidth = YES;
    _title_label2.adjustsFontSizeToFitWidth = YES;
    _title_label1.numberOfLines = 0;
    _title_label2.numberOfLines = 0;
    
    _title_label1.font = [ZTools returnaFontWith:15];
    _title_label2.font = [ZTools returnaFontWith:15];
    _price_label1.font = [ZTools returnaFontWith:16];
    _price_label2.font = [ZTools returnaFontWith:16];
    
    _title_label1.verticalAlignment = VerticalAlignmentMiddle;
    _title_label2.verticalAlignment = VerticalAlignmentMiddle;
    
    UITapGestureRecognizer * left_view_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTap:)];
    [_left_view addGestureRecognizer:left_view_tap];
    
    UITapGestureRecognizer * right_view_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTap:)];
    [_right_view addGestureRecognizer:right_view_tap];
}

-(void)leftViewTap:(UITapGestureRecognizer*)sender{
    left_block();
}
-(void)rightViewTap:(UITapGestureRecognizer *)sender{
    right_block();
}

-(void)leftClicked:(GiftListLeftTapBlock)l_block rightClicked:(GiftListRightTapBlock)r_block{
    left_block = l_block;
    right_block = r_block;
}

-(void)setGiftOneWith:(GiftListModel *)model1 TwoWith:(GiftListModel *)model2{
    _title_label1.text = model1.gift_name;
    [_header_imageView1 sd_setImageWithURL:[NSURL URLWithString:model1.gift_image_small] placeholderImage:[UIImage imageNamed:@"default_loading_small_image"]];
    
    NSString * _priceString1 = [NSString stringWithFormat:@"%@积分",model1.price];
    _price_label1.attributedText = [ZTools labelTextFontWith:_priceString1 Color:DEFAULT_ORANGE_TEXT_COLOR Font:12 range:[_priceString1 rangeOfString:@"积分"]];
    
    if (!model2) {
        _line_view.hidden = YES;
        _right_view.hidden = YES;
        return;
    }else{
        _right_view.hidden = NO;
    }
    
    NSString * _priceString2 = [NSString stringWithFormat:@"%@积分",model2.price];
    _title_label2.text = model2.gift_name;
    [_header_imageView2 sd_setImageWithURL:[NSURL URLWithString:model2.gift_image_small] placeholderImage:[UIImage imageNamed:@"default_loading_small_image"]];
    _price_label2.attributedText = [ZTools labelTextFontWith:_priceString2 Color:DEFAULT_ORANGE_TEXT_COLOR Font:12 range:[_priceString2 rangeOfString:@"积分"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
