//
//  CinemaCommentCell.h
//  推盟
//
//  Created by joinus on 16/3/18.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaCommentModel.h"

@interface CinemaCommentCell : UITableViewCell




@property(nonatomic,strong)UIImageView * headerImageView;

@property(nonatomic,strong)UILabel * userNameLabel;

@property(nonatomic,strong)DJWStarRatingView * starRatingView;

@property(nonatomic,strong)UILabel * dateLabel;

@property(nonatomic,strong)UILabel * contentLabel;


-(void)setInfomationWithCinemaCommentModel:(CinemaCommentModel *)model;


@end
