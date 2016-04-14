//
//  CinemaCommentCell.m
//  推盟
//
//  Created by joinus on 16/3/18.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "CinemaCommentCell.h"

#define HEADER_WIDTH 36
#define STAR_SIZE   CGSizeMake(13, 13)

@implementation CinemaCommentCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_headerImageView) {
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, HEADER_WIDTH, HEADER_WIDTH)];
            _headerImageView.layer.masksToBounds = YES;
            _headerImageView.layer.cornerRadius = HEADER_WIDTH/2.0f;
            _headerImageView.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:_headerImageView];
        }
        
        if (!_userNameLabel) {
            _userNameLabel = [ZTools createLabelWithFrame:CGRectMake(_headerImageView.right + 11, 15, DEVICE_WIDTH - _headerImageView.right - 30, 16) text:@"owen20150801" textColor:RGBCOLOR(109, 109, 109) textAlignment:NSTextAlignmentLeft font:13];
            [self.contentView addSubview:_userNameLabel];
        }
        
        if (!_starRatingView) {
            _starRatingView = [[DJWStarRatingView alloc] initWithStarSize:STAR_SIZE numberOfStars:5 rating:1 fillColor:STAR_FILL_COLOR unfilledColor:STAR_UNFILL_COLOR strokeColor:STAR_STROKE_COLOR];
            _starRatingView.top = _userNameLabel.bottom + 5;
            _starRatingView.left = _userNameLabel.left - _starRatingView.padding;
            [self.contentView addSubview:_starRatingView];
        }
        
        if (!_dateLabel) {
            _dateLabel = [ZTools createLabelWithFrame:CGRectMake(_starRatingView.right+5, _starRatingView.top, DEVICE_WIDTH-_starRatingView.width-20, _starRatingView.height) text:@"02-13 15:31" textColor:RGBCOLOR(181, 181, 181) textAlignment:NSTextAlignmentLeft font:11];
            [self.contentView addSubview:_dateLabel];
        }
        
        if (!_contentLabel) {
            _contentLabel = [ZTools createLabelWithFrame:CGRectMake(_userNameLabel.left, _starRatingView.bottom+10, _userNameLabel.width, 0) text:@"" textColor:RGBCOLOR(57, 57, 57) textAlignment:NSTextAlignmentLeft font:14];
            _contentLabel.numberOfLines = 0;
            [self.contentView addSubview:_contentLabel];
        }
    }
    
    return self;
}


-(void)setInfomationWithCinemaCommentModel:(CinemaCommentModel *)model{
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.userImage] placeholderImage:nil];
    _userNameLabel.text = model.userName;
    _starRatingView.rating = [model.score floatValue]/2.0f;
    _dateLabel.text = model.date;
    
    CGSize contentSize = [ZTools stringHeightWithFont:_contentLabel.font WithString:model.content WithWidth:_contentLabel.width];
    _contentLabel.height = contentSize.height;
    _contentLabel.text = model.content;
}



@end












