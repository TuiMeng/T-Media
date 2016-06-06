//
//  PrizeModel.h
//  推盟
//
//  Created by joinus on 16/6/4.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface PrizeModel : BaseModel

/**
 *  活动id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  活动标题
 */
@property(nonatomic,strong)NSString * title;
/**
 *  奖品图片
 */
@property(nonatomic,strong)NSString * img;
/**
 *  活动状态
 */
@property(nonatomic,strong)NSString * status;
/**
 *  奖品总数量
 */
@property(nonatomic,strong)NSString * tNum;
/**
 *  奖品剩余数量
 */
@property(nonatomic,strong)NSString * rNum;
/**
 *  活动开始时间
 */
@property(nonatomic,strong)NSString * sDate;
/**
 *  活动结束时间
 */
@property(nonatomic,strong)NSString * eDate;
/**
 *  活动内容地址
 */
@property(nonatomic,strong)NSString * content;

+(instancetype)sharedInstance;

-(void)loadDataWithPage:(int)page withSuccess:(void(^)(NSMutableArray * array))success withFailure:(void(^)(NSString * error))failure;


@end
