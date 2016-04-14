//
//  RankingTableViewCell.h
//  推盟
//
//  Created by joinus on 15/8/25.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"

@interface RankingTableViewCell : UITableViewCell

/**
 *  排名
 */
@property(nonatomic,strong)UILabel * ranging_label;
/**
 *  排名前三
 */
@property(nonatomic,strong)UIImageView * ranging_imageView;
/**
 *  用户名
 */
@property(nonatomic,strong)UILabel * user_name_label;
/**
 *  电话号码
 */
@property(nonatomic,strong)UILabel * phone_num_label;
/**
 *  总收入
 */
@property(nonatomic,strong)UILabel * total_money_label;



-(void)setInfomationWith:(RankingModel*)model;

@end
