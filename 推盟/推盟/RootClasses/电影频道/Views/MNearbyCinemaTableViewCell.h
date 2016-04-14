//
//  MNearbyCinemaTableViewCell.h
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLocationCinemasModel.h"

@interface MNearbyCinemaTableViewCell : UITableViewCell


@property(nonatomic,strong)UILabel * cinema_name_label;

@property(nonatomic,strong)UILabel * address_label;

@property(nonatomic,strong)DJWStarRatingView * starRatingView;

@property(nonatomic,strong)UILabel * price_label;

@property(nonatomic,strong)UILabel * play_time_label;

@property(nonatomic,strong)UILabel * distance_label;



-(void)setInfomationWithCinemasModel:(MLocationCinemasModel*)model;


@end
