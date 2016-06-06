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
            _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 125)];
            _backView.backgroundColor = RGBCOLOR(237, 237, 237);
            [self.contentView addSubview:_backView];
        }
        
        if (!_imageV) {
            _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, DEVICE_WIDTH, 114)];
            _imageV.backgroundColor = [UIColor greenColor];
            [_backView addSubview:_imageV];
        }
        
        if (!_titleView) {
            _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.height-20, DEVICE_WIDTH, 20)];
            _titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            [_backView addSubview:_titleView];
        }
        
        if (!_titleLabel) {
            _titleLabel = [ZTools createLabelWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-120, 20) text:@"爱奇艺黄金会员" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:15];
            [_titleView addSubview:_titleLabel];
        }
        
        if (!_restLabel) {
            _restLabel = [ZTools createLabelWithFrame:CGRectMake(_titleLabel.right + 10, 0, DEVICE_WIDTH-_titleLabel.right-20, 20) text:@"剩余：50/100" textColor:DEFAULT_RED_TEXT_COLOR textAlignment:NSTextAlignmentRight font:14];
            [_titleView addSubview:_restLabel];
        }
        
    }
    return self;
}

-(void)setInfomationWithPrizeModel:(PrizeModel *)model{
    
}






@end
