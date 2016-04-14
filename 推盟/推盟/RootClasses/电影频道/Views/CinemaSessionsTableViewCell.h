//
//  CinemaSessionsTableViewCell.h
//  推盟
//
//  Created by joinus on 16/3/8.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  影院场次安排
 */

#import <UIKit/UIKit.h>
#import "MovieSequencesModel.h"

typedef void(^CinemaSessionTableViewCellBlock)(id obj);

@interface CinemaSessionsTableViewCell : UITableViewCell{
    CinemaSessionTableViewCellBlock cell_block;
}



@property(nonatomic,strong)UILabel * start_time_label;

@property(nonatomic,strong)UILabel * end_time_label;

@property(nonatomic,strong)UILabel * language_label;

@property(nonatomic,strong)UILabel * address_label;

@property(nonatomic,strong)UILabel * price_label;

@property(nonatomic,strong)UIButton * selected_seat_button;


-(void)selectSeatBlock:(CinemaSessionTableViewCellBlock)block;

-(void)setInfomationWithMovieSequencesModel:(MovieSequencesModel *)model;

@end
