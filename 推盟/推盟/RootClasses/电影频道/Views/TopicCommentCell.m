//
//  TopicCommentCell.m
//  推盟
//
//  Created by joinus on 16/3/28.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "TopicCommentCell.h"

#define IMAGE_WIDTH 40
#define INDENT 15

@implementation TopicCommentCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_headerImageView) {
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INDENT, INDENT, IMAGE_WIDTH, IMAGE_WIDTH)];
            _headerImageView.layer.masksToBounds = YES;
            _headerImageView.layer.cornerRadius = IMAGE_WIDTH/2.0f;
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img5q.duitang.com/uploads/item/201501/26/20150126231940_YGGNT.png"] placeholderImage:nil];
            [self.contentView addSubview:_headerImageView];
        }
        
        if (!_userNameLabel) {
            
            _userNameLabel  = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right + 10, _headerImageView.top, DEVICE_WIDTH-_headerImageView.right-50, 18) text:@"出师未捷身先死" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            [self.contentView addSubview:_userNameLabel];
        }
        
        if (!_dateLabel) {
            _dateLabel = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right + 10, _userNameLabel.bottom+3, _userNameLabel.width, 15) text:@"2016-3-28" textColor:DEFAULT_BLACK_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            [self.contentView addSubview:_dateLabel];
        }
        
        if (!_contentLabel) {
            _contentLabel = [ZTools createLabelWithFrame:CGRectMake(INDENT, _headerImageView.bottom+5, DEVICE_WIDTH-INDENT*2, 0) text:@"2016-3-28" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:14];
            _contentLabel.numberOfLines = 0;
            [self.contentView addSubview:_contentLabel];
        }
        
        if (!_orginBackgroundView) {
            _orginBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(INDENT, _contentLabel.bottom+5, DEVICE_WIDTH-INDENT*2, 60)];
            _orginBackgroundView.image = [UIImage imageNamed:@"mTopicCommentOrginBackgroundImage"];
            _orginBackgroundView.clipsToBounds = YES;
            [self.contentView addSubview:_orginBackgroundView];
        }
        
        if (!_orginUserNameLabel) {
            _orginUserNameLabel = [ZTools createLabelWithFrame:CGRectMake(10, 10, _orginBackgroundView.width-10*2, 18) text:@"回复24楼 我的天哪:" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            [_orginBackgroundView addSubview:_orginUserNameLabel];
        }
        
        if (!_orginContentLabel) {
            _orginContentLabel = [ZTools createLabelWithFrame:CGRectMake(10, _orginUserNameLabel.bottom+5, _orginUserNameLabel.width, 16) text:@"其实很有诚意的，从入围奥斯卡的杭婵动画不拉不拉不拉" textColor:DEFAULT_GRAY_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:13];
            [_orginBackgroundView addSubview:_orginContentLabel];
        }
    }
    return self;
}


-(void)setInfomationWithTopicCommentModel:(MTopicCommentModel *)model{
    
    CGSize contentSize                  = [ZTools stringHeightWithFont:[ZTools returnaFontWith:14] WithString:model.content WithWidth:(DEVICE_WIDTH-30)];
    _contentLabel.height                = contentSize.height;
    _contentLabel.text                  = model.content;
    
    if (model.orginModel) {
        _orginBackgroundView.height     = 60;
        _orginBackgroundView.top        = _contentLabel.bottom+5;
        _orginUserNameLabel.text        = [NSString stringWithFormat:@"回复24楼 %@:",model.orginModel.name];
        _orginContentLabel.text         = model.orginModel.content;
    }else{
        _orginBackgroundView.height     = 0;
    }
    
}



@end
