//
//  TopicTableViewCell.h
//  推盟
//
//  Created by joinus on 16/3/4.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  话题
 */

#import <UIKit/UIKit.h>
#import "MovieTopicModel.h"

@interface TopicTableViewCell : UITableViewCell{
    
}

@property(nonatomic,strong)UILabel * title_label;
@property(nonatomic,strong)UILabel * content_label;
@property(nonatomic,strong)UIImageView * header_imageView;
@property(nonatomic,strong)UILabel * user_name_label;



-(void)setInfomationMovieTopicModel:(MovieTopicModel*)model;


@end
