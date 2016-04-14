//
//  GiftListModel.h
//  推盟
//
//  Created by joinus on 15/8/18.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "BaseModel.h"

@interface GiftListModel : BaseModel


/**
 *  礼品id
 */
@property(nonatomic,strong)NSString * id;
/**
 *  用户id
 */
@property(nonatomic,strong)NSString * user_id;
/**
 *礼品名称
 */
@property(nonatomic,strong)NSString * gift_name;
/**
 *  类型1为充值卡 2为电影票 3为兑换券 4实物订单
 */
@property(nonatomic,strong)NSString * type;
/**
 *  价格
 */
@property(nonatomic,strong)NSString * price;
/**
 *  已兑换数量
 */
@property(nonatomic,strong)NSString * reexchange_num;
/**
 *  总量
 */
@property(nonatomic,strong)NSString * all_num;
/**
 *  剩余量
 */
@property(nonatomic,strong)NSString * shengyu_num;
/**
 *  大图
 */
@property(nonatomic,strong)NSString * gift_image_big;
/**
 *  小图
 */
@property(nonatomic,strong)NSString * gift_image_small;
/**
 *  礼品描述
 */
@property(nonatomic,strong)NSString * gift_info;
/**
 *  礼品状态
 */
@property(nonatomic,strong)NSString * gift_status;
/**
 *  手机号码
 */
@property(nonatomic,strong)NSString * iphone_number;
/**
 *  有效起始日期
 */
@property(nonatomic,strong)NSString * start_time;
/**
 *  有效结束日期
 */
@property(nonatomic,strong)NSString * end_time;
@property(nonatomic,strong)NSString*status;
@end
