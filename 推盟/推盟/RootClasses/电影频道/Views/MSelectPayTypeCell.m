//
//  MSelectPayTypeCell.m
//  推盟
//
//  Created by joinus on 16/3/17.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MSelectPayTypeCell.h"

@implementation MSelectPayTypeCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_headerImageView) {
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 30, 30)];
            [self.contentView addSubview:_headerImageView];
        }
        
        if (!_selectButton) {
            _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _selectButton.frame = CGRectMake(DEVICE_WIDTH-50, 15, 40, 40);
            [_selectButton setImage:[UIImage imageNamed:@"pay_unselected_image"] forState:UIControlStateNormal];
            [_selectButton setImage:[UIImage imageNamed:@"pay_selected_image"] forState:UIControlStateSelected];
            [_selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_selectButton];
        }
        
        if (!_titleLabel) {
            _titleLabel = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right + 20, 16, DEVICE_WIDTH-_headerImageView.right - _selectButton.width-15, 18) text:@"" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:15];
            [self.contentView addSubview:_titleLabel];
        }
        
        if (!_subTitleLabel) {
            _subTitleLabel = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right + 20, _titleLabel.bottom+10, DEVICE_WIDTH-_headerImageView.right - _selectButton.width-15, 18) text:@"" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:12];
            [self.contentView addSubview:_subTitleLabel];
        }
        
    }
    
    return self;
}


-(void)selectButtonClicked:(UIButton *)button{
    if (!button.selected) {
        button.selected = YES;
        selectPayTypeBlock(button,self);
    }
}

-(void)selectedBlock:(mSelectPayTypeCellBlock)block{
    selectPayTypeBlock = block;
}












@end
