//
//  TopicTableViewCell.m
//  推盟
//
//  Created by joinus on 16/3/4.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "TopicTableViewCell.h"

@interface TopicTableViewCell (){
    NSLayoutConstraint * equalHeight;
}

@end

@implementation TopicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_title_label) {
            _title_label = [ZTools createLabelWithFrame:CGRectMake(16, 16, DEVICE_WIDTH-32, 20) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:16];
            [self.contentView addSubview:_title_label];
        }
        
        if (!_content_label) {
            _content_label                  = [ZTools createLabelWithFrame:CGRectMake(16, _title_label.bottom+10, DEVICE_WIDTH-32, 0)
                                                                      text:@""
                                                                 textColor:RGBCOLOR(104, 104, 104)
                                                             textAlignment:NSTextAlignmentLeft
                                                                      font:13];
            _content_label.numberOfLines    = 0;
            [self.contentView addSubview:_content_label];
            
        }
        
        if (!_header_imageView) {
            _header_imageView                       = [[UIImageView alloc] initWithFrame:CGRectMake(16, _content_label.bottom+10, 30, 30)];
            _header_imageView.backgroundColor       = [UIColor redColor];
            _header_imageView.layer.masksToBounds   = YES;
            _header_imageView.layer.cornerRadius    = 30/2.0f;
            [self.contentView addSubview:_header_imageView];
            
        }
        
        if (!_user_name_label) {
            _user_name_label    = [ZTools createLabelWithFrame:CGRectMake(_header_imageView.right+5, _header_imageView.top, DEVICE_WIDTH-16-_header_imageView.right-5, _header_imageView.height)
                                                          text:@"weee20160801"
                                                     textColor:RGBCOLOR(106, 106, 106)
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:12];
            [self.contentView addSubview:_user_name_label];
        }
        
        
        [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
            make.right.equalTo(@-16);
            make.height.equalTo(@20);
        }];
        
        [_content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title_label.mas_bottom).offset(10.0f);
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.height.equalTo(@10);
        }];
        
        [_header_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content_label.mas_bottom).offset(10);
            make.left.equalTo(@16);
            make.width.height.equalTo(@30);
        }];

        [_user_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.height.equalTo(_header_imageView);
            make.left.equalTo(_header_imageView.mas_right).offset(5);
            make.right.equalTo(self.contentView).offset(-16);
        }];

    }
    
    return self;
}

-(void)setInfomationMovieTopicModel:(MovieTopicModel *)model{
    
    CGSize content_size     = [ZTools stringHeightWithFont:_content_label.font WithString:model.content WithWidth:DEVICE_WIDTH-32];
    _content_label.text     = model.content;
    _title_label.text       = model.title;
    
    [_content_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(content_size.height+5));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}


@end
