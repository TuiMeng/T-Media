//
//  MovieSelectSeatViewController.h
//  推盟
//
//  Created by joinus on 16/3/10.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  选座
 */

#import "MyViewController.h"
#import "MovieSequencesModel.h"
#import "MLocationCinemasModel.h"
#import "MovieListModel.h"

@interface MovieSelectSeatViewController : MyViewController

@property(nonatomic,strong)MovieSequencesModel * sequenceModel;

@property(nonatomic,strong)MLocationCinemasModel * cinema_model;

@property(nonatomic,strong)MovieListModel * movie_model;


@end
