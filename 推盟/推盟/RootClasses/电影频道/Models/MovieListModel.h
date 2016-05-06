//
//  MovieListModel.h
//  推盟
//
//  Created by joinus on 16/3/2.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface MovieListModel : BaseModel

/**
 *  电影名称
 */
@property(nonatomic,strong)NSString * movieName;
/**
 *  电影时长
 */
@property(nonatomic,strong)NSString * duration;
/**
 *  电影id
 */
@property(nonatomic,strong)NSString * movieId;
/**
 *  上映日期
 */
@property(nonatomic,strong)NSString * releaseDate;
/**
 *  电影头图大图
 */
@property(nonatomic,strong)NSString * movieImage;
/**
 *  主演
 */
@property(nonatomic,strong)NSString * movieStarring;
/**
 *  上映类型（1-热映电影 2-即将上映。当查询全部时，则带有此项）
 */
@property(nonatomic,strong)NSString * showType;
/**
 *  电影头图小图
 */
@property(nonatomic,strong)NSString * moviePick;
/**
 *  悬赏
 */
@property(nonatomic,strong)NSString * reward;
/**
 *  话题
 */
@property(nonatomic,strong)NSString * topic;
/**
 *  电影评分
 */
@property(nonatomic,strong)NSString * movieScore;
/**
 *  影片标签（2D，3D）
 */
@property(nonatomic,strong)NSString * dimensional;

@end








