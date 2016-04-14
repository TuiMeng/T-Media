//
//  MovieModel.h
//  推盟
//
//  Created by joinus on 16/3/3.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface MovieModel : BaseModel
/**
 *  片名
 */
@property(nonatomic,strong)NSString * movieName;
/**
 *  国家
 */
@property(nonatomic,strong)NSString * movieCountry;
/**
 *  人数
 */
@property(nonatomic,strong)NSString * scoreNum;
/**
 *  时长
 */
@property(nonatomic,strong)NSString * duration;
/**
 *  类型
 */
@property(nonatomic,strong)NSString * movieClass;
/**
 *  上映日期
 */
@property(nonatomic,strong)NSString * releaseDate;
/**
 *  导演
 */
@property(nonatomic,strong)NSString * movieD;
/**
 *  评分
 */
@property(nonatomic,strong)NSString * score;
/**
 *  主演
 */
@property(nonatomic,strong)NSString * movieStarring;
/**
 *  图片
 */
@property(nonatomic,strong)NSString * movieImage;
/**
 *  简介
 */
@property(nonatomic,strong)NSString * movieStory;
/**
 *  出品公司
 */
@property(nonatomic,strong)NSString * proCompany;






@end
