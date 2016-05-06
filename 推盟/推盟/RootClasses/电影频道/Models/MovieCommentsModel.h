//
//  MovieCommentsModel.h
//  推盟
//
//  Created by joinus on 16/3/4.
//  Copyright © 2016年 joinus. All rights reserved.
//
/**
 *  影评数据
 */

#import "BaseModel.h"

@interface MovieCommentsModel : BaseModel


@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * createTime;
@property(nonatomic,strong)NSString * score;
@property(nonatomic,strong)NSString * msId;
@property(nonatomic,strong)NSString * headerImage;
@property(nonatomic,strong)NSString * userName;


@end




