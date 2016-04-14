//
//  TopicCommentCell.h
//  推盟
//
//  Created by joinus on 16/3/28.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  话题评论
 */

#import <UIKit/UIKit.h>
#import "MTopicCommentModel.h"


@interface TopicCommentCell : UITableViewCell


@property(nonatomic,strong)UIImageView  * headerImageView;
@property(nonatomic,strong)UILabel      * userNameLabel;
@property(nonatomic,strong)UILabel      * dateLabel;
@property(nonatomic,strong)UILabel      * contentLabel;

@property(nonatomic,strong)UIImageView  * orginBackgroundView;
@property(nonatomic,strong)UILabel      * orginUserNameLabel;
@property(nonatomic,strong)UILabel      * orginContentLabel;



-(void)setInfomationWithTopicCommentModel:(MTopicCommentModel *)model;



@end
