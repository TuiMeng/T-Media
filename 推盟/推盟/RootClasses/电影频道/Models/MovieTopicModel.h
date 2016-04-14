//
//  MovieTopicModel.h
//  推盟
//
//  Created by joinus on 16/3/4.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  话题数据
 */

#import "BaseModel.h"

@interface MovieTopicModel : BaseModel


@property(nonatomic,strong)NSString         * title;
@property(nonatomic,strong)NSString         * content;
@property(nonatomic,strong)NSMutableArray   * images;

@end
