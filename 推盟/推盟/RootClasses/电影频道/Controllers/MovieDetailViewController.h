//
//  MovieDetailViewController.h
//  推盟
//
//  Created by joinus on 16/3/3.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MyViewController.h"
#import "MovieListModel.h"

@interface MovieDetailViewController : MyViewController


@property(nonatomic,strong)NSString * movie_id;

@property(nonatomic,strong)MovieListModel * movie_list_model;

@end
