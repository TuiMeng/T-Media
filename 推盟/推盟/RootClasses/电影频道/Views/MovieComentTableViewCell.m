//
//  MovieComentTableViewCell.m
//  推盟
//
//  Created by joinus on 16/3/4.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MovieComentTableViewCell.h"

@implementation MovieComentTableViewCell

- (void)awakeFromNib {
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_starRatingView) {
            _starRatingView = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(15, 15) numberOfStars:5 rating:4.5 fillColor:STAR_FILL_COLOR unfilledColor:STAR_UNFILL_COLOR strokeColor:[UIColor clearColor]];
            _starRatingView.padding = 1;
            _starRatingView.top = 16;
            _starRatingView.left = 16;
            [self.contentView addSubview:_starRatingView];
        }
        
        if (!_date_label) {
            _date_label = [ZTools createLabelWithFrame:CGRectMake(_starRatingView.right+5, 16, DEVICE_WIDTH-_starRatingView.right-5-16, _starRatingView.height) text:@"2016-3-4" textColor:RGBCOLOR(127, 127, 127) textAlignment:NSTextAlignmentLeft font:10];
            [self.contentView addSubview:_date_label];
        }
        
        if (!_content_label) {
            _content_label = [ZTools createLabelWithFrame:CGRectMake(16, _starRatingView.bottom+10, DEVICE_WIDTH-32, 0) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:15];
            _content_label.numberOfLines = 0;
            [self.contentView addSubview:_content_label];
        }
        
        if (!_header_imageView) {
            _header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, _content_label.bottom+10, 30, 30)];
            _header_imageView.backgroundColor = [UIColor redColor];
            _header_imageView.layer.masksToBounds = YES;
            _header_imageView.layer.cornerRadius = _header_imageView.width/2.0f;
            [self.contentView addSubview:_header_imageView];
        }
        
        if (!_user_name_label) {
            _user_name_label = [ZTools createLabelWithFrame:CGRectMake(_header_imageView.right+5, _header_imageView.top, DEVICE_WIDTH-16-_header_imageView.right-5, _header_imageView.height) text:@"" textColor:RGBCOLOR(106, 106, 106) textAlignment:NSTextAlignmentLeft font:12];
            [self.contentView addSubview:_user_name_label];
        }
    }
    
    return self;
}

-(void)setInfomationWithMovieCommentsModel:(MovieCommentsModel *)model{
    
    CGSize content_size     = [ZTools stringHeightWithFont:_content_label.font
                                                WithString:model.content
                                                 WithWidth:_content_label.width];
    _content_label.height   = content_size.height;
    _content_label.text     = model.content;
    _header_imageView.top   = _content_label.bottom+10;
    _user_name_label.top    = _header_imageView.top;
    
    _starRatingView.rating  = model.score.intValue/2.0f;
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.headerImage] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_SMALL_IMAGE]];
    _user_name_label.text   = model.userName;
    _date_label.text        = model.createTime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
