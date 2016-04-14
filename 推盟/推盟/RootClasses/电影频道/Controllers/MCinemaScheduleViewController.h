//
//  MCinemaScheduleViewController.h
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  影院电影排期
 */

#import "MyViewController.h"
#import "MLocationCinemasModel.h"
#import "MovieListModel.h"

@interface MCinemaScheduleViewController : MyViewController


@property(nonatomic,strong)MLocationCinemasModel * cinema_model;

@property(nonatomic,strong)MovieListModel * movie_model;

@end
