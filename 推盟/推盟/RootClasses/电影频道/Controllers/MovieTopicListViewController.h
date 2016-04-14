//
//  MovieTopicViewController.h
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  话题列表界面
 */

#import "MyViewController.h"
#import "MovieTopicModel.h"
#import "MovieListModel.h"

@interface MovieTopicListViewController : MyViewController

@property(nonatomic,strong)MovieTopicModel  * topicModel;
@property(nonatomic,strong)MovieListModel   * movieListModel;

@end
