//
//  RootMovieTableViewCell.m
//  推盟
//
//  Created by joinus on 16/3/2.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "RootMovieTableViewCell.h"

@implementation RootMovieTableViewCell

- (void)awakeFromNib {
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_background_view) {
            _background_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100)];
            _background_view.backgroundColor = [UIColor whiteColor];
            _background_view.layer.borderColor = RGBCOLOR(230, 231, 233).CGColor;
            _background_view.layer.borderWidth = 0.5;
            [self.contentView addSubview:_background_view];
        }
        
        if (!_m_header_imageView) {
            _m_header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, IMAGE_WIDTH, IMAGE_HEIGHT)];
            [_background_view addSubview:_m_header_imageView];
        }
        
        if (!_m_name_label) {
            _m_name_label = [ZTools createLabelWithFrame:CGRectMake(_m_header_imageView.right+10, 10, 200, 30)
                                                    text:@""
                                               textColor:RGBCOLOR(31, 31, 31)
                                           textAlignment:NSTextAlignmentLeft
                                                    font:15];
            [_background_view addSubview:_m_name_label];
        }
        
        if (!_m_type_label) {
            _m_type_label = [ZTools createLabelWithFrame:CGRectMake(_m_name_label.right+5, 10, 20, 12)
                                                    text:@""
                                               textColor:[UIColor whiteColor]
                                           textAlignment:NSTextAlignmentCenter
                                                    font:8];
            _m_type_label.backgroundColor = RGBCOLOR(0, 183, 238);
            _m_type_label.center = CGPointMake(_m_type_label.center.x, _m_name_label.center.y);
            [_background_view addSubview:_m_type_label];
        }
        
        if (!_m_score_label) {
            _m_score_label = [ZTools createLabelWithFrame:CGRectMake(_background_view.width-45, 15, 35, 20)
                                                     text:@""
                                                textColor:RED_BACKGROUND_COLOR
                                            textAlignment:NSTextAlignmentRight
                                                     font:12];
            [_background_view addSubview:_m_score_label];
        }
        
        if (!_m_ticket_button) {
            _m_ticket_button = [ZTools createButtonWithFrame:CGRectMake(_background_view.width-50, _m_score_label.bottom+20, 40, 25)
                                                       title:@"购票"
                                                       image:nil];
            _m_ticket_button.layer.cornerRadius = 3;
            _m_ticket_button.titleLabel.font = [ZTools returnaFontWith:12];
            [_m_ticket_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _m_ticket_button.backgroundColor = RED_BACKGROUND_COLOR;
            [_m_ticket_button addTarget:self action:@selector(buyTicketButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_background_view addSubview:_m_ticket_button];
        }
        
        if (!_m_introduction_label) {
            _m_introduction_label = [ZTools createLabelWithFrame:CGRectMake(_m_header_imageView.right+10, _m_name_label.bottom+10, _background_view.width-80-_m_ticket_button.width-20, 30)
                                                            text:@""
                                                       textColor:RGBCOLOR(125, 125, 125)
                                                   textAlignment:NSTextAlignmentLeft
                                                            font:12];
            _m_introduction_label.numberOfLines = 0;
            [_background_view addSubview:_m_introduction_label];
        }
        
        if (!_first_line_view) {
            _first_line_view = [[UIImageView alloc] initWithFrame:CGRectMake(_m_header_imageView.right+10, _m_header_imageView.bottom, _background_view.width-80-10, 0.5)];
            _first_line_view.image = [UIImage imageNamed:@"root_line_view"];
            [_background_view addSubview:_first_line_view];
        }
        
        if (!_m_rewardw_content_label) {
            _m_rewardw_content_label                        = [ZTools createLabelWithFrame:CGRectMake(_m_header_imageView.right+10, _first_line_view.bottom+5, _background_view.width-10-80, 30)
                                                                                      text:@""
                                                                                 textColor:TOPIC_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:11];
            _m_rewardw_content_label.numberOfLines          = 0;
            _m_rewardw_content_label.userInteractionEnabled = YES;
            [_background_view addSubview:_m_rewardw_content_label];
            
            UITapGestureRecognizer * rewardTap               = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rewardTap:)];
            [_m_topic_content_label addGestureRecognizer:rewardTap];
        }
        
        if (!_m_rewardw_label) {
            _m_rewardw_label = [ZTools createLabelWithFrame:CGRectMake(0, 0, 47/2.0f, 27/2.0f) text:@"悬赏" textColor:MARK_COLOR textAlignment:NSTextAlignmentCenter font:9];
            _m_rewardw_label.layer.masksToBounds = YES;
            _m_rewardw_label.layer.borderColor = _m_rewardw_label.textColor.CGColor;
            _m_rewardw_label.layer.borderWidth = 0.5;
            _m_rewardw_label.layer.cornerRadius = 3;
            _m_rewardw_label.center = CGPointMake(0, _m_rewardw_content_label.center.y);
            _m_rewardw_label.right = _m_header_imageView.right;
            [_background_view addSubview:_m_rewardw_label];
        }
        
        if (!_second_line_view) {
            _second_line_view = [[UIImageView alloc] initWithFrame:CGRectMake(_m_header_imageView.right+10, _m_rewardw_label.bottom+10, _background_view.width-80-10, 0.5)];
            _second_line_view.image = [UIImage imageNamed:@"root_line_view"];
            [_background_view addSubview:_second_line_view];
        }
        
        if (!_m_topic_content_label) {
            _m_topic_content_label                          = [ZTools createLabelWithFrame:CGRectMake(_m_header_imageView.right+10, _second_line_view.bottom+5, _background_view.width-10-80, 30) text:@"" textColor:TOPIC_TEXT_COLOR textAlignment:NSTextAlignmentLeft font:11];
            _m_topic_content_label.numberOfLines            = 0;
            _m_topic_content_label.userInteractionEnabled   = YES;
            [_background_view addSubview:_m_topic_content_label];
            
            UITapGestureRecognizer * topicTap               = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTap:)];
            [_m_topic_content_label addGestureRecognizer:topicTap];
        }
        
        if (!_m_topic_label) {
            _m_topic_label = [ZTools createLabelWithFrame:CGRectMake(0, 0, 47/2.0f, 27/2.0f) text:@"话题" textColor:MARK_COLOR textAlignment:NSTextAlignmentCenter font:9];
            _m_topic_label.layer.masksToBounds = YES;
            _m_topic_label.layer.borderColor = _m_topic_label.textColor.CGColor;
            _m_topic_label.layer.borderWidth = 0.5;
            _m_topic_label.layer.cornerRadius = 3;
            _m_topic_label.center = CGPointMake(0, _m_topic_content_label.center.y);
            _m_topic_label.right = _m_header_imageView.right;
            [_background_view addSubview:_m_topic_label];
        }
    }
    return self;
}

