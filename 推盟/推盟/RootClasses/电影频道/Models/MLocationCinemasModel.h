//
//  MLocationCinemasModel.h
//  推盟
//
//  Created by joinus on 16/3/7.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface MLocationCinemasModel : BaseModel

/**
 *  影院编号
 */
@property(nonatomic,strong)NSString * cinemaId;
/**
 *  影院名称
 */
@property(nonatomic,strong)NSString * cinemaName;
/**
 *  影院地址
 */
@property(nonatomic,strong)NSString * cinemaAddr;
/**
 *  场次数量
 */
@property(nonatomic,strong)NSString * plans;
/**
 *  距离
 */
@property(nonatomic,strong)NSString * distance;
/**
 *  经度
 */
@property(nonatomic,strong)NSString * lon;
/**
 *  纬度
 */
@property(nonatomic,strong)NSString * lat;
/**
 *  电话
 */
@property(nonatomic,strong)NSString * linkPhone;




@end
