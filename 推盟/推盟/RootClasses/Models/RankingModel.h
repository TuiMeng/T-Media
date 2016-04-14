//
//  RankingModel.h
//  推盟
//
//  Created by joinus on 15/8/25.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface RankingModel : BaseModel


/**
 *  用户名
 */
@property(nonatomic,strong)NSString * user_name;
/**
 *  收入总额
 */
@property(nonatomic,strong)NSString * all_money;
/**
 *  手机号码
 */
@property(nonatomic,strong)NSString * user_mobile;
/**
 *  排名
 */
@property(nonatomic,strong)NSString * num;





@end