-(void)setInfomationWithMovieListModel:(MovieListModel *)model{
    
    _m_score_label.text = [NSString stringWithFormat:@"%@分",model.movieScore];
    _m_name_label.text  = model.movieName;
    _m_type_label.text  = model.dimensional;
    
    CGSize type_size                        = [ZTools stringHeightWithFont:_m_type_label.font WithString:model.dimensional.length?model.dimensional:@"" WithWidth:_m_type_label.width];
    
    float max_name_width                    = _m_score_label.left - _m_header_imageView.right - type_size.width - 20;
    
    CGSize name_size                        = [ZTools stringHeightWithFont:_m_name_label.font WithString:model.movieName WithWidth:max_name_width];
    
    if (name_size.width < max_name_width) {
        max_name_width = name_size.width;
    }
    _m_name_label.width                     = max_name_width;
    _m_type_label.left                      = _m_name_label.right + 3;
    _m_type_label.width                     = model.dimensional.length?(type_size.width+5):0;
    
    
    [_m_header_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_MOVIE_IMAGE_URL,model.moviePick]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_SMALL_IMAGE]];
    _m_introduction_label.text              = model.movieStarring;
    
    _first_line_view.hidden                 = model.reward.length?NO:YES;
    _m_rewardw_content_label.hidden         = model.reward.length?NO:YES;
    _m_rewardw_label.hidden                 = model.reward.length?NO:YES;
    _m_rewardw_content_label.text           = model.reward;
    
    _second_line_view.hidden                = model.topic.length?NO:YES;
    _second_line_view.top                   = model.reward.length?_second_line_view.top:_first_line_view.top;
    _m_topic_label.hidden                   = model.topic.length?NO:YES;
    _m_topic_label.top                      = model.reward.length?_m_topic_label.top:_m_rewardw_label.top;
    _m_topic_content_label.top              = model.reward.length?_m_topic_content_label.top:_m_rewardw_content_label.top;
    _m_topic_content_label.text             = model.topic;
    
    _background_view.height                 = 100 + (model.reward.length?30:0) + (model.topic.length?30:0);
}

-(void)buyTicketButtonClicked:(UIButton*)button{
    buy_ticket_block(@"");
}

-(void)setBuyTicketClickedBlock:(RootBuyTicketBlock)block{
    buy_ticket_block = block;
}

-(void)setTopicOrRewardwTap:(RootTopicOrRewardwClickedBlock)block{
    topicOrRewardwBlock = block;
}

-(void)rewardTap:(UITapGestureRecognizer *)sender{
    topicOrRewardwBlock(1);
}
-(void)topicTap:(UITapGestureRecognizer *)sender{
    topicOrRewardwBlock(2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
