//
//  RootMovieTableViewCell.h
//  推盟
//
//  Created by joinus on 16/3/2.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieListModel.h"

#define IMAGE_WIDTH 60
#define IMAGE_HEIGHT 80


//颜色
#define RED_BACKGROUND_COLOR RGBCOLOR(251, 75, 78)
//黑色字体
#define BLACK_TEXT_COLOR RGBCOLOR(31, 31, 31)
//话题、悬赏字体颜色
#define TOPIC_TEXT_COLOR RGBCOLOR(76,76,76)
//标签颜色
#define MARK_COLOR RGBCOLOR(248,181,81)

typedef void(^RootBuyTicketBlock)(NSString * obj);
//话题或悬赏点击(1:悬赏，2：话题)
typedef void(^RootTopicOrRewardwClickedBlock)(int type);


@interface RootMovieTableViewCell : STableViewCell{
    RootBuyTicketBlock              buy_ticket_block;
    RootTopicOrRewardwClickedBlock  topicOrRewardwBlock;
}

@property(nonatomic,strong)UIView * background_view;
/**
 *  头图
 */
@property(nonatomic,strong)UIImageView * m_header_imageView;
/**
 *  电影片名
 */
@property(nonatomic,strong)UILabel * m_name_label;
/**
 *  电影类型（2D 3D）
 */
@property(nonatomic,strong)UILabel * m_type_label;
/**
 *  影片介绍
 */
@property(nonatomic,strong)UILabel * m_introduction_label;
/**
 *  评分
 */
@property(nonatomic,strong)UILabel * m_score_label;
/**
 *  购票按钮
 */
@property(nonatomic,strong)UIButton * m_ticket_button;
/**
 *  悬赏提示
 */
@property(nonatomic,strong)UILabel * m_rewardw_label;
/**
 *  话题提示
 */
@property(nonatomic,strong)UILabel * m_topic_label;
/**
 *  悬赏内容
 */
@property(nonatomic,strong)UILabel * m_rewardw_content_label;
/**
 *  头图
 */
@property(nonatomic,strong)UILabel * m_topic_content_label;
/**
 *  悬赏分割线
 */
@property(nonatomic,strong)UIImageView * first_line_view;
/**
 *  话题分割线
 */
@property(nonatomic,strong)UIImageView * second_line_view;


-(void)setInfomationWithMovieListModel:(MovieListModel*)model;

-(void)setBuyTicketClickedBlock:(RootBuyTicketBlock)block;

-(void)setTopicOrRewardwTap:(RootTopicOrRewardwClickedBlock)block;

@end
